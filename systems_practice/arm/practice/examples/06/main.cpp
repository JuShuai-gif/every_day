#include <cstdint>
#include <cstring>
#include <iostream>
#include <vector>
#if defined(__ARM_NEON)
#include <arm_neon.h>
#endif
#include "benchmark.hpp"

// FP32 向量逐元素相加。RK3588 的 A76/A55 都有 NEON；非 NEON 构建保留标量回退以便 Mac/Linux 检查。
std::uint64_t scalar(const std::vector<float>& a, const std::vector<float>& b,
                     std::vector<float>& out) {
  for (std::size_t i = 0; i < a.size(); ++i)
    out[i] = a[i] + b[i];
  std::uint64_t sum = 0;
  for (float value : out) {
    std::uint32_t bits;
    std::memcpy(&bits, &value, sizeof(bits));
    sum += bits;
  }
  return sum;
}

std::uint64_t neon(const std::vector<float>& a, const std::vector<float>& b,
                   std::vector<float>& out) {
  std::size_t i = 0;
#if defined(__ARM_NEON)
  for (; i + 4 <= a.size(); i += 4)
    vst1q_f32(out.data() + i, vaddq_f32(vld1q_f32(a.data() + i), vld1q_f32(b.data() + i)));
#endif
  for (; i < a.size(); ++i)
    out[i] = a[i] + b[i];
  std::uint64_t sum = 0;
  for (float value : out) {
    std::uint32_t bits;
    std::memcpy(&bits, &value, sizeof(bits));
    sum += bits;
  }
  return sum;
}

int main(int argc, char** argv) {
  std::string mode;
  if (parse_mode(argc, argv, mode))
    return 1;
  std::vector<float> a(1 << 20), b(a.size()), out(a.size());
  for (std::size_t i = 0; i < a.size(); ++i) {
    a[i] = float(i % 101);
    b[i] = float(i % 53);
  }
  const auto baseline = scalar(a, b, out), optimized = neon(a, b, out);
  if (!require_equal(baseline, optimized))
    return 1;
  std::cout << "correctness=PASS topic=neon enabled="
#if defined(__ARM_NEON)
            << "true\n";
#else
            << "false_scalar_fallback\n";
#endif
  if (mode != "optimized")
    print_stats("baseline", sample_us([&] {
                  volatile auto z = scalar(a, b, out);
                  (void)z;
                }),
                baseline);
  if (mode != "baseline")
    print_stats("optimized", sample_us([&] {
                  volatile auto z = neon(a, b, out);
                  (void)z;
                }),
                optimized);
}
