#include <algorithm>
#include <cmath>
#include <stdexcept>

#include "dot.hpp"
#if defined(__aarch64__)
#include <arm_neon.h>
#endif

namespace {
void check(const std::int8_t* x, const std::int8_t* y, std::size_t n) {
  if (n > 32 || (n != 0 && (x == nullptr || y == nullptr))) {
    throw std::invalid_argument("block needs valid pointers and n<=32");
  }
}
}  // namespace

std::int32_t neon_dot(const std::int8_t* x, const std::int8_t* y, std::size_t n) {
  check(x, y, n);
#if defined(__aarch64__)
  int32x4_t acc = vdupq_n_s32(0);
  std::size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    const auto a = vld1q_s8(x + i);
    const auto b = vld1q_s8(y + i);
    // 不能先在INT16里相加两个乘积：-128*-128加两次会溢出。
    acc = vpadalq_s16(acc, vmull_s8(vget_low_s8(a), vget_low_s8(b)));
    acc = vpadalq_s16(acc, vmull_high_s8(a, b));
  }
  std::int32_t sum = vaddvq_s32(acc);
  // 不跨越逻辑长度做全向量加载，尾部不依赖调用方padding。
  for (; i < n; ++i) {
    sum += static_cast<std::int32_t>(x[i]) * y[i];
  }
  return sum;
#else
  return scalar_dot(x, y, n);
#endif
}

std::int32_t optional_dot(const std::int8_t* x, const std::int8_t* y, std::size_t n) {
  check(x, y, n);
#if defined(__aarch64__) && defined(__ARM_FEATURE_DOTPROD)
  auto acc = vdupq_n_s32(0);
  std::size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    acc = vdotq_s32(acc, vld1q_s8(x + i), vld1q_s8(y + i));
  }
  std::int32_t sum = vaddvq_s32(acc);
  for (; i < n; ++i) {
    sum += static_cast<std::int32_t>(x[i]) * y[i];
  }
  return sum;
#else
  return neon_dot(x, y, n);
#endif
}

bool has_compiled_dot() {
#if defined(__aarch64__) && defined(__ARM_FEATURE_DOTPROD)
  return true;
#else
  return false;
#endif
}

float scaled_dot(const std::int8_t* x,
                 const std::int8_t* y,
                 const float* sx,
                 const float* sy,
                 std::size_t n,
                 BlockDot fn) {
  if (fn == nullptr || (n && (!x || !y || !sx || !sy))) {
    throw std::invalid_argument("invalid scaled dot input");
  }
  float out = 0;
  for (std::size_t i = 0, block = 0; i < n; ++block) {
    if (!std::isfinite(sx[block]) || !std::isfinite(sy[block]) || sx[block] < 0 || sy[block] < 0) {
      throw std::invalid_argument("scales must be finite nonnegative values");
    }
    const std::size_t count = std::min(std::size_t{32}, n - i);
    // 每块整数和完全一致；按相同顺序应用scale，保持公平数学语义。
    out += static_cast<float>(fn(x + i, y + i, count)) * (sx[block] * sy[block]);
    i += count;
  }
  return out;
}
