#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 同一矩阵求和；baseline 的列优先访问跨越多条缓存行，optimized 连续读取每一行。
std::uint64_t columns(const std::vector<std::uint32_t>& a, int n) {
  std::uint64_t sum = 0;
  for (int column = 0; column < n; ++column) {
    for (int row = 0; row < n; ++row)
      sum += a[row * n + column];
  }
  return sum;
}

std::uint64_t rows(const std::vector<std::uint32_t>& a, int n) {
  std::uint64_t sum = 0;
  for (int row = 0; row < n; ++row) {
    for (int column = 0; column < n; ++column)
      sum += a[row * n + column];
  }
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  constexpr int n = 1024;
  std::vector<std::uint32_t> a(n * n);
  for (std::size_t i = 0; i < a.size(); ++i)
    a[i] = i % 251;
  const auto baseline = columns(a, n), optimized = rows(a, n);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=cache_stride\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = columns(a, n);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = rows(a, n);
                  (void)x;
                }),
                optimized);
}
