#include <cstdint>
#include <cstring>
#include <iostream>
#include <vector>

#include "benchmark.hpp"

// 两版复制同样的字节。memcpy 允许 libc 为具体 AArch64 CPU 选择经过调优的实现。
std::uint64_t byte_loop(const std::vector<std::uint8_t>& in, std::vector<std::uint8_t>& out) {
  for (std::size_t i = 0; i < in.size(); ++i)
    out[i] = in[i];
  std::uint64_t sum = 0;
  for (auto value : out)
    sum += value;
  return sum;
}

std::uint64_t libc_copy(const std::vector<std::uint8_t>& in, std::vector<std::uint8_t>& out) {
  std::memcpy(out.data(), in.data(), in.size());
  std::uint64_t sum = 0;
  for (auto value : out)
    sum += value;
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  std::vector<std::uint8_t> in(8 << 20), out(in.size());
  for (std::size_t i = 0; i < in.size(); ++i)
    in[i] = i;
  const auto baseline = byte_loop(in, out), optimized = libc_copy(in, out);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=memcpy\n";
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto x = byte_loop(in, out);
                  (void)x;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto x = libc_copy(in, out);
                  (void)x;
                }),
                optimized);
}
