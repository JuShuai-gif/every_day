#include <atomic>
#include <iostream>
#include <memory>
#include <mutex>
#include <shared_mutex>
#include <stdexcept>
#include <thread>
#include <vector>
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
struct State {
  int generation;
  std::vector<int> weights;
  static std::atomic<int> live;
  explicit State(int g) : generation(g), weights(32, g) {
    ++live;
  }
  ~State() {
    --live;
  }
};
std::atomic<int> State::live{0};
class Store {
  mutable std::shared_mutex mutex_;
  std::shared_ptr<const State> current_ = std::make_shared<const State>(0);

 public:
  std::shared_ptr<const State> read() const {
    // 锁只保护shared_ptr本身；复制所有权使解锁后的读者仍持有旧数据。
    std::shared_lock<std::shared_mutex> lock(mutex_);
    return current_;
  }
  void publish(int generation, bool fail = false) {
    if (generation < 0) {
      throw std::invalid_argument("generation");
    }
    auto candidate = std::make_shared<const State>(generation);
    if (fail) {
      throw std::runtime_error("injected validation failure");
    }
    std::unique_lock<std::shared_mutex> lock(mutex_);
    current_ = std::move(candidate);
  }
};
struct Joined {
  std::vector<std::thread> threads;
  ~Joined() {
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
int main() {
  try {
    int rejects = 0;
    {
      Store store;
      auto held = store.read();
      store.publish(1);
      check(held->generation == 0 && store.read()->generation == 1);
      for (bool fail : {false, true}) {
        try {
          store.publish(fail ? 2 : -1, fail);
        } catch (const std::exception&) {
          ++rejects;
        }
        check(store.read()->generation == 1);
      }
      std::atomic<int> reads{0};
      std::atomic<bool> bad{false};
      {
        Joined group;
        for (int t = 0; t < 4; ++t) {
          group.threads.emplace_back([&] {
            for (int i = 0; i < 5000; ++i) {
              auto s = store.read();
              for (int w : s->weights) {
                if (w != s->generation) {
                  bad = true;
                }
              }
              ++reads;
            }
          });
        }
        for (int i = 2; i <= 501; ++i) {
          store.publish(i);
        }
      }
      check(!bad && reads == 20000 && held->generation == 0 && store.read()->generation == 501);
      std::cout << "PASS reads=" << reads << " rejects=" << rejects
                << " old_generation=" << held->generation << " final=501\n";
    }
    check(State::live == 0);
    std::cout << "live=0\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
