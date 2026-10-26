#include <condition_variable>
#include <deque>
#include <exception>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
class Queue {
  std::mutex mutex_;
  std::condition_variable ready_, space_;
  std::deque<int> items_;
  bool closed_ = false;

 public:
  void push(int x) {
    std::unique_lock<std::mutex> lock(mutex_);
    space_.wait(lock, [&] {
      return closed_ || items_.size() < 4;
    });
    require(!closed_, "push on closed queue");
    items_.push_back(x);
    lock.unlock();
    ready_.notify_one();
  }
  bool pop(int& x) {
    std::unique_lock<std::mutex> lock(mutex_);
    ready_.wait(lock, [&] {
      return closed_ || !items_.empty();
    });
    if (items_.empty()) {
      return false;
    }
    x = items_.front();
    items_.pop_front();
    lock.unlock();
    space_.notify_one();
    return true;
  }
  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;
    }
    ready_.notify_all();
    space_.notify_all();
  }
  void noise() {
    ready_.notify_all();
    space_.notify_all();
  }
};
struct Joiner {
  Queue& q;
  std::thread& t;
  ~Joiner() {
    q.close();
    if (t.joinable()) {
      t.join();
    }
  }
};
int main() {
  try {
    int completed = 0, errors = 0;
    for (int trial = 0; trial < 40; ++trial) {
      Queue q;
      int count = 0, sum = 0, failed = 0;
      std::exception_ptr unexpected;
      std::thread worker([&] {
        try {
          int value;
          while (q.pop(value)) {
            try {
              if (value % 17 == 0) {
                throw std::runtime_error("injected task error");
              }
              sum += value;
            } catch (const std::runtime_error&) {
              ++failed;
            }
            ++count;
          }
        } catch (...) {
          unexpected = std::current_exception();
        }
      });
      Joiner guard{q, worker};
      for (int i = 1; i <= 100; ++i) {
        q.noise();
        q.push(i);
      }
      q.close();
      q.close();
      worker.join();
      if (unexpected) {
        std::rethrow_exception(unexpected);
      }
      require(count == 100 && failed == 5 && sum == 4795, "drain result");
      int reject = 0;
      try {
        q.push(101);
      } catch (const std::runtime_error&) {
        ++reject;
      }
      require(reject == 1, "closed rejection");
      completed += count;
      errors += failed;
    }
    Queue empty;
    empty.close();
    int x = 0;
    require(!empty.pop(x), "empty close");
    // 满队列生产者可在close之前或之后到达wait；两种调度都必须收到拒绝。
    Queue full;
    for (int i = 0; i < 4; ++i) {
      full.push(i);
    }
    bool rejected = false;
    std::thread blocked([&] {
      try {
        full.push(9);
      } catch (const std::runtime_error&) {
        rejected = true;
      }
    });
    Joiner guard{full, blocked};
    full.close();
    blocked.join();
    require(rejected, "producer close");
    int drained = 0;
    while (full.pop(x)) {
      ++drained;
    }
    require(drained == 4, "full drain");
    std::cout << "PASS completed=" << completed << " task_errors=" << errors
              << " full_drain=4 empty_close=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
