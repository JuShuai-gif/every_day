#include <array>
#include <cassert>
#include <cstddef>
#include <iostream>
#include <vector>
#if defined(__aarch64__)
#include <arm_neon.h>
#endif
float sum_scalar(const float *p, std::size_t n) {
  float s = 0;
  for (std::size_t i = 0; i < n; ++i)
    s += p[i];
  return s;
}
float sum_dispatch(const float *p, std::size_t n) {
#if defined(__aarch64__)
  std::size_t i = 0;
  float32x4_t v = vdupq_n_f32(0);
  for (; i + 4 <= n; i += 4)
    v = vaddq_f32(v, vld1q_f32(p + i));
  float s = vaddvq_f32(v);
  return s + sum_scalar(p + i, n - i);
#else
  return sum_scalar(p, n);
#endif
}
int main() {
  std::vector<float> x{1, 2, 3, 4, 5, 6, 7};
  assert(sum_dispatch(x.data(), x.size()) == sum_scalar(x.data(), x.size()));
  assert(sum_dispatch(x.data(), 0) == 0);
  std::cout << "PASS layout_tail n=7 sum=" << sum_dispatch(x.data(), x.size())
            << " fallback=" << (sizeof(void *) == 8) << "\n";
}
