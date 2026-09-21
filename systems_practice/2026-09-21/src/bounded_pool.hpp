#pragma once

#include <algorithm>
#include <chrono>
#include <condition_variable>
#include <cstddef>
#include <exception>
#include <future>
#include <memory>
#include <mutex>
#include <optional>
#include <stdexcept>
#include <thread>
#include <type_traits>
#include <utility>
#include <vector>

namespace practice {
using Clock = std::chrono::steady_clock;
enum class Admission { accepted, timeout, closed };

// 固定槽位环形队列：所有权仅在接受成功后移动；锁内不执行用户回调。
template <class T>
class BoundedQueue {
  static_assert(std::is_nothrow_move_constructible<T>::value,
                "Queue requires noexcept move construction");

 public:
  struct Snapshot {
    std::size_t size, high_water, producers_waiting, consumers_waiting;
    bool closed;
  };

  explicit BoundedQueue(std::size_t capacity) : slots_(capacity) {
    if (capacity == 0) {
      throw std::invalid_argument("capacity must be positive");
    }
  }
  BoundedQueue(const BoundedQueue&) = delete;
  BoundedQueue& operator=(const BoundedQueue&) = delete;

  Admission push(T& item, std::optional<Clock::time_point> deadline = std::nullopt) {
    std::unique_lock<std::mutex> lock(mutex_);
    auto ready = [this] {
      return closed_ || size_ < slots_.size();
    };
    // 等待计数用于确定性故障注入，不用 sleep 猜测另一线程的位置。
    struct WaitCounter {
      std::size_t& value;
      explicit WaitCounter(std::size_t& v) : value(v) {
        ++value;
      }
      ~WaitCounter() {
        --value;
      }
    };
    if (!ready()) {
      WaitCounter counter(producers_waiting_);
      if (deadline) {
        if (!not_full_.wait_until(lock, *deadline, ready)) {
          return Admission::timeout;
        }
      } else {
        not_full_.wait(lock, ready);
      }
    }
    // close 优先；deadline 只限制排队等待，不承诺业务完成时刻。
    if (closed_) {
      return Admission::closed;
    }
    slots_[(head_ + size_) % slots_.size()].emplace(std::move(item));
    ++size_;
    high_water_ = std::max(high_water_, size_);
    lock.unlock();
    not_empty_.notify_one();
    return Admission::accepted;
  }

  std::optional<T> pop() {
    std::unique_lock<std::mutex> lock(mutex_);
    ++consumers_waiting_;
    try {
      not_empty_.wait(lock, [this] {
        return closed_ || size_ != 0;
      });
    } catch (...) {
      --consumers_waiting_;
      throw;
    }
    --consumers_waiting_;
    if (size_ == 0) {
      return std::nullopt;  // closed 且排空，消费者退出。
    }
    std::optional<T> result(std::move(*slots_[head_]));
    slots_[head_].reset();
    head_ = (head_ + 1) % slots_.size();
    --size_;
    lock.unlock();
    not_full_.notify_one();
    return result;
  }

  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;
    }
    // 两类等待者都必须醒来；close 是状态变化，不是排空完成。
    not_empty_.notify_all();
    not_full_.notify_all();
  }

  Snapshot snapshot() const {
    std::lock_guard<std::mutex> lock(mutex_);
    return {size_, high_water_, producers_waiting_, consumers_waiting_, closed_};
  }

 private:
  mutable std::mutex mutex_;
  std::condition_variable not_empty_, not_full_;
  std::vector<std::optional<T>> slots_;
  std::size_t head_ = 0, size_ = 0, high_water_ = 0;
  std::size_t producers_waiting_ = 0, consumers_waiting_ = 0;
  bool closed_ = false;
};

class Pool {
  struct Job {
    virtual ~Job() = default;
    virtual void run() = 0;
  };
  template <class R>
  struct TypedJob final : Job {
    template <class F>
    explicit TypedJob(F&& fn) : task(std::forward<F>(fn)) {
    }
    void run() override {
      task();
    }  // 用户异常被 packaged_task 保存到 future。
    std::packaged_task<R()> task;
  };
  using Queue = BoundedQueue<std::unique_ptr<Job>>;

 public:
  template <class R>
  struct Submission {
    Admission status;
    std::future<R> result;  // 拒绝时无效，accepted 时必须消费 get()。
  };

  Pool(std::size_t workers, std::size_t capacity) : queue_(capacity) {
    if (workers == 0) {
      throw std::invalid_argument("worker count must be positive");
    }
    threads_.reserve(workers);
    try {
      for (std::size_t i = 0; i < workers; ++i) {
        threads_.emplace_back([this] {
          current_pool_ = this;
          while (auto job = queue_.pop()) {
            (*job)->run();
          }
          current_pool_ = nullptr;
        });
      }
    } catch (...) {
      // 部分线程创建失败：先解除等待再 join，构造失败也不遗留线程。
      queue_.close();
      join();
      throw;
    }
  }
  Pool(const Pool&) = delete;
  Pool& operator=(const Pool&) = delete;

  ~Pool() noexcept {
    try {
      shutdown();
    } catch (...) {
      // OS 同步失败/违反生命周期契约不可悄悄继续，避免析构活跃线程。
      std::terminate();
    }
  }

  template <class F>
  auto submit(F&& fn, std::optional<Clock::time_point> deadline = std::nullopt)
      -> Submission<std::invoke_result_t<std::decay_t<F>&>> {
    if (current_pool_ == this) {
      throw std::logic_error("recursive submission to the same pool is forbidden");
    }
    using R = std::invoke_result_t<std::decay_t<F>&>;
    auto typed = std::make_unique<TypedJob<R>>(std::forward<F>(fn));
    auto future = typed->task.get_future();
    std::unique_ptr<Job> job = std::move(typed);
    const auto status = queue_.push(job, deadline);
    if (status != Admission::accepted) {
      return {status, {}};
    }
    return {status, std::move(future)};
  }

  void close() {
    queue_.close();
  }
  void shutdown() {
    if (current_pool_ == this) {
      throw std::logic_error("worker cannot join its own pool");
    }
    // 多线程 shutdown 由 owner 串行调用；close 可与 submit 并发。
    close();
    join();
  }
  auto snapshot() const {
    return queue_.snapshot();
  }

 private:
  void join() {
    for (auto& thread : threads_) {
      if (thread.joinable()) {
        thread.join();
      }
    }
  }
  Queue queue_;
  std::vector<std::thread> threads_;
  inline static thread_local const Pool* current_pool_ = nullptr;
};
}  // namespace practice
