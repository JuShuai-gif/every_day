#include <atomic>
#include <cmath>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <thread>
#include <vector>

void check(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
struct Bundle {
  static std::atomic<int> live;
  const int version;
  const std::vector<float> weights;
  const float scale;
  Bundle(int v, std::vector<float> w, float s) : version(v), weights(std::move(w)), scale(s) {
    ++live;
  }
  ~Bundle() {
    --live;
  }
};
std::atomic<int> Bundle::live{0};
using Snapshot = std::shared_ptr<const Bundle>;
Snapshot prepare(int version, std::size_t n, float scale, int fail_stage = 0) {
  if (version < 1 || n == 0 || n > 4096 || !std::isfinite(scale) || scale <= 0) {
    throw std::invalid_argument("invalid bundle metadata");
  }
  // 分配、解析、校验全部发生在发布前；异常由局部RAII对象回收。
  std::vector<float> weights(n, static_cast<float>(version));
  if (fail_stage == 1) {
    throw std::runtime_error("injected parse failure");
  }
  auto candidate = std::make_shared<Bundle>(version, std::move(weights), scale);
  if (fail_stage == 2) {
    throw std::runtime_error("injected validation failure");
  }
  check(candidate->weights.front() == version, "invalid payload");
  return candidate;
}
class Registry {
  Snapshot current_;

 public:
  explicit Registry(Snapshot initial) : current_(std::move(initial)) {
    check(bool(current_), "empty initial version");
  }
  Snapshot acquire() const {
    return std::atomic_load(&current_);
  }
  void reload(int v, std::size_t n, float scale, int fail_stage = 0) {
    auto next = prepare(v, n, scale, fail_stage);
    // 一次发布整个不可变bundle；不能把版本、scale和weights分开更新。
    std::atomic_store(&current_, std::move(next));
  }
  bool lock_free() const {
    return std::atomic_is_lock_free(&current_);
  }
};
class Joiner {
  std::vector<std::thread>& threads_;

 public:
  explicit Joiner(std::vector<std::thread>& t) : threads_(t) {
  }
  ~Joiner() {
    for (auto& t : threads_) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
int main() {
  try {
    {
      Registry registry(prepare(1, 257, 0.5f));
      auto old = registry.acquire();
      std::weak_ptr<const Bundle> retired = old;
      int failures = 0;
      for (int i = 0; i < 1000; ++i) {
        for (int stage : {1, 2}) {
          try {
            registry.reload(2, 257, 0.5f, stage);
          } catch (const std::runtime_error&) {
            ++failures;
          }
          check(registry.acquire() == old && Bundle::live == 1, "rollback failed");
        }
      }
      for (auto n : {std::size_t(0), std::size_t(4097)}) {
        try {
          registry.reload(2, n, 0.5f);
        } catch (const std::invalid_argument&) {
          ++failures;
        }
      }
      registry.reload(2, 257, 0.5f);
      check(old->version == 1 && old->weights[256] == 1, "lease invalidated");
      check(!retired.expired() && Bundle::live == 2, "retired too soon");
      old.reset();
      check(retired.expired() && Bundle::live == 1, "retired not reclaimed");
      std::atomic<int> bad{0};
      std::atomic<int> reads{0};
      std::vector<std::thread> threads;
      {
        Joiner join(threads);
        for (int r = 0; r < 4; ++r) {
          threads.emplace_back([&] {
            for (int j = 0; j < 5000; ++j) {
              const auto snapshot = registry.acquire();
              // 同一请求只取一次快照，所有字段共享同一个版本寿命。
              if (snapshot->weights.size() != 257 || snapshot->scale != 0.5f ||
                  snapshot->weights.front() != snapshot->version ||
                  snapshot->weights.back() != snapshot->version) {
                ++bad;
              }
              ++reads;
            }
          });
        }
        for (int v = 3; v < 503; ++v) {
          registry.reload(v, 257, 0.5f);
        }
      }
      check(bad == 0 && reads == 20000, "mixed snapshot");
      check(registry.acquire()->version == 502 && failures == 2002, "test coverage");
      std::cout << "PASS rollback=" << failures << " readers=" << reads
                << " publishes=501 lock_free=" << registry.lock_free() << '\n';
    }
    check(Bundle::live == 0, "resource leak");
    std::cout << "PASS final_live=0 old_lease_survives_and_reclaims\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
