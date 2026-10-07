#include <atomic>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <memory>
#include <mutex>
#include <sstream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

void check(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
struct Manifest {
  std::uint64_t revision;
  std::size_t features;
  float gain;
};
Manifest parse(const std::string& text) {
  std::istringstream in(text);
  std::string schema, rev, shape, trailing;
  float gain = 0;
  if (!(in >> schema >> rev >> shape >> gain) || (in >> trailing) || schema != "edge-v1") {
    throw std::invalid_argument("manifest schema/fields");
  }
  auto decimal = [](const std::string& s) {
    if (s.empty() || s.find_first_not_of("0123456789") != std::string::npos) {
      throw std::invalid_argument("unsigned decimal required");
    }
    std::size_t end = 0;
    auto n = std::stoull(s, &end);
    if (end != s.size()) {
      throw std::invalid_argument("revision suffix");
    }
    return n;
  };
  auto r = decimal(rev), k = decimal(shape);
  if (r == 0 || k != 16 || !std::isfinite(gain) || gain <= 0 || gain > 8) {
    throw std::invalid_argument("revision/shape/gain contract");
  }
  return {r, static_cast<std::size_t>(k), gain};
}
class Model {
 public:
  const Manifest manifest;
  explicit Model(Manifest m) : manifest(m), weights_(m.features, m.gain) {
  }
  float infer(const std::vector<float>& x) const {
    if (x.size() != weights_.size()) {
      throw std::invalid_argument("shape mismatch");
    }
    float y = 0;
    for (std::size_t i = 0; i < x.size(); ++i) {
      if (!std::isfinite(x[i])) {
        throw std::invalid_argument("nonfinite input");
      }
      y += x[i] * weights_[i];
    }
    return y;
  }

 private:
  std::vector<float> weights_;
};
class Registry {
 public:
  using Lease = std::shared_ptr<const Model>;
  Lease acquire() const {
    return std::atomic_load_explicit(&active_, std::memory_order_acquire);
  }
  // 在发布锁之外构造和预热。失败时当前版本保持不变。
  bool publish(const std::string& text, std::uint64_t expected, bool fail_warmup = false) {
    auto candidate = std::make_shared<const Model>(parse(text));
    if (fail_warmup ||
        candidate->infer(std::vector<float>(16, 1)) != 16 * candidate->manifest.gain) {
      throw std::runtime_error("candidate warmup failed");
    }
    std::lock_guard<std::mutex> lock(writer_);
    auto old = acquire();
    if (closed_ || (old ? old->manifest.revision : 0) != expected ||
        candidate->manifest.revision <= expected || !retired_.expired()) {
      return false;
    }
    // active + retired 最多两个已发布版本；候选构造的额外内存需另计。
    retired_ = old;
    std::atomic_store_explicit(&active_, std::move(candidate), std::memory_order_release);
    return true;
  }
  void close() {
    std::lock_guard<std::mutex> lock(writer_);
    closed_ = true;
    std::atomic_store_explicit(&active_, Lease{}, std::memory_order_release);
  }

 private:
  mutable std::shared_ptr<const Model> active_;
  std::weak_ptr<const Model> retired_;
  std::mutex writer_;
  bool closed_ = false;
};
// 已创建线程必须在异常退出时全部join。
class JoinedThreads {
 public:
  std::vector<std::thread> items;
  ~JoinedThreads() {
    for (auto& t : items) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
int main() {
  try {
    Registry r;
    check(!r.acquire(), "empty registry");
    check(r.publish("edge-v1 1 16 1", 0), "initial publish");
    auto old = r.acquire();
    std::weak_ptr<const Model> weak = old;
    const std::vector<float> input(16, 1);
    check(r.publish("edge-v1 2 16 2", 1), "publish 2");
    check(old->infer(input) == 16 && r.acquire()->infer(input) == 32, "lease version split");
    check(!r.publish("edge-v1 3 16 3", 2), "retired generation backpressure");
    old.reset();
    check(weak.expired(), "retired release");
    const std::vector<std::string> bad = {"",
                                          "edge-v0 3 16 3",
                                          "edge-v1 -3 16 3",
                                          "edge-v1 3 17 3",
                                          "edge-v1 3 16 0",
                                          "edge-v1 3 16 9",
                                          "edge-v1 3 16 nan",
                                          "edge-v1 3 16 3 extra",
                                          "edge-v1 9999999999999999999999999 16 3"};
    for (const auto& text : bad) {
      bool rejected = false;
      try {
        r.publish(text, 2);
      } catch (const std::exception&) {
        rejected = true;
      }
      check(rejected && r.acquire()->manifest.revision == 2, "invalid candidate rollback");
    }
    bool warmup = false;
    try {
      r.publish("edge-v1 3 16 3", 2, true);
    } catch (const std::runtime_error&) {
      warmup = true;
    }
    check(warmup && r.acquire()->manifest.revision == 2, "warmup rollback");
    check(!r.publish("edge-v1 3 16 3", 1), "stale expected revision");
    check(!r.publish("edge-v1 2 16 2", 2), "nonmonotonic revision");
    bool shape = false;
    try {
      r.acquire()->infer({});
    } catch (const std::invalid_argument&) {
      shape = true;
    }
    check(shape, "empty input rejected");
    // 两个并行管理请求使用相同expected，只允许一个提交。
    std::atomic<int> won{0};
    {
      JoinedThreads group;
      for (int i = 3; i <= 4; ++i) {
        group.items.emplace_back([&, i] {
          if (r.publish("edge-v1 " + std::to_string(i) + " 16 3", 2)) {
            ++won;
          }
        });
      }
    }
    check(won == 1, "concurrent stale writer gate");
    std::atomic<int> faults{0}, requests{0};
    {
      JoinedThreads group;
      for (int i = 0; i < 4; ++i) {
        group.items.emplace_back([&] {
          for (int j = 0; j < 5000; ++j) {
            auto lease = r.acquire();
            if (lease && lease->infer(input) != 16 * lease->manifest.gain) {
              ++faults;
            }
            ++requests;
          }
        });
      }
      auto rev = r.acquire()->manifest.revision;
      for (int j = 0; j < 500; ++j) {
        if (r.publish("edge-v1 " + std::to_string(rev + 1) + " 16 4", rev)) {
          ++rev;
        }
      }
    }
    check(faults == 0 && requests == 20000, "request snapshots");
    auto pending = r.acquire();
    r.close();
    check(!r.acquire() && pending->infer(input) == 16 * pending->manifest.gain,
          "close drains held lease");
    check(!r.publish("edge-v1 9999 16 1", 0), "closed publication rejected");
    pending.reset();
    std::cout << "PASS requests=" << requests << " faults=" << faults
              << " invalid_manifests=" << bad.size()
              << " warmup_rollback=1 stale_writer=1 retirement_backpressure=1 close_lease=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
