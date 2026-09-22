#include <algorithm>
#include <chrono>
#include <condition_variable>
#include <exception>
#include <iomanip>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

#include "counters.hpp"
using namespace practice;
using Clock = std::chrono::steady_clock;

void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}

// 每次试验使用门闩同时放行，线程创建不计时。失败构造也唤醒并 join 已启动线程。
struct Team {
  std::vector<std::thread> threads;
  std::mutex mutex;
  std::condition_variable cv;
  std::size_t ready = 0;
  std::size_t done = 0;
  bool go = false;
  bool stop = false;
  ~Team() {
    {
      std::lock_guard<std::mutex> lock(mutex);
      stop = true;
    }
    cv.notify_all();
    for (auto& t : threads) {
      if (t.joinable()) {
        t.join();
      }
    }
  }
};

template <class Slot>
double trial(std::size_t workers, std::uint64_t iterations, bool shared, bool inspect = false) {
  Counters<Slot> counters(workers);
  require(counters.at(0).is_lock_free(),
          "uint64 atomic is not lock free; benchmark interpretation invalid");
  if (inspect) {
    std::cout << "layout slot_bytes=" << sizeof(Slot) << " object_bytes=" << sizeof(counters)
              << " offsets=";
    const auto base = reinterpret_cast<std::uintptr_t>(&counters.at(0));
    for (std::size_t i = 0; i < workers; ++i) {
      auto addr = reinterpret_cast<std::uintptr_t>(&counters.at(i));
      require(addr % alignof(Slot) == 0, "slot alignment");
      require(addr - base == i * sizeof(Slot), "slot stride");
      std::cout << addr - base << ',';
    }
    std::cout << '\n';
  }
  Team team;
  team.threads.reserve(workers);
  for (std::size_t i = 0; i < workers; ++i) {
    team.threads.emplace_back([&, i] {
      {
        std::unique_lock<std::mutex> lock(team.mutex);
        ++team.ready;
        team.cv.notify_all();
        team.cv.wait(lock, [&] {
          return team.go || team.stop;
        });
        if (team.stop) {
          return;
        }
      }
      increment(counters.at(shared ? 0 : i), iterations);
      {
        std::lock_guard<std::mutex> lock(team.mutex);
        ++team.done;
      }
      team.cv.notify_all();
    });
  }
  std::unique_lock<std::mutex> lock(team.mutex);
  team.cv.wait(lock, [&] {
    return team.ready == workers;
  });
  const auto start = Clock::now();
  team.go = true;
  lock.unlock();
  team.cv.notify_all();
  lock.lock();
  team.cv.wait(lock, [&] {
    return team.done == workers;
  });
  const auto end = Clock::now();
  lock.unlock();
  // 每个写者 done 发布之后已退出热循环；Team 在存储析构前 join。
  require(counters.sum() == workers * iterations, "lost increments");
  for (std::size_t i = 0; i < workers; ++i) {
    const auto expected = shared ? (i == 0 ? workers * iterations : 0) : iterations;
    require(counters.at(i).load(std::memory_order_relaxed) == expected, "per-worker count");
  }
  counters.reset();
  require(counters.sum() == 0, "reset");
  return std::chrono::duration<double, std::micro>(end - start).count();
}

void checks() {
  for (auto w : {std::size_t{1}, std::size_t{2}, std::size_t{8}}) {
    for (auto n : {0ULL, 1ULL, 10003ULL}) {
      trial<PackedSlot>(w, n, false, n == 1);
      trial<IsolatedSlot<64>>(w, n, false, n == 1);
      trial<IsolatedSlot<128>>(w, n, false, n == 1);
      trial<IsolatedSlot<256>>(w, n, false, n == 1);
      trial<IsolatedSlot<128>>(w, n, true);
    }
  }
  for (auto n : {std::size_t{0}, std::size_t{9}}) {
    bool caught = false;
    try {
      Counters<PackedSlot> invalid(n);
    } catch (const std::invalid_argument&) {
      caught = true;
    }
    require(caught, "invalid worker count accepted");
  }
  Counters<PackedSlot> c(1);
  bool caught = false;
  try {
    (void)c.at(1);
  } catch (const std::out_of_range&) {
    caught = true;
  }
  require(caught, "invalid index accepted");
  // UINT64 原子加按模回绕是语言行为，生产计数要另订溢出策略。
  c.at(0).store(UINT64_MAX, std::memory_order_relaxed);
  increment(c.at(0), 1);
  require(c.sum() == 0, "unsigned wrap");
  std::cout << "PASS 45 trials: zero/single/tail iterations, private/shared counts, alignment; "
               "invalid bounds/reset/wrap\n";
}

double sample(int mode, std::size_t workers) {
  constexpr std::uint64_t n = 200000;
  switch (mode) {
    case 0:
      return trial<PackedSlot>(workers, n, false);
    case 1:
      return trial<IsolatedSlot<64>>(workers, n, false);
    case 2:
      return trial<IsolatedSlot<128>>(workers, n, false);
    case 3:
      return trial<IsolatedSlot<256>>(workers, n, false);
    default:
      return trial<IsolatedSlot<128>>(workers, n, true);
  }
}
int main(int argc, char** argv) {
  try {
    if (argc > 2 ||
        (argc == 2 && std::string(argv[1]) != "bench" && std::string(argv[1]) != "check")) {
      throw std::invalid_argument("usage: cache_counters [check|bench]");
    }
    checks();
    if (argc == 2 && std::string(argv[1]) == "bench") {
      const char* names[] = {"packed", "pad64", "pad128", "pad256", "true_shared"};
      std::cout << "CPU wall us: release gate -> all done; excludes create/join; no affinity; "
                   "warmup=5 samples=30 n_per_worker=200000\n";
      for (auto workers : {std::size_t{1}, std::size_t{2}, std::size_t{4}}) {
        std::array<std::vector<double>, 5> samples;
        // 每轮轮换布局顺序，缓解温度和调频与固定顺序的相关性。
        for (int r = 0; r < 35; ++r) {
          for (int j = 0; j < 5; ++j) {
            const int mode = (j + r) % 5;
            const double us = sample(mode, workers);
            if (r >= 5) {
              samples[mode].push_back(us);
            }
          }
        }
        for (int m = 0; m < 5; ++m) {
          auto& v = samples[m];
          std::sort(v.begin(), v.end());
          const double p50 = v[14], p95 = v[28];
          std::cout << names[m] << " workers=" << workers << " p50_us=" << p50 << " p95_us=" << p95
                    << " ns_per_increment=" << p50 * 1000 / (workers * 200000) << '\n';
        }
      }
    }
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "ERROR: " << e.what() << '\n';
    return 1;
  }
}
