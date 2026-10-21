#pragma once
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#if defined(__aarch64__)
#include <arm_neon.h>
#endif

namespace practice {
// 独立实现，受 ncnn float2int8 启发；额外定义 NaN/Inf 合同，先钳位再转换。
inline void validate_scale(float inverse_scale) {
  if (!std::isfinite(inverse_scale) || inverse_scale <= 0) {
    throw std::invalid_argument("inverse scale must be positive and finite");
  }
}
inline std::int8_t one(float x, float inverse_scale) {
  float y = x * inverse_scale;
  if (std::isnan(y)) {
    y = 0;
  }
  y = std::clamp(y, -127.0f, 127.0f);
  return static_cast<std::int8_t>(std::round(y));
}
// 热路径前置：scale 已验证，输入输出不重叠，长度真实可访问；n=0 不解引用。
__attribute__((noinline)) inline void scalar(const float* x,
                                             std::int8_t* q,
                                             std::size_t n,
                                             float inverse_scale) {
#if defined(__clang__)
#pragma clang loop vectorize(disable) interleave(disable)
#endif
  for (std::size_t i = 0; i < n; ++i) {
    q[i] = one(x[i], inverse_scale);
  }
}
#if defined(__aarch64__)
inline int32x4_t convert(float32x4_t x, float32x4_t scale) {
  auto y = vmulq_f32(x, scale);
  // 自比较屏蔽 NaN；有限范围保证浮点转整型不依赖越界行为。
  y = vbslq_f32(vceqq_f32(y, y), y, vdupq_n_f32(0));
  y = vmaxq_f32(vdupq_n_f32(-127), vminq_f32(vdupq_n_f32(127), y));
  return vcvtaq_s32_f32(y);  // 最近值，正负半整数均远离零。
}
__attribute__((noinline)) inline void neon(const float* x,
                                           std::int8_t* q,
                                           std::size_t n,
                                           float inverse_scale) {
  const auto s = vdupq_n_f32(inverse_scale);
  std::size_t i = 0;
  for (; n - i >= 8; i += 8) {
    const auto a = vqmovn_s32(convert(vld1q_f32(x + i), s));
    const auto b = vqmovn_s32(convert(vld1q_f32(x + i + 4), s));
    vst1_s8(q + i, vqmovn_s16(vcombine_s16(a, b)));
  }
  for (; i < n; ++i) {
    q[i] = one(x[i], inverse_scale);
  }
}
#else
inline void neon(const float* x, std::int8_t* q, std::size_t n, float s) {
  scalar(x, q, n, s);
}
#endif
}  // namespace practice
