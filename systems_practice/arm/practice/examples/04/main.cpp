#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 两版产生相同序列；优化版预留容量，避免 push_back 过程中反复重新分配和复制。
std::uint64_t without_reserve(int count) {
  std::vector<std::uint32_t> values;
  for (int i = 0; i < count; ++i)
    values.push_back(i * 3u);
  std::uint64_t sum = 0;
  for (auto value : values)
    sum += value;
  return sum;
}

std::uint64_t with_reserve(int count) {
  std::vector<std::uint32_t> values;
  values.reserve(count);
  for (int i = 0; i < count; ++i)
    values.push_back(i * 3u);
  std::uint64_t sum = 0;
  for (auto value : values)
    sum += value;
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  constexpr int count = 1 << 20;
  const auto baseline = without_reserve(count), optimized = with_reserve(count);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=vector_capacity\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = without_reserve(count);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = with_reserve(count);
                  (void)x;
                }),
                optimized);
}
