#include <atomic>
#include <chrono>
#include <condition_variable>
#include <future>
#include <iostream>
#include <memory>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

using Clock = std::chrono::steady_clock;
void check(bool ok, const char* what) {
  if (!ok) {
    throw std::runtime_error(what);
  }
}
using Job = std::packaged_task<int()>;
enum class Push { accepted, timeout, closed };

class Queue {
 public:
  explicit Queue(std::size_t capacity) : slots_(capacity) {
    if (!capacity) {
      throw std::invalid_argument("zero capacity");
    }
  }
  // 失败不夺走调用者的任务；只在持锁提交时转移唯一所有权。
  Push push(std::unique_ptr<Job>& job, Clock::time_point deadline) {
    if (!job || !job->valid()) {
      throw std::invalid_argument("invalid job");
    }
    std::unique_lock<std::mutex> lock(mutex_);
    ++waiting_;
    bool ready = false;
    try {
      ready = space_.wait_until(lock, deadline, [&] {
        return closed_ || size_ < slots_.size();
      });
    } catch (...) {
      --waiting_;
      throw;
    }
    --waiting_;
    if (closed_) {
      return Push::closed;
    }
    if (!ready) {
      return Push::timeout;
    }
    slots_[(head_ + size_) % slots_.size()] = std::move(job);
    ++size_;
    lock.unlock();
    data_.notify_one();
    return Push::accepted;
  }
  std::unique_ptr<Job> pop() {
    std::unique_lock<std::mutex> lock(mutex_);
    data_.wait(lock, [&] {
      return closed_ || size_ != 0;
    });
    if (!size_) {
      return {};
    }
    auto job = std::move(slots_[head_]);
    head_ = (head_ + 1) % slots_.size();
    --size_;
    lock.unlock();
    space_.notify_one();
    return job;
  }
  void close() {
    {
      std::lock_guard<std::mutex> lock(mutex_);
      closed_ = true;
    }
    // 满队列上的生产者也必须醒来；关闭后已有任务仍被消费。
    data_.notify_all();
    space_.notify_all();
  }
  std::size_t waiting() {
    std::lock_guard<std::mutex> lock(mutex_);
    return waiting_;
  }

 private:
  std::vector<std::unique_ptr<Job>> slots_;
  std::size_t head_ = 0, size_ = 0, waiting_ = 0;
  bool closed_ = false;
  std::mutex mutex_;
  std::condition_variable data_, space_;
};

class Workers {
 public:
  Workers(Queue& queue, int count, int fail_before = -1) : queue_(queue) {
    if (count <= 0) {
      throw std::invalid_argument("zero workers");
    }
    try {
      threads_.reserve(static_cast<std::size_t>(count));
      for (int i = 0; i < count; ++i) {
        if (i == fail_before) {
          throw std::runtime_error("injected startup failure");
        }
        threads_.emplace_back([this] {
          while (auto job = queue_.pop()) {
            // 用户异常进入 future，worker 可以继续；任务句柄只被调用一次。
            (*job)();
          }
        });
      }
    } catch (...) {
      stop();
      throw;
    }
  }
  ~Workers() {
    stop();
  }
  Workers(const Workers&) = delete;
  Workers& operator=(const Workers&) = delete;

 private:
  void stop() {
    queue_.close();
    for (auto& t : threads_) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
  Queue& queue_;
  std::vector<std::thread> threads_;
};

std::unique_ptr<Job> task(int i) {
  return std::make_unique<Job>([i] {
    return i;
  });
}
void tests() {
  int rejects = 0;
  try {
    Queue q(0);
  } catch (const std::invalid_argument&) {
    ++rejects;
  }
  Queue q(1);
  auto a = task(1), b = task(2);
  check(q.push(a, Clock::now()) == Push::accepted && !a, "initial commit");
  check(q.push(b, Clock::now()) == Push::timeout && b, "timeout ownership");
  auto pending = std::async(std::launch::async, [&] {
    return q.push(b, Clock::now() + std::chrono::seconds(5));
  });
  const auto limit = Clock::now() + std::chrono::seconds(2);
  while (!q.waiting() && Clock::now() < limit) {
    std::this_thread::yield();
  }
  const bool observed = q.waiting() != 0;
  q.close();
  q.close();
  check(pending.get() == Push::closed && b && observed, "blocked producer close");
  auto accepted = q.pop();
  check(accepted != nullptr && !q.pop(), "drain before EOF");
  auto f = accepted->get_future();
  (*accepted)();
  check(f.get() == 1, "drained job");
  check(q.push(b, Clock::now()) == Push::closed, "reject after close");
  std::unique_ptr<Job> empty;
  try {
    q.push(empty, Clock::now());
  } catch (const std::invalid_argument&) {
    ++rejects;
  }
  Queue startup(2);
  try {
    Workers w(startup, 3, 1);
  } catch (const std::runtime_error&) {
    ++rejects;
  }

  // 取走并不等于完成：已关闭的空队列不能缩短在途任务的寿命。
  Queue gated(1);
  std::promise<void> entered, release;
  auto gate = release.get_future().share();
  auto slow = std::make_unique<Job>([&] {
    entered.set_value();
    gate.wait();
    return 9;
  });
  auto done = slow->get_future();
  {
    Workers w(gated, 1);
    check(gated.push(slow, Clock::now()) == Push::accepted, "gated submit");
    entered.get_future().wait();
    gated.close();
    const bool in_flight =
        done.wait_for(std::chrono::milliseconds(0)) == std::future_status::timeout;
    release.set_value();
    check(in_flight, "empty is not complete");
  }
  check(done.get() == 9 && rejects == 3, "lifecycle checks");

  for (std::size_t capacity : {1u, 8u}) {
    Queue jobs(capacity);
    std::atomic<int> submitted{0};
    std::vector<std::future<int>> futures(400);
    {
      Workers consumers(jobs, 2);
      std::vector<std::future<void>> producers;
      for (int p = 0; p < 4; ++p) {
        producers.push_back(std::async(std::launch::async, [&, p] {
          for (int i = p * 100; i < (p + 1) * 100; ++i) {
            auto job = std::make_unique<Job>([i] {
              if (i % 97 == 0) {
                throw std::runtime_error("request failure");
              }
              return i * i;
            });
            futures[i] = job->get_future();
            check(jobs.push(job, Clock::now() + std::chrono::seconds(10)) == Push::accepted,
                  "submit");
            ++submitted;
          }
        }));
      }
      for (auto& producer : producers) {
        producer.get();
      }
      jobs.close();
    }
    int errors = 0;
    for (int i = 0; i < 400; ++i) {
      try {
        check(futures[i].get() == i * i && i % 97 != 0, "result");
      } catch (const std::runtime_error& e) {
        check(i % 97 == 0 && std::string(e.what()) == "request failure", "unexpected failure");
        ++errors;
      }
    }
    check(submitted == 400 && errors == 5, "exactly once");
    std::cout << "capacity=" << capacity << " accepted=400 successful=395 exceptions=5\n";
  }
  std::cout << "PASS timeout/ownership/blocked-close/drain/in-flight/startup-rollback rejects=3\n";
}
int main() {
  try {
    tests();
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
