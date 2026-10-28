#include <cassert>
#include <cstddef>
#include <iostream>
#include <vector>
#if defined(__aarch64__)
#include <arm_neon.h>
#endif
static float scalar(const float* x, size_t n) {
  float s = 0;
  for (size_t i = 0; i < n; ++i)
    s += x[i];
  return s;
}
static float sum(const float* x, size_t n) {
#if defined(__aarch64__)
  size_t i = 0;
  float32x4_t v = vdupq_n_f32(0);
  for (; i + 4 <= n; i += 4)
    v = vaddq_f32(v, vld1q_f32(x + i));
  float s = vaddvq_f32(v);
  return s + scalar(x + i, n - i);
#else
  return scalar(x, n);
#endif
}
int main() {
  std::vector<float> x(19, 1.0f);
  assert(sum(x.data(), x.size()) == 19.0f);
  std::cout << "layout_dispatch_pass n=19 sum=" << sum(x.data(), x.size()) << "\n";
}
