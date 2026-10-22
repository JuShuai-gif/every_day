#include <atomic>
#include <iostream>
#include <stdexcept>
#include <thread>
#include <vector>

// 这两个非内联函数用于观察CPU发布/获取，不能代表设备完成。
__attribute__((noinline)) void publish(std::atomic<int>& flag, int state) {
  flag.store(state, std::memory_order_release);
}
__attribute__((noinline)) int acquire(const std::atomic<int>& flag) {
  return flag.load(std::memory_order_acquire);
}
int main() {
  try {
    std::atomic<int> state{0};
    std::vector<int> input(17, 0);
    std::atomic<bool> failed{false};
    std::thread producer([&] {
      for (int frame = 1; frame <= 10000; ++frame) {
        while (acquire(state) != 0) {
          std::this_thread::yield();
        }
        for (auto& x : input) {
          x = frame;
        }
        publish(state, 1);
      }
    });
    // 主线程模拟SDK消费者，读取后反向发布free，避免生产者覆盖。
    for (int frame = 1; frame <= 10000; ++frame) {
      while (acquire(state) != 1) {
        std::this_thread::yield();
      }
      for (int x : input) {
        if (x != frame) {
          failed.store(true);
        }
      }
      publish(state, 0);
    }
    producer.join();
    if (failed.load()) {
      throw std::runtime_error("CPU publication mismatch");
    }
    // 安全状态反例：CPU已发布并不意味着模拟设备已经完成。
    bool submitted = true, device_completed = false, client_cancelled = true;
    const bool unsafe_reuse = submitted && client_cancelled;
    const bool safe_reuse = device_completed;
    if (!unsafe_reuse || safe_reuse) {
      throw std::runtime_error("counterexample");
    }
    device_completed = true;
    if (!device_completed) {
      throw std::runtime_error("completion missing");
    }
    std::cout << "PASS CPU frames=10000 elements=17 bidirectional publication; early-reuse "
                 "counterexample; device simulation only\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
