#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 基线的 if 取决于伪随机数据；优化版用全 0/全 1 掩码保留相同的“只加正数”语义。
std::uint64_t branchy(const std::vector<std::int32_t>& values) {
  std::uint64_t sum = 0;
  for (auto value : values)
    if (value > 0)
      sum += static_cast<std::uint32_t>(value);
  return sum;
}

std::uint64_t masked(const std::vector<std::int32_t>& values) {
  std::uint64_t sum = 0;
  for (auto value : values) {
    const std::uint32_t mask = static_cast<std::uint32_t>(-(value > 0));
    sum += static_cast<std::uint32_t>(value) & mask;
  }
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  std::vector<std::int32_t> values(1 << 20);
  std::uint32_t seed = 1;
  for (auto& value : values) {
    seed = seed * 1664525u + 1013904223u;
    value = static_cast<std::int32_t>(seed);
  }
  const auto baseline = branchy(values), optimized = masked(values);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=branch_prediction\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = branchy(values);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = masked(values);
                  (void)x;
                }),
                optimized);
}
