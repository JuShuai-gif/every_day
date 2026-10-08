#include <atomic>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

void check(bool b) {
  if (!b) {
    throw std::runtime_error("wait contract");
  }
}
// 有界单槽：谓词与槽值共用锁；通知不是可累计的数据。
class Slot {
  std::mutex m_;
  std::condition_variable cv_;
  bool full_ = false, closed_ = false;
  int value_ = 0;

 public:
  bool put(int value) {
    std::unique_lock<std::mutex> lock(m_);
    cv_.wait(lock, [&] {
      return !full_ || closed_;
    });
    if (closed_) {
      return false;
    }
    value_ = value;
    full_ = true;
    lock.unlock();
    cv_.notify_all();
    return true;
  }
  bool get(int& value) {
    std::unique_lock<std::mutex> lock(m_);
    cv_.wait(lock, [&] {
      return full_ || closed_;
    });
    if (!full_) {
      return false;
    }
    value = value_;
    full_ = false;
    lock.unlock();
    cv_.notify_all();
    return true;
  }
  void close() {
    {
      std::lock_guard<std::mutex> lock(m_);
      closed_ = true;
    }
    cv_.notify_all();
  }
  void noise() {
    cv_.notify_all();
  }
};
struct Threads {
  Slot& slot;
  std::vector<std::thread> ts;
  ~Threads() {
    slot.close();
    for (auto& t : ts) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
  void join() {
    for (auto& t : ts) {
      t.join();
    }
  }
};
// 与实际xv6新接口一致的串行时序模型；它不是内核调度器。
struct WaitState {
  bool registered = false, sleeping = false;
  void prepare() {
    registered = true;
  }
  void wake() {
    if (registered) {
      registered = false;
      sleeping = false;
    }
  }
  void sleep() {
    sleeping = registered;
  }
};
int main() {
  try {
    WaitState lost;
    lost.wake();
    lost.prepare();
    lost.sleep();
    check(lost.sleeping);
    WaitState early;
    early.prepare();
    early.wake();
    early.sleep();
    check(!early.sleeping);
    WaitState late;
    late.prepare();
    late.sleep();
    late.wake();
    check(!late.sleeping);
    Slot slot;
    std::atomic<bool> bad{false};
    int received = 0;
    Threads threads{slot, {}};
    threads.ts.emplace_back([&] {
      for (int i = 0; i < 20000; ++i) {
        if (!slot.put(i)) {
          bad = true;
          return;
        }
      }
      slot.close();
    });
    threads.ts.emplace_back([&] {
      int value;
      while (slot.get(value)) {
        if (value != received) {
          bad = true;
        }
        ++received;
      }
    });
    threads.ts.emplace_back([&] {
      for (int i = 0; i < 20000; ++i) {
        slot.noise();
      }
    });
    threads.join();
    check(!bad && received == 20000);
    check(!slot.put(9));
    Slot empty;
    empty.close();
    int x = 77;
    check(!empty.get(x) && x == 77);
    Slot draining;
    check(draining.put(5));
    draining.close();
    check(draining.get(x) && x == 5);
    check(!draining.get(x));
    std::cout << "PASS 20000 ordered transfers, 20000 noise notifications, close/drain/reject, "
                 "three wait schedules\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
