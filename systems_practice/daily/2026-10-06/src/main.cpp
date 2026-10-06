#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <vector>
#if defined(__APPLE__)
#include <sys/sysctl.h>
#elif defined(__linux__)
#include <asm/hwcap.h>
#include <sys/auxv.h>
#endif
using Dot = int32_t (*)(const int8_t*, const int8_t*, size_t);
void check(bool x) {
  if (!x) {
    throw std::runtime_error("contract failed");
  }
}
// 每块至多4096项；即使全部为-128，归约也不会超过INT32。
__attribute__((noinline)) int32_t scalar(const int8_t* a, const int8_t* b, size_t n) {
  int32_t s = 0;
  for (size_t i = 0; i < n; ++i) {
    s += int32_t(a[i]) * int32_t(b[i]);
  }
  return s;
}
__attribute__((noinline)) int32_t widening(const int8_t* a, const int8_t* b, size_t n) {
  int32x4_t s = vdupq_n_s32(0);
  size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    auto x = vld1q_s8(a + i), y = vld1q_s8(b + i);
    // 乘积先扩到16位，再成对扩到32位，不能在16位累加两个极值乘积。
    s = vpadalq_s16(s, vmull_s8(vget_low_s8(x), vget_low_s8(y)));
    s = vpadalq_s16(s, vmull_high_s8(x, y));
  }
  int32_t r = vaddvq_s32(s);
  for (; i < n; ++i) {
    r += int32_t(a[i]) * int32_t(b[i]);
  }
  return r;
}
__attribute__((target("dotprod"), noinline)) int32_t dotprod(const int8_t* a,
                                                             const int8_t* b,
                                                             size_t n) {
  int32x4_t s = vdupq_n_s32(0);
  size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    s = vdotq_s32(s, vld1q_s8(a + i), vld1q_s8(b + i));
  }
  int32_t r = vaddvq_s32(s);
  for (; i < n; ++i) {
    r += int32_t(a[i]) * int32_t(b[i]);
  }
  return r;
}
bool has_dot() {
#if defined(__APPLE__)
  int v = 0;
  size_t n = sizeof(v);
  return sysctlbyname("hw.optional.arm.FEAT_DotProd", &v, &n, nullptr, 0) == 0 && v != 0;
#elif defined(__linux__) && defined(HWCAP_ASIMDDP)
  return (getauxval(AT_HWCAP) & HWCAP_ASIMDDP) != 0;
#else
  return false;
#endif
}
struct Input {
  std::vector<int8_t> a, b;
  std::vector<float> sa, sb;
  size_t group;
  Input(size_t n, size_t g) : a(n), b(n), group(g) {
    if (g == 0 || g > 4096) {
      throw std::invalid_argument("group outside [1,4096]");
    }
    sa.resize(n / g + (n % g != 0));
    sb.resize(sa.size());
    for (size_t i = 0; i < n; ++i) {
      a[i] = int(i * 17 % 256) - 128;
      b[i] = int(i * 31 % 256) - 128;
    }
    for (size_t i = 0; i < sa.size(); ++i) {
      sa[i] = float(1 + i % 7) / 128;
      sb[i] = float(1 + i % 11) / 64;
    }
  }
};
void validate(const Input& x) {
  if (x.group == 0 || x.group > 4096 || x.a.size() != x.b.size() ||
      x.sa.size() != x.a.size() / x.group + (x.a.size() % x.group != 0) ||
      x.sb.size() != x.sa.size()) {
    throw std::invalid_argument("shape");
  }
  for (size_t i = 0; i < x.sa.size(); ++i) {
    if (!std::isfinite(x.sa[i]) || !std::isfinite(x.sb[i]) || x.sa[i] < 0 || x.sb[i] < 0) {
      throw std::invalid_argument("scale");
    }
  }
}
// 相同块顺序与double缩放确保只比较整数核；计时不含validate与量化。
__attribute__((noinline)) double grouped(const Input& x, Dot kernel) {
  double out = 0;
  size_t j = 0;
  for (size_t i = 0; i < x.a.size(); i += x.group, ++j) {
    const size_t n = std::min(x.group, x.a.size() - i);
    out += double(kernel(x.a.data() + i, x.b.data() + i, n)) * double(x.sa[j]) * double(x.sb[j]);
  }
  return out;
}
double oracle(const Input& x) {
  double s = 0;
  for (size_t i = 0; i < x.a.size(); ++i) {
    s += double(x.a[i]) * x.b[i] * double(x.sa[i / x.group]) * x.sb[i / x.group];
  }
  return s;
}
volatile double sink = 0;
void bench(const Input& x, Dot f, const char* label) {
  for (int i = 0; i < 20; ++i) {
    sink = grouped(x, f);
  }
  std::vector<double> samples;
  for (int s = 0; s < 41; ++s) {
    auto t = std::chrono::steady_clock::now();
    for (int j = 0; j < 100; ++j) {
      sink = grouped(x, f);
    }
    auto e = std::chrono::steady_clock::now();
    samples.push_back(std::chrono::duration<double, std::micro>(e - t).count() / 100);
  }
  std::sort(samples.begin(), samples.end());
  std::cout << "K=" << x.a.size() << " group=" << x.group << " " << label
            << " CPU batch_mean_us p50=" << samples[20] << " p95=" << samples[38] << "\n";
}
int main() {
  try {
    const bool dot = has_dot();
    size_t cases = 0;
    std::cout << "runtime_dotprod=" << dot << "\n";
    for (size_t g : {1u, 15u, 16u, 31u, 32u, 33u, 256u, 4096u}) {
      for (size_t n = 0; n <= 513; ++n) {
        Input x(n, g);
        validate(x);
        double ref = oracle(x);
        check(grouped(x, scalar) == ref);
        check(grouped(x, widening) == ref);
        if (dot) {
          check(grouped(x, dotprod) == ref);
        }
        ++cases;
      }
    }
    for (size_t n : {4095u, 4096u, 4097u, 131072u}) {
      Input x(n, 4096);
      std::fill(x.a.begin(), x.a.end(), -128);
      std::fill(x.b.begin(), x.b.end(), -128);
      check(grouped(x, widening) == oracle(x));
      if (dot) {
        check(grouped(x, dotprod) == oracle(x));
      }
      ++cases;
    }
    int failures = 0;
    for (int c = 0; c < 4; ++c) {
      try {
        Input x(33, 32);
        if (c == 0) {
          x.group = 0;
        }
        if (c == 1) {
          x.b.pop_back();
        }
        if (c == 2) {
          x.sa[0] = NAN;
        }
        if (c == 3) {
          x.sb[0] = -1;
        }
        validate(x);
      } catch (const std::invalid_argument&) {
        ++failures;
      }
    }
    check(failures == 4);
    // 错误scale提升反例，不执行溢出或越界来展示错误。
    Input hand(64, 32);
    std::fill(hand.a.begin(), hand.a.end(), 1);
    std::fill(hand.b.begin(), hand.b.end(), 1);
    hand.sa = {1, 10};
    hand.sb = {1, 2};
    check(grouped(hand, widening) == 672);
    check(scalar(hand.a.data(), hand.b.data(), 64) == 64);
    std::cout << "PASS cases=" << cases << " rejected=" << failures
              << " hand=672 wrong_global_scale=64\n";
    for (size_t n : {17u, 4099u, 65539u}) {
      Input x(n, 32);
      bench(x, scalar, "scalar");
      bench(x, widening, "widening");
      if (dot) {
        bench(x, dotprod, "dotprod");
      }
    }
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
