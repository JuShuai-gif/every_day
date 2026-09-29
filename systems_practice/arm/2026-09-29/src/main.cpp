#include <time.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
std::uint64_t serial(const std::uint64_t*, std::size_t);
std::uint64_t four(const std::uint64_t*, std::size_t);
volatile std::uint64_t sink = 0;
double thread_time() {
  timespec t{};
  if (clock_gettime(CLOCK_THREAD_CPUTIME_ID, &t) != 0) {
    throw std::runtime_error("thread clock");
  }
  return t.tv_sec * 1e6 + t.tv_nsec / 1e3;
}
struct Times {
  double wall;
  double cpu;
};
Times measure(std::uint64_t (*fn)(const std::uint64_t*, std::size_t),
              const std::vector<std::uint64_t>& x) {
  const auto cpu = thread_time();
  const auto start = std::chrono::steady_clock::now();
  std::uint64_t sum = 0;
  // 独立编译单元且不启用LTO，保留每次调用；只把计算与调用开销计入。
  for (int i = 0; i < 128; ++i) {
    sum += fn(x.data(), x.size());
  }
  const auto end = std::chrono::steady_clock::now();
  const auto cpu_end = thread_time();
  sink = sum;
  return {std::chrono::duration<double, std::micro>(end - start).count() / 128,
          (cpu_end - cpu) / 128};
}
void report(const char* label, std::vector<double> x) {
  std::sort(x.begin(), x.end());
  std::cout << label << " p50_us=" << x[50] << " p95_us=" << x[95] << '\n';
}
int main() {
  try {
    for (std::size_t n = 0; n <= 1024; ++n) {
      std::vector<std::uint64_t> x(n, UINT64_MAX);
      if (serial(x.data(), n) != four(x.data(), n)) {
        throw std::runtime_error("tail/modular sum");
      }
    }
    std::vector<std::uint64_t> x(4096);
    std::vector<double> sw, fw, sc, fc;
    for (int i = 0; i < 121; ++i) {
      for (std::size_t j = 0; j < x.size(); ++j) {
        x[j] = j * 31 + i;
      }
      Times a, b;
      if (i % 2) {
        a = measure(serial, x);
        b = measure(four, x);
      } else {
        b = measure(four, x);
        a = measure(serial, x);
      }
      if (serial(x.data(), x.size()) != four(x.data(), x.size())) {
        throw std::runtime_error("benchmark correctness");
      }
      if (i >= 20) {
        sw.push_back(a.wall);
        fw.push_back(b.wall);
        sc.push_back(a.cpu);
        fc.push_back(b.cpu);
      }
    }
    std::cout << "PASS 1025 lengths; N=4096 uint64, warmup=20 samples=101 calls/sample=128\n";
    report("serial wall", sw);
    report("four wall", fw);
    report("serial threadCPU", sc);
    report("four threadCPU", fc);
    std::cout << "scope=CPU cached kernel+call; no board/GPU/NPU claim; sink=" << sink << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
