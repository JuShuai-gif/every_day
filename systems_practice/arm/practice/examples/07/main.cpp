#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// uint64 的模加可重新分组。四条累加链降低单条 ADD 结果依赖，但实际收益需用板端数据确认。
std::uint64_t serial(const std::vector<std::uint64_t>& values) {
  std::uint64_t sum = 0;
  for (auto value : values)
    sum += value;
  return sum;
}

std::uint64_t four_way(const std::vector<std::uint64_t>& values) {
  std::uint64_t a = 0, b = 0, c = 0, d = 0;
  std::size_t i = 0;
  for (; i + 4 <= values.size(); i += 4) {
    a += values[i];
    b += values[i + 1];
    c += values[i + 2];
    d += values[i + 3];
  }
  for (; i < values.size(); ++i)
    a += values[i];
  return a + b + c + d;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  std::vector<std::uint64_t> values((1 << 20) + 3);
  for (std::size_t i = 0; i < values.size(); ++i)
    values[i] = i * 17u;
  const auto baseline = serial(values), optimized = four_way(values);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=instruction_level_parallelism\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = serial(values);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = four_way(values);
                  (void)x;
                }),
                optimized);
}
