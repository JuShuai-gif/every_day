#include <arm_neon.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("ARM comparison failed");
  }
}
// U改变独立累加链数，保持相同FP32乘加与输入顺序分派。
template <int U>
__attribute__((noinline)) float dot(const float* x, const float* y, std::size_t n) {
  std::array<float32x4_t, U> acc;
  for (auto& v : acc) {
    v = vdupq_n_f32(0);
  }
  std::size_t i = 0;
  for (; n - i >= 4 * U; i += 4 * U) {
    for (int j = 0; j < U; ++j) {
      acc[j] = vfmaq_f32(acc[j], vld1q_f32(x + i + 4 * j), vld1q_f32(y + i + 4 * j));
    }
  }
  for (int j = 1; j < U; ++j) {
    acc[0] = vaddq_f32(acc[0], acc[j]);
  }
  float result = vaddvq_f32(acc[0]);
  for (; i < n; ++i) {
    result = std::fma(x[i], y[i], result);
  }
  return result;
}
using Fn = float (*)(const float*, const float*, std::size_t);
volatile float sink = 0;
int main() {
  try {
    std::vector<float> x(65539), y(x.size());
    for (std::size_t i = 0; i < x.size(); ++i) {
      x[i] = float(int(i % 43) - 21) / 32;
      y[i] = float(int(i % 71) - 35) / 32;
    }
    std::array<Fn, 3> f{dot<1>, dot<4>, dot<16>};
    int tests = 0;
    double maxerror = 0;
    for (std::size_t n = 0; n < 1027; ++n) {
      double gold = 0;
      for (std::size_t i = 0; i < n; ++i) {
        gold += double(x[i]) * y[i];
      }
      for (auto fn : f) {
        double got = fn(x.data(), y.data(), n);
        maxerror = std::max(maxerror, std::abs(got - gold));
        check(std::abs(got - gold) < 0.001 + std::abs(gold) * 1e-5);
        ++tests;
      }
    }
    std::cout << "PASS comparisons=" << tests << " max_abs_error=" << maxerror << '\n';
    for (std::size_t n : {std::size_t(7), std::size_t(4096), std::size_t(65539)}) {
      double gold = 0;
      for (std::size_t i = 0; i < n; ++i) {
        gold += double(x[i]) * y[i];
      }
      for (auto fn : f) {
        check(std::abs(double(fn(x.data(), y.data(), n)) - gold) < 0.001 + std::abs(gold) * 1e-5);
      }
      std::cout << "PASS benchmark_shape=" << n << " candidates=3" << '\n';
      std::array<std::vector<double>, 3> times;
      // 交错候选次序，减少固定执行顺序的温度/频率偏差；样本为100次调用均值。
      for (int s = -20; s < 100; ++s) {
        for (int j = 0; j < 3; ++j) {
          int mode = (s + 21 + j) % 3;
          auto start = std::chrono::steady_clock::now();
          for (int k = 0; k < 100; ++k) {
            asm volatile("" ::: "memory");
            sink = f[mode](x.data(), y.data(), n);
          }
          double us =
              std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
                  .count() /
              100;
          if (s >= 0) {
            times[mode].push_back(us);
          }
        }
      }
      for (int mode = 0; mode < 3; ++mode) {
        auto& t = times[mode];
        std::sort(t.begin(), t.end());
        std::cout << "N=" << n << " accumulators=" << std::array<int, 3>{1, 4, 16}[mode]
                  << " CPU_batch_mean_p50_us=" << t[50] << " p95_us=" << t[94] << '\n';
      }
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
