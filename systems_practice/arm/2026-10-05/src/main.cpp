#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
using Half = float16_t;
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("numerical contract failed");
  }
}
__attribute__((noinline)) float scalar(const Half* x, const Half* y, std::size_t n) {
  float sum = 0;
  for (std::size_t i = 0; i < n; ++i) {
    sum = std::fma(float(x[i]), float(y[i]), sum);
  }
  return sum;
}
__attribute__((noinline)) float widened(const Half* x, const Half* y, std::size_t n) {
  float32x4_t sum = vdupq_n_f32(0);
  std::size_t i = 0;
  // FP16仅存储，FCVTL先转成FP32，FMLA与归约保持FP32。
  for (; i + 4 <= n; i += 4) {
    sum = vfmaq_f32(sum, vcvt_f32_f16(vld1_f16(x + i)), vcvt_f32_f16(vld1_f16(y + i)));
  }
  float result = vaddvq_f32(sum);
  for (; i < n; ++i) {
    result = std::fma(float(x[i]), float(y[i]), result);
  }
  return result;
}
#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
__attribute__((noinline)) float narrow(const Half* x, const Half* y, std::size_t n) {
  float16x8_t sum = vdupq_n_f16(0);
  std::size_t i = 0;
  // 对照路径确实在half lane中累加；同样输入，精度合同更弱。
  for (; i + 8 <= n; i += 8) {
    sum = vfmaq_f16(sum, vld1q_f16(x + i), vld1q_f16(y + i));
  }
  Half lanes[8];
  vst1q_f16(lanes, sum);
  float result = 0;
  for (auto v : lanes) {
    result += float(v);
  }
  for (; i < n; ++i) {
    result = std::fma(float(x[i]), float(y[i]), result);
  }
  return result;
}
#endif
volatile float sink = 0;
int main() {
  try {
    std::cout << "half_bytes=" << sizeof(Half) << " fp16_vector="
#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
              << 1
#else
              << 0
#endif
              << '\n';
    std::size_t cases = 0;
    for (std::size_t n = 0; n <= 1025; ++n) {
      std::vector<Half> x(n), y(n);
      double ref = 0;
      for (std::size_t i = 0; i < n; ++i) {
        x[i] = Half((int(i % 19) - 9) * 0.0625f);
        y[i] = Half((int(i % 13) - 6) * 0.125f);
        ref += double(x[i]) * double(y[i]);
      }
      check(std::abs(scalar(x.data(), y.data(), n) - ref) < 1e-4);
      check(std::abs(widened(x.data(), y.data(), n) - ref) < 1e-4);
      ++cases;
    }
    // 存储溢出与累加溢出是不同故障。
    volatile float large = 70000.0f;
    Half overflow = Half(large);
    check(std::isinf(float(overflow)));
    volatile float tie = 1.00048828125f;
    Half rounded = Half(tie);
    check(float(rounded) == 1.0f);
    std::vector<Half> x(64, Half(300)), y(64, Half(300));
    const float wide = widened(x.data(), y.data(), 64);
    check(wide == 5760000.0f);
    std::cout << "PASS cases=" << cases << " tie=" << float(rounded)
              << " storage_overflow=" << float(overflow) << " wide_sum=" << wide;
#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
    const float low = narrow(x.data(), y.data(), 64);
    check(std::isinf(low));
    std::cout << " half_accum=" << low;
#endif
    std::cout << '\n';
    for (std::size_t n : {17U, 4096U, 65539U}) {
      x.assign(n, Half(0.25f));
      y.assign(n, Half(0.125f));
      for (int mode = 0; mode < 2; ++mode) {
        auto fn = mode == 0 ? scalar : widened;
        std::vector<double> times;
        for (int r = -5; r < 41; ++r) {
          auto t = std::chrono::steady_clock::now();
          for (int j = 0; j < 100; ++j) {
            sink = fn(x.data(), y.data(), n);
          }
          auto e = std::chrono::steady_clock::now();
          if (r >= 0) {
            times.push_back(std::chrono::duration<double, std::micro>(e - t).count() / 100);
          }
        }
        std::sort(times.begin(), times.end());
        std::cout << "n=" << n << " mode=" << mode << " cpu_batchmean_us_p50=" << times[20]
                  << " p95=" << times[38] << '\n';
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
