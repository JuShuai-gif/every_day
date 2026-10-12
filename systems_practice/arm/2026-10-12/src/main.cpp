#include <atomic>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <thread>

// noinline使实际A64读取/发布与RMW路径在汇编中可单独定位。
extern "C" __attribute__((noinline)) int observe(std::atomic<int>& flag) {
  return flag.load(std::memory_order_acquire);
}
extern "C" __attribute__((noinline)) void publish(std::atomic<int>& flag, int value) {
  flag.store(value, std::memory_order_release);
}
extern "C" __attribute__((noinline)) int ticket(std::atomic<int>& count) {
  return count.fetch_add(1, std::memory_order_relaxed);
}
struct Join {
  std::thread& thread;
  std::atomic<bool>& stop;
  ~Join() {
    stop.store(true);
    if (thread.joinable()) {
      thread.join();
    }
  }
};
void transfer(bool sequential, int count) {
  if (count < 0) {
    throw std::invalid_argument("negative transfer count");
  }
  std::atomic<int> ready{0};
  std::atomic<bool> stop{false};
  std::uint64_t sequence = 0, checksum = 0;
  // ready=0归生产者；ready=1归消费者。第二条release/acquire边防止过早复用。
  auto load = [&] {
    return sequential ? ready.load() : observe(ready);
  };
  auto store = [&](int x) {
    if (sequential) {
      ready.store(x);
    } else {
      publish(ready, x);
    }
  };
  std::thread producer([&] {
    for (int i = 1; i <= count; ++i) {
      while (load() != 0) {
        if (stop.load()) {
          return;
        }
        std::this_thread::yield();
      }
      if (stop.load()) {
        return;
      }
      sequence = static_cast<std::uint64_t>(i);
      checksum = sequence ^ 0xA55AA55AULL;
      store(1);
    }
  });
  Join join{producer, stop};
  for (int i = 1; i <= count; ++i) {
    while (load() != 1) {
      std::this_thread::yield();
    }
    if (sequence != static_cast<std::uint64_t>(i) || checksum != (sequence ^ 0xA55AA55AULL)) {
      throw std::runtime_error("publication or reuse failure");
    }
    store(0);
  }
}
int main() {
  try {
    for (int n : {0, 1, 10000}) {
      transfer(true, n);
      transfer(false, n);
    }
    std::atomic<int> counter{0};
    for (int i = 0; i < 1000; ++i) {
      if (ticket(counter) != i) {
        throw std::runtime_error("RMW old value");
      }
    }
    // 非法批次数是可执行的失败路径；不运行有数据竞争的relaxed payload负例。
    bool rejected = false;
    try {
      transfer(false, -1);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      throw std::runtime_error("negative count accepted");
    }
    std::cout << "PASS seq_cst/acquire_release transfers=20002 zero=2 ticket_old_values=1000\n"
              << "negative_count_rejected=1; no racy execution; lock_free="
              << counter.is_lock_free() << '\n'
              << "No timing; TSan is evidence for this execution, not an ARM memory-model proof\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
