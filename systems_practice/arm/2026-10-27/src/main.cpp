#include <cmath>
#include <iostream>
#if defined(__APPLE__)
#include <sys/sysctl.h>
#endif
#if defined(__aarch64__) && defined(__ARM_NEON)
#include <arm_neon.h>
#endif
static bool have_neon() {
#if defined(__aarch64__) && defined(__ARM_NEON)
#if defined(__APPLE__)
  int x = 0;
  size_t n = sizeof(x);
  if (sysctlbyname("hw.optional.neon", &x, &n, nullptr, 0) == 0)
    return x != 0;
#endif
  return true;
#else
  return false;
#endif
}
static float scalar(const float* a, const float* b, int n) {
  float s = 0;
  for (int i = 0; i < n; i++)
    s += a[i] * b[i];
  return s;
}
#if defined(__aarch64__) && defined(__ARM_NEON)
static float neon(const float* a, const float* b, int n) {
  float32x4_t s = vdupq_n_f32(0);
  int i = 0;
  for (; i + 4 <= n; i += 4)
    s = vmlaq_f32(s, vld1q_f32(a + i), vld1q_f32(b + i));
  float r = vaddvq_f32(s);
  for (; i < n; i++)
    r += a[i] * b[i];
  return r;
}
#else
static float neon(const float* a, const float* b, int n) {
  return scalar(a, b, n);
}
#endif
int main() {
  float a[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9}, b[9] = {.5f, -1, 2, 1, .25f, -.5f, 3, 2, -2};
  float x = scalar(a, b, 9), y = neon(a, b, 9);
  if (std::abs(x - y) > 1e-5f)
    return 2;
  std::cout << "PASS scalar=" << x << " selected=" << (have_neon() ? "neon" : "scalar")
            << " result=" << y << std::endl;
}
