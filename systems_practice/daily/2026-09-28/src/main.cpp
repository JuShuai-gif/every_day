#include <algorithm>
#include <chrono>
#include <future>
#include <iostream>
#include <sstream>

#include "deployment.hpp"

namespace {
void require(bool condition, const char* reason) {
  if (!condition) {
    throw std::runtime_error(reason);
  }
}
template <class F>
void rejects(F action) {
  bool caught = false;
  try {
    action();
  } catch (const std::exception&) {
    caught = true;
  }
  require(caught, "expected rejection");
}
edge::Snapshot candidate(std::uint64_t version) {
  std::ostringstream text;
  text << "EDGE1 " << version << " 8 " << version * 8;
  for (int i = 0; i < 8; ++i) {
    text << ' ' << version;
  }
  std::istringstream input(text.str());
  return edge::stage(input);
}
void checks() {
  edge::Registry registry;
  rejects([&] {
    registry.acquire();
  });
  require(registry.publish(registry.begin(), candidate(1)), "initial publish");
  auto request = registry.acquire();
  std::weak_ptr<const edge::Model> old = request;
  auto slow = registry.begin();
  auto latest = registry.begin();
  require(registry.publish(latest, candidate(3)), "latest publish");
  require(!registry.publish(slow, candidate(2)), "stale candidate accepted");
  require(!registry.publish(latest, candidate(4)), "ticket replay accepted");
  require(request->infer(std::vector<float>(8, 1)) == 8, "old request changed");
  request.reset();
  require(old.expired(), "retired model leaked");
  const std::vector<std::string> invalid = {"BAD 4 8 0",
                                            "EDGE1 0 8 0",
                                            "EDGE1 4 9 0",
                                            "EDGE1 4 8 1 0 0 0 0 0 0 0 0",
                                            "EDGE1 4 8 0 0",
                                            "EDGE1 4 8 0 0 0 0 0 0 0 0 0 extra",
                                            "EDGE1 4 8 0 nan 0 0 0 0 0 0 0"};
  for (const auto& value : invalid) {
    const auto ticket = registry.begin();
    rejects([&] {
      std::istringstream input(value);
      registry.publish(ticket, edge::stage(input));
    });
    require(registry.acquire()->version() == 3, "failed load replaced service");
  }
  rejects([&] {
    registry.acquire()->infer({});
  });
  rejects([&] {
    registry.acquire()->infer(std::vector<float>(8, std::numeric_limits<float>::infinity()));
  });
  rejects([&] {
    registry.publish(registry.begin(), {});
  });
  auto pinned = registry.acquire();
  auto before_close = registry.begin();
  registry.close();
  registry.close();
  rejects([&] {
    registry.acquire();
  });
  rejects([&] {
    registry.begin();
  });
  require(!registry.publish(before_close, candidate(5)), "resurrected after close");
  require(pinned->infer(std::vector<float>(8, 1)) == 24, "close invalidated request");
  std::cout << "contracts: invalid=7 stale/replay/failure/close/lifetime PASS\n";
}
void concurrent() {
  edge::Registry registry;
  require(registry.publish(registry.begin(), candidate(1)), "initial");
  std::vector<std::future<void>> readers;
  // future 的析构等待任务，异常通过 get 传回；不留 detached worker。
  for (int worker = 0; worker < 4; ++worker) {
    readers.push_back(std::async(std::launch::async, [&] {
      for (int i = 0; i < 5000; ++i) {
        auto model = registry.acquire();
        require(model->infer(std::vector<float>(8, 1)) == float(model->version() * 8),
                "mixed model generation");
      }
    }));
  }
  for (std::uint64_t v = 2; v <= 1001; ++v) {
    require(registry.publish(registry.begin(), candidate(v)), "publish failed");
  }
  for (auto& reader : readers) {
    reader.get();
  }
  registry.close();
  std::cout << "concurrency: 20000 requests / 1000 publications PASS\n";
}
void benchmark() {
  edge::Registry registry;
  registry.publish(registry.begin(), candidate(2));
  const std::vector<float> x(8, 1);
  std::vector<double> times;
  volatile float checksum = 0;
  // 只测无发布竞争的 acquire+夹具推理；不是 GPU/NPU/服务端到端时间。
  for (int sample = -20; sample < 100; ++sample) {
    auto begin = std::chrono::steady_clock::now();
    float sum = 0;
    for (int i = 0; i < 1000; ++i) {
      sum += registry.acquire()->infer(x);
    }
    auto end = std::chrono::steady_clock::now();
    checksum = sum;
    if (sample >= 0) {
      times.push_back(std::chrono::duration<double, std::micro>(end - begin).count() / 1000);
    }
  }
  require(checksum == 16000, "benchmark checksum");
  std::sort(times.begin(), times.end());
  std::cout << "CPU acquire+fixture us/request p50=" << times[49] << " p95=" << times[94]
            << " warmup=20 samples=100 batch=1000\n";
}
}  // namespace
int main() {
  try {
    checks();
    concurrent();
    benchmark();
  } catch (const std::exception& error) {
    std::cerr << error.what() << '\n';
    return 1;
  }
}
