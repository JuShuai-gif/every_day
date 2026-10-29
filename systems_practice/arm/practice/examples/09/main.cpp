#include <cstdint>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 两版均计算同一变换；baseline 每个元素跨函数边界，optimized
// 每次函数调用处理一个批次，降低调用开销。
__attribute__((noinline)) std::uint32_t one(std::uint32_t value) {
  return value * 3u + 1u;
}

__attribute__((noinline)) void batch(const std::uint32_t* in, std::uint32_t* out,
                                     std::size_t count) {
  for (std::size_t i = 0; i < count; ++i)
    out[i] = in[i] * 3u + 1u;
}

std::uint64_t per_item(const std::vector<std::uint32_t>& in, std::vector<std::uint32_t>& out) {
  for (std::size_t i = 0; i < in.size(); ++i)
    out[i] = one(in[i]);
  std::uint64_t sum = 0;
  for (auto value : out)
    sum += value;
  return sum;
}

std::uint64_t batched(const std::vector<std::uint32_t>& in, std::vector<std::uint32_t>& out) {
  batch(in.data(), out.data(), in.size());
  std::uint64_t sum = 0;
  for (auto value : out)
    sum += value;
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  std::vector<std::uint32_t> in(1 << 20), out(in.size());
  for (std::size_t i = 0; i < in.size(); ++i)
    in[i] = i;
  const auto baseline = per_item(in, out), optimized = batched(in, out);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=batching\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = per_item(in, out);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = batched(in, out);
                  (void)x;
                }),
                optimized);
}
