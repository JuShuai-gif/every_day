#include <atomic>
#include <chrono>
#include <condition_variable>
#include <deque>
#include <functional>
#include <future>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>

class Worker {
  std::mutex mutex_;
  std::condition_variable work_, idle_;
  std::deque<std::function<void()>> queue_;
  bool closed_ = false;
  std::size_t active_ = 0, failures_ = 0, finished_ = 0;
  std::thread thread_;
  void loop() {
    for (;;) {
      std::function<void()> task;
      {
        std::unique_lock<std::mutex> lock(mutex_);
        work_.wait(lock, [&] {
          return closed_ || !queue_.empty();
        });
        if (queue_.empty()) {
          return;
        }
        task = std::move(queue_.front());
        queue_.pop_front();
        ++active_;
      }
      bool failed = false;
      try {
        task();
      } catch (...) {
        failed = true;
      }
      {
        // 失败路径同样归还在途计数；队列空不意味着任务完成。
        std::lock_guard<std::mutex> lock(mutex_);
        --active_;
        ++finished_;
        failures_ += failed;
      }
      idle_.notify_all();
    }
  }

 public:
  Worker()
      : thread_([this] {
          loop();
        }) {
  }
  Worker(const Worker&) = delete;
  Worker& operator=(const Worker&) = delete;
  ~Worker() {
    close();
    if (thread_.joinable()) {
      thread_.join();
    }
  }
  bool submit(std::function<void()> task) {
    if (!task) {
      throw std::invalid_argument("empty task");
    }
    {
      std::lock_guard<std::mutex> lock(mutex_);
      if (closed_ || queue_.size() >= 4) {
        return false;
      }
      queue_.push_back(std::move(task));
    }
    work_.notify_one();
    return true;
  }
  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;
    }
    work_.notify_all();
    idle_.notify_all();
  }
  bool wait_idle(std::chrono::milliseconds duration) {
    std::unique_lock<std::mutex> lock(mutex_);
    return idle_.wait_until(lock, std::chrono::steady_clock::now() + duration, [&] {
      return queue_.empty() && active_ == 0;
    });
  }
  void noise() {
    work_.notify_all();
    idle_.notify_all();
  }
  std::size_t queued() {
    std::lock_guard<std::mutex> lock(mutex_);
    return queue_.size();
  }
  std::pair<std::size_t, std::size_t> counters() {
    std::lock_guard<std::mutex> lock(mutex_);
    return {finished_, failures_};
  }
};
void check(bool x, const char* message) {
  if (!x) {
    throw std::runtime_error(message);
  }
}
int main() {
  try {
    for (int trial = 0; trial < 40; ++trial) {
      std::promise<void> started, release;
      auto gate = release.get_future().share();
      Worker worker;
      // RAII门闩确保断言异常时也先放行，再join，避免测试自身死锁。
      struct Release {
        std::promise<void>& p;
        bool done = false;
        void open() {
          if (!done) {
            p.set_value();
            done = true;
          }
        }
        ~Release() {
          open();
        }
      } guard{release};
      check(worker.wait_idle(std::chrono::milliseconds(0)), "initial idle");
      check(worker.submit([&] {
        started.set_value();
        gate.wait();
      }),
            "submit");
      check(started.get_future().wait_for(std::chrono::seconds(2)) == std::future_status::ready,
            "worker start timeout");
      check(worker.queued() == 0, "task must have left queue");
      worker.noise();
      check(!worker.wait_idle(std::chrono::milliseconds(1)), "empty queue is not idle");
      for (int j = 0; j < 4; ++j) {
        check(worker.submit([] {
          throw std::runtime_error("injected");
        }),
              "enqueue four");
      }
      check(!worker.submit([] {
      }),
            "bounded reject");
      worker.close();
      worker.close();
      check(!worker.submit([] {
      }),
            "close reject");
      guard.open();
      check(worker.wait_idle(std::chrono::seconds(2)), "drain timeout");
      check(worker.counters() == std::make_pair<std::size_t, std::size_t>(5, 4),
            "completion accounting");
    }
    {
      Worker empty;
      empty.close();
      check(empty.wait_idle(std::chrono::milliseconds(0)), "empty close");
    }
    bool invalid = false;
    {
      Worker w;
      try {
        w.submit({});
      } catch (const std::invalid_argument&) {
        invalid = true;
      }
    }
    check(invalid, "empty task rejection");
    std::cout << "PASS trials=40 completed=200 injected_failures=160 in_flight_timeout=40 "
                 "full/closed/empty_rejections empty_close=1\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
