#include <arm_neon.h>

#include <cmath>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
void ck(bool b, const char* m) {
  if (!b)
    throw std::runtime_error(m);
}
// 外部合同避免非有限值/溢出进入算法；真实服务应结合量程设置更具体的限制。
void validate(const std::vector<float>& a, const std::vector<float>& b) {
  if (a.size() != b.size() || a.size() > 4096)
    throw std::invalid_argument("shape");
  for (std::size_t i = 0; i < a.size(); ++i)
    if (!std::isfinite(a[i]) || !std::isfinite(b[i]) || std::abs(a[i]) > 1e10f ||
        std::abs(b[i]) > 1e10f)
      throw std::invalid_argument("range/nonfinite");
}
__attribute__((noinline)) float scalar(const float* a, const float* b, std::size_t n) {
  float sum = 0;
  for (std::size_t i = 0; i < n; ++i)
    sum = sum + a[i] * b[i];
  return sum;
}
__attribute__((noinline)) float fused(const float* a, const float* b, std::size_t n) {
  float sum = 0;
  for (std::size_t i = 0; i < n; ++i)
    sum = std::fma(a[i], b[i], sum);
  return sum;
}
__attribute__((noinline)) float neon(const float* a, const float* b, std::size_t n) {
  float32x4_t s = vdupq_n_f32(0);
  std::size_t i = 0;
  for (; i + 4 <= n; i += 4)
    s = vfmaq_f32(s, vld1q_f32(a + i), vld1q_f32(b + i));
  float sum = vaddvq_f32(s);
  for (; i < n; ++i)
    sum = std::fma(a[i], b[i], sum);
  return sum;
}
__attribute__((noinline)) float separate(float a, float b, float c) {
  return a * b + c;
}
int main() {
  try {
    int cases = 0;
    double worst = 0;
    for (int n = 0; n <= 257; ++n) {
      std::vector<float> a(n), b(n);
      for (int i = 0; i < n; ++i) {
        a[i] = float(i % 19 - 9) / 7;
        b[i] = float(i % 13 - 6) / 9;
      }
      validate(a, b);
      double ref = 0, abs_sum = 0;
      for (int i = 0; i < n; ++i) {
        double p = double(a[i]) * b[i];
        ref += p;
        abs_sum += std::abs(p);
      }
      double tol = 1e-6 + 4 * (n + 1) * std::numeric_limits<float>::epsilon() * abs_sum;
      for (auto f : {scalar, fused, neon}) {
        double err = std::abs(double(f(a.data(), b.data(), n)) - ref);
        worst = std::max(worst, err);
        ck(err <= tol, "numeric contract");
        ++cases;
      }
    }
    float a = 1.0f + std::ldexp(1.0f, -23), b = 1.0f - std::ldexp(1.0f, -23);
    float sep = separate(a, b, -1), fm = std::fma(a, b, -1);
    ck(sep == 0 && fm == -std::ldexp(1.0f, -46), "fusion counterexample");
    std::vector<float> x{1e8f, 1, -1e8f, 1}, one(4, 1);
    validate(x, one);
    std::cout << "cancel sequential=" << scalar(x.data(), one.data(), 4)
              << " neon_tree=" << neon(x.data(), one.data(), 4) << " double_oracle=2\n";
    int invalid = 0;
    for (float v : {std::numeric_limits<float>::infinity(),
                    std::numeric_limits<float>::quiet_NaN(),
                    std::numeric_limits<float>::max()}) {
      try {
        validate({v}, {2});
      } catch (const std::invalid_argument&) {
        ++invalid;
      }
    }
    ck(invalid == 3, "rejection");
    std::cout << "PASS cases=" << cases << " worst_abs_error=" << worst << " separate=" << sep
              << " fma=" << fm << " invalid=" << invalid << "\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
