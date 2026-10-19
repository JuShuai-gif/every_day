#include <arm_neon.h>

#include <cstddef>
#include <cstdint>
// 仅此翻译单元启用dotprod；调用方必须先通过OS能力检查。
extern "C" int64_t dot_optional(const int8_t* a, const int8_t* b, size_t n) {
  int32x4_t acc = vdupq_n_s32(0);
  size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    acc = vdotq_s32(acc, vld1q_s8(a + i), vld1q_s8(b + i));
  }
  int64_t total = vaddvq_s32(acc);
  for (; i < n; ++i) {
    total += static_cast<int32_t>(a[i]) * b[i];
  }
  return total;
}
