#include <algorithm>
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <iostream>
#include <mutex>
#include <stdexcept>
#include <thread>
#include <vector>

struct Packed {
  std::atomic<std::uint64_t> count{0};
};
template <std::size_t Stride>
struct alignas(Stride) Isolated {
  std::atomic<std::uint64_t> count{0};
};
struct JoinThreads {
  std::vector<std::thread> threads;
  ~JoinThreads() {
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
// gate 同时发布开始信号；构造线程失败时也必须唤醒并回收已启动线程。
template <class Counter>
double trial(std::size_t workers, std::size_t iterations, bool local, int fail_at = -1) {
  if (workers == 0 || workers > 32) {
    throw std::invalid_argument("workers outside [1,32]");
  }
  std::vector<Counter> slots(workers);
  std::mutex mutex;
  std::condition_variable cv;
  bool go = false, abort = false;
  std::size_t ready = 0;
  JoinThreads team;
  team.threads.reserve(workers);
  try {
    for (std::size_t id = 0; id < workers; ++id) {
      if (static_cast<int>(id) == fail_at) {
        throw std::runtime_error("injected thread creation failure");
      }
      team.threads.emplace_back([&, id] {
        {
          std::unique_lock<std::mutex> lock(mutex);
          ++ready;
          cv.notify_all();
          cv.wait(lock, [&] {
            return go;
          });
          if (abort) {
            return;
          }
        }
        std::uint64_t subtotal = 0;
        for (std::size_t i = 0; i < iterations; ++i) {
          // 每个线程独占一个计数器；原子操作仅模拟可被监控线程读取的生产计数。
          const auto delta = static_cast<std::uint64_t>((i + id) % 7 + 1);
          if (local) {
            subtotal += delta;
          } else {
            slots[id].count.fetch_add(delta, std::memory_order_relaxed);
          }
        }
        if (local) {
          slots[id].count.store(subtotal, std::memory_order_relaxed);
        }
      });
    }
  } catch (...) {
    {
      std::lock_guard<std::mutex> lock(mutex);
      abort = true;
      go = true;
    }
    cv.notify_all();
    throw;
  }
  {
    std::unique_lock<std::mutex> lock(mutex);
    cv.wait(lock, [&] {
      return ready == workers;
    });
  }
  const auto begin = std::chrono::steady_clock::now();
  {
    std::lock_guard<std::mutex> lock(mutex);
    go = true;
  }
  cv.notify_all();
  for (auto& t : team.threads) {
    t.join();
  }
  const auto end = std::chrono::steady_clock::now();
  // join 是最终快照边界；不把 relaxed 计数器当作其他数据的发布协议。
  for (std::size_t id = 0; id < workers; ++id) {
    std::uint64_t oracle = 0;
    for (std::size_t i = 0; i < iterations; ++i) {
      oracle += (i + id) % 7 + 1;
    }
    require(slots[id].count.load() == oracle, "lost update");
  }
  return std::chrono::duration<double, std::milli>(end - begin).count();
}
int main(int argc, char** argv) {
  try {
    const bool quick = argc == 2 && std::string(argv[1]) == "--quick";
    require(argc == 1 || quick, "usage: counters [--quick]");
    for (auto n : {0U, 1U, 7U, 257U}) {
      for (auto w : {1U, 2U, 4U}) {
        trial<Packed>(w, n, false);
        trial<Isolated<128>>(w, n, false);
        trial<Isolated<128>>(w, n, true);
      }
    }
    for (int fail : {0, 1, 3}) {
      bool caught = false;
      try {
        trial<Packed>(4, 100, false, fail);
      } catch (const std::runtime_error&) {
        caught = true;
      }
      require(caught, "missing injected failure");
    }
    bool rejected = false;
    try {
      trial<Packed>(0, 1, false);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    require(rejected, "zero workers");
    std::cout << "PASS 36 boundary trials, 3 constructor failures, invalid workers; strides="
              << sizeof(Packed) << ',' << sizeof(Isolated<64>) << ',' << sizeof(Isolated<128>)
              << '\n';
    if (quick) {
      return 0;
    }
    for (auto w : {1U, 2U, 4U}) {
      std::vector<double> samples[4];
      for (int rep = -3; rep < 21; ++rep) {
        // 轮换测量顺序，减少固定顺序热状态偏差；每个样本是一整批worker的完成时间。
        for (int k = 0; k < 4; ++k) {
          int mode = (k + rep + 4) % 4;
          double ms = 0;
          if (mode == 0) {
            ms = trial<Packed>(w, 200000, false);
          }
          if (mode == 1) {
            ms = trial<Isolated<64>>(w, 200000, false);
          }
          if (mode == 2) {
            ms = trial<Isolated<128>>(w, 200000, false);
          }
          if (mode == 3) {
            ms = trial<Isolated<128>>(w, 200000, true);
          }
          if (rep >= 0) {
            samples[mode].push_back(ms);
          }
        }
      }
      for (int mode = 0; mode < 4; ++mode) {
        auto& s = samples[mode];
        std::sort(s.begin(), s.end());
        std::cout << "workers=" << w << " mode=" << mode << " batch_ms_p50=" << s[10]
                  << " p95=" << s[19] << '\n';
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
