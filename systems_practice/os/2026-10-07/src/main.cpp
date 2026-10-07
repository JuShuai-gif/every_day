#include <atomic>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
void check(bool x, const char* s) {
  if (!x) {
    throw std::runtime_error(s);
  }
}
class Spin {
  std::atomic_flag held_ = ATOMIC_FLAG_INIT;

 public:
  void lock() noexcept {
    while (held_.test_and_set(std::memory_order_acquire)) {
      std::this_thread::yield();
    }
  }
  void unlock() noexcept {
    held_.clear(std::memory_order_release);
  }
};
// 仅模拟每CPU嵌套状态；宿主线程不能操作内核中断屏蔽。
struct InterruptState {
  bool enabled = true, saved = false;
  unsigned depth = 0;
  void push() {
    bool old = enabled;
    enabled = false;
    if (depth == 0) {
      saved = old;
    }
    ++depth;
  }
  void pop() {
    if (enabled || depth == 0) {
      throw std::logic_error("unbalanced pop / interruptible");
    }
    --depth;
    if (depth == 0 && saved) {
      enabled = true;
    }
  }
};
class Group {
 public:
  std::vector<std::thread> threads;
  ~Group() {
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
int main() {
  try {
    for (bool initial : {false, true}) {
      InterruptState state;
      state.enabled = initial;
      state.push();
      state.push();
      check(!state.enabled && state.depth == 2, "nest");
      state.pop();
      check(!state.enabled, "inner must not enable");
      state.pop();
      check(state.enabled == initial && state.depth == 0, "restore initial");
      bool failed = false;
      try {
        state.pop();
      } catch (const std::logic_error&) {
        failed = true;
      }
      check(failed, "underflow rejected");
    }
    InterruptState bad;
    bad.push();
    bad.enabled = true;
    bool failed = false;
    try {
      bad.pop();
    } catch (const std::logic_error&) {
      failed = true;
    }
    check(failed, "early enable rejected");
    Spin mutex;
    int count = 0, mirror = 0;
    {
      Group group;
      for (int i = 0; i < 4; ++i) {
        group.threads.emplace_back([&] {
          for (int j = 0; j < 10000; ++j) {
            std::lock_guard<Spin> guard(mutex);
            ++count;
            mirror = count;
          }
        });
      }
    }
    check(count == 40000 && mirror == 40000, "mutual exclusion and publication");
    try {
      std::lock_guard<Spin> guard(mutex);
      throw std::runtime_error("injected");
    } catch (const std::runtime_error&) {
    }
    {
      std::lock_guard<Spin> guard(mutex);
      ++count;
    }
    check(count == 40001, "exception unlock");
    std::cout << "PASS protected_updates=40000 exception_unlock=1 nested_initial_states=2 "
                 "invalid_pop_cases=3\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
