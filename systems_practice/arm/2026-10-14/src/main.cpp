#include <arm_neon.h>

#include <algorithm>
#include <atomic>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>
#ifdef __linux__
#include <sched.h>
#endif
using Clock = std::chrono::steady_clock;
__attribute__((noinline)) float dot(const float* a, const float* b, std::size_t n) {
  float32x4_t sum = vdupq_n_f32(0);
  std::size_t i = 0;
  for (; i + 4 <= n; i += 4) {
    sum = vfmaq_f32(sum, vld1q_f32(a + i), vld1q_f32(b + i));
  }
  float out = vaddvq_f32(sum);
  for (; i < n; ++i) {
    out += a[i] * b[i];
  }
  return out;
}
int cpu() {
#ifdef __linux__
  return sched_getcpu();
#else
  return -1;  // macOS不将QoS或affinity tag冒充硬绑核证据。
#endif
}
struct Task {
  double queue_us = 0, exec_us = 0;
  int first = -1, last = -1;
};
struct Result {
  double batch_us;
  std::vector<Task> tasks;
};
class Pool {
  std::mutex mu;
  std::condition_variable work, done;
  bool stop = false;
  std::size_t generation = 0, remaining = 0;
  std::vector<std::thread> threads;
  std::atomic<std::size_t> next{0};
  const std::vector<float>* data = nullptr;
  std::vector<float>* output = nullptr;
  std::vector<Task>* records = nullptr;
  std::size_t rows = 0, k = 0, grain = 0;
  Clock::time_point submitted;
  void worker() {
    std::size_t seen = 0;
    for (;;) {
      std::unique_lock<std::mutex> lock(mu);
      work.wait(lock, [&] {
        return stop || generation != seen;
      });
      if (stop) {
        return;
      }
      seen = generation;
      lock.unlock();
      for (;;) {
        auto id = next.fetch_add(1, std::memory_order_relaxed);
        if (id >= records->size()) {
          break;
        }
        auto begin = Clock::now();
        Task t;
        t.first = cpu();
        t.queue_us = std::chrono::duration<double, std::micro>(begin - submitted).count();
        for (std::size_t r = id * grain; r < std::min(rows, (id + 1) * grain); ++r) {
          (*output)[r] = dot(data->data() + r * k, data->data() + r * k, k);
        }
        t.last = cpu();
        t.exec_us = std::chrono::duration<double, std::micro>(Clock::now() - begin).count();
        (*records)[id] = t;
      }
      lock.lock();
      if (--remaining == 0) {
        done.notify_one();
      }
    }
  }

 public:
  explicit Pool(std::size_t n) {
    if (!n) {
      throw std::invalid_argument("zero workers");
    }
    try {
      for (std::size_t i = 0; i < n; ++i) {
        threads.emplace_back([this] {
          worker();
        });
      }
    } catch (...) {
      shutdown();
      throw;
    }
  }
  void shutdown() {
    {
      std::lock_guard<std::mutex> l(mu);
      stop = true;
    }
    work.notify_all();
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
  ~Pool() {
    shutdown();
  }
  Pool(const Pool&) = delete;
  Result run(const std::vector<float>& x,
             std::vector<float>& y,
             std::size_t width,
             std::size_t chunk) {
    if (!width || !chunk || x.size() % width || y.size() != x.size() / width) {
      throw std::invalid_argument("bad shape/grain");
    }
    Result result;
    result.tasks.resize((y.size() + chunk - 1) / chunk);
    std::unique_lock<std::mutex> l(mu);
    data = &x;
    output = &y;
    records = &result.tasks;
    k = width;
    rows = y.size();
    grain = chunk;
    next = 0;
    remaining = threads.size();
    submitted = Clock::now();
    ++generation;
    work.notify_all();
    done.wait(l, [&] {
      return remaining == 0;
    });
    result.batch_us = std::chrono::duration<double, std::micro>(Clock::now() - submitted).count();
    return result;
  }
};
double percentile(std::vector<double> a, double p) {
  std::sort(a.begin(), a.end());
  return a[std::size_t(p * (a.size() - 1))];
}
int main() {
  try {
    constexpr std::size_t rows = 257, k = 1025;
    std::vector<float> x(rows * k), y(rows);
    for (std::size_t i = 0; i < x.size(); ++i) {
      x[i] = float(int(i % 31) - 15) / 31;
    }
    std::vector<double> ref(rows);
    for (std::size_t r = 0; r < rows; ++r) {
      for (std::size_t j = 0; j < k; ++j) {
        double v = x[r * k + j];
        ref[r] += v * v;
      }
    }
    for (std::size_t workers : {1, 2, 4}) {
      Pool p(workers);
      for (std::size_t grain : {1, 16, 128}) {
        for (int z = 0; z < 3; ++z) {
          p.run(x, y, k, grain);
        }
        std::vector<double> b, q, e;
        int migrations = 0, observed = 0;
        for (int z = 0; z < 15; ++z) {
          auto result = p.run(x, y, k, grain);
          b.push_back(result.batch_us);
          for (const auto& t : result.tasks) {
            q.push_back(t.queue_us);
            e.push_back(t.exec_us);
            if (t.first >= 0 && t.last >= 0) {
              ++observed;
              migrations += t.first != t.last;
            }
          }
          for (std::size_t r = 0; r < rows; ++r) {
            if (std::abs(y[r] - ref[r]) > 1e-4 * ref[r]) {
              throw std::runtime_error("dot mismatch");
            }
          }
        }
        std::cout << "workers=" << workers << " grain=" << grain
                  << " batch_p50_us=" << percentile(b, .5)
                  << " task_queue_p50_us=" << percentile(q, .5)
                  << " task_queue_p95_us=" << percentile(q, .95)
                  << " task_exec_p50_us=" << percentile(e, .5)
                  << " migration_endpoint_changes=" << migrations << " observed=" << observed
                  << '\n';
      }
    }
    bool rejected = false;
    try {
      Pool bad(0);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      throw std::runtime_error("zero not rejected");
    }
    Pool p(1);
    try {
      p.run(x, y, k, 0);
      throw std::runtime_error("grain not rejected");
    } catch (const std::invalid_argument&) {
    }
    std::cout << "PASS 135 batches, odd row/K tails, zero-worker/grain rejected\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
