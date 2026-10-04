#pragma once
#include <chrono>
#include <condition_variable>
#include <functional>
#include <future>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

// 独立教学实现：固定槽数约束排队任务，不约束任务自身捕获的字节数。
class Pool {
  std::mutex mutex_;
  std::condition_variable work_, space_, idle_;
  std::vector<std::function<void()>> slots_;
  std::vector<std::thread> workers_;
  std::size_t head_ = 0, tail_ = 0, queued_ = 0, active_ = 0;
  bool closed_ = false;
  inline static thread_local const Pool* current_ = nullptr;

  void worker() {
    current_ = this;
    for (;;) {
      std::function<void()> task;
      {
        std::unique_lock<std::mutex> lock(mutex_);
        work_.wait(lock, [&] {
          return closed_ || queued_ != 0;
        });
        if (queued_ == 0 && closed_) {
          break;
        }
        task = std::move(slots_[head_]);
        head_ = (head_ + 1) % slots_.size();
        --queued_;
        ++active_;  // 出队与在途登记必须处于同一个临界区。
      }
      space_.notify_one();
      task();     // packaged_task把用户异常保存给future。
      task = {};  // 捕获资源释放也属于在途任务生命周期，不能持队列锁析构。
      {
        std::lock_guard<std::mutex> lock(mutex_);
        --active_;
        if (queued_ == 0 && active_ == 0) {
          idle_.notify_all();
        }
      }
    }
    current_ = nullptr;
  }

 public:
  Pool(std::size_t count, std::size_t capacity, int fail_after = -1) : slots_(capacity) {
    if (count == 0 || capacity == 0) {
      throw std::invalid_argument("zero workers/capacity");
    }
    workers_.reserve(count);
    try {
      for (std::size_t i = 0; i < count; ++i) {
        if (static_cast<int>(i) == fail_after) {
          throw std::runtime_error("injected thread creation failure");
        }
        workers_.emplace_back([this] {
          worker();
        });
      }
    } catch (...) {
      close();
      for (auto& t : workers_) {
        t.join();
      }
      throw;
    }
  }
  Pool(const Pool&) = delete;
  Pool& operator=(const Pool&) = delete;
  ~Pool() {
    // 所有者必须在外部线程析构；并发调用者已结束，任务最终可返回。
    close();
    for (auto& t : workers_) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
  template <class F>
  std::future<int> submit_for(F&& f, std::chrono::milliseconds timeout) {
    if (current_ == this) {
      throw std::logic_error("recursive blocking submission forbidden");
    }
    auto task = std::make_shared<std::packaged_task<int()>>(std::forward<F>(f));
    auto result = task->get_future();
    std::function<void()> callable = [task] {
      (*task)();
    };
    {
      std::unique_lock<std::mutex> lock(mutex_);
      // 一次wait_for使用固定等待期限；伪唤醒不能重启整个超时时间。
      if (!space_.wait_for(lock, timeout, [&] {
            return closed_ || queued_ < slots_.size();
          })) {
        throw std::runtime_error("queue timeout");
      }
      if (closed_) {
        throw std::runtime_error("pool closed");
      }
      slots_[tail_] = std::move(callable);
      tail_ = (tail_ + 1) % slots_.size();
      ++queued_;  // 这里是成功提交的线性化点。
    }
    work_.notify_one();
    return result;
  }
  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;  // 幂等；拒绝新任务，已接收任务继续排空。
    }
    work_.notify_all();
    space_.notify_all();  // 关闭必须唤醒正在等空位的生产者。
  }
  void wait_idle() {
    if (current_ == this) {
      throw std::logic_error("worker cannot wait for itself");
    }
    std::unique_lock<std::mutex> lock(mutex_);
    idle_.wait(lock, [&] {
      return queued_ == 0 && active_ == 0;
    });
  }
};
