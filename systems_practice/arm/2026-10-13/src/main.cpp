#include <algorithm>
#include <atomic>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <thread>
#include <vector>
#ifdef __APPLE__
#include <sys/sysctl.h>
#endif
extern "C" __attribute__((noinline)) void add_relaxed(std::atomic<std::uint64_t>* p) {
  p->fetch_add(1, std::memory_order_relaxed);
}
struct Packed {
  std::atomic<std::uint64_t> v{0};
};
template <int Align>
struct alignas(Align) Isolated {
  std::atomic<std::uint64_t> v{0};
};
template <class Cell>
double trial(int workers, int mode, bool layout) {
  if (workers < 1 || workers > 8) {
    throw std::invalid_argument("workers [1,8]");
  }
  constexpr int count = 100000;
  std::vector<Cell> cells(workers);
  std::vector<std::thread> threads;
  threads.reserve(workers);
  if (layout) {
    std::cout << "stride=" << sizeof(Cell) << " workers=" << workers << " mode=" << mode
              << " addresses";
    for (auto& c : cells) {
      std::cout << ' ' << static_cast<const void*>(&c.v);
    }
    std::cout << '\n';
  }
  // 时间包括启动/退出；所有版本使用相同口径。分片仅在join后读取。
  auto begin = std::chrono::steady_clock::now();
  try {
    for (int t = 0; t < workers; ++t) {
      threads.emplace_back([&, t] {
        if (mode == 2) {
          std::uint64_t local = 0;
          for (int i = 0; i < count; ++i) {
            ++local;
          }
          cells[t].v.store(local, std::memory_order_relaxed);
        } else {
          for (int i = 0; i < count; ++i) {
            add_relaxed(&cells[mode == 1 ? 0 : t].v);
          }
        }
      });
    }
  } catch (...) {
    for (auto& t : threads) {
      t.join();
    }
    throw;
  }
  for (auto& t : threads) {
    t.join();
  }
  auto end = std::chrono::steady_clock::now();
  std::uint64_t total = 0;
  for (auto& c : cells) {
    total += c.v.load(std::memory_order_relaxed);
  }
  if (total != std::uint64_t(workers) * count) {
    throw std::runtime_error("lost increments");
  }
  return std::chrono::duration<double, std::milli>(end - begin).count();
}
template <class Cell>
void report(int n, int mode, const char* name) {
  for (int i = 0; i < 3; ++i) {
    trial<Cell>(n, mode, false);
  }
  std::vector<double> samples;
  for (int i = 0; i < 9; ++i) {
    samples.push_back(trial<Cell>(n, mode, i == 0));
  }
  std::sort(samples.begin(), samples.end());
  std::cout << name << " CPU batch ms p50=" << samples[4] << " pmax=" << samples.back() << '\n';
}
int main() {
  try {
#ifdef __APPLE__
    std::size_t line = 0, length = sizeof(line);
    if (sysctlbyname("hw.cachelinesize", &line, &length, nullptr, 0) == 0) {
      std::cout << "reported_cacheline=" << line << '\n';
    } else {
      std::cout << "cacheline query unavailable; no assumed universal size\n";
    }
#endif
    for (int n : {1, 2, 4}) {
      report<Packed>(n, 0, "packed");
      report<Isolated<64>>(n, 0, "pad64");
      report<Isolated<128>>(n, 0, "pad128");
      report<Isolated<256>>(n, 0, "pad256");
      report<Isolated<128>>(n, 1, "true_shared");
      report<Isolated<128>>(n, 2, "local");
    }
    bool rejected = false;
    try {
      trial<Packed>(0, 0, false);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected) {
      return 2;
    }
    std::cout << "PASS 216 batches totals verified; zero worker rejected\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
