#include <arm_neon.h>

#include <cerrno>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>
#if defined(__APPLE__)
#include <sys/sysctl.h>
#elif defined(__linux__)
#include <asm/hwcap.h>
#include <sys/auxv.h>
#endif
extern "C" int64_t dot_optional(const int8_t*, const int8_t*, size_t);
struct Caps {
  bool neon = false, dot = false, i8mm = false, sve = false, sve2 = false;
};
#if defined(__APPLE__)
bool query(const char* key) {
  int value = 0;
  size_t bytes = sizeof(value);
  if (sysctlbyname(key, &value, &bytes, nullptr, 0) != 0) {
    std::cout << "cap_query_failed key=" << key << " errno=" << errno << " fallback=false\n";
    return false;
  }
  return value != 0;
}
#endif
Caps capabilities() {
  Caps c;
#if defined(__APPLE__)
  c.neon = query("hw.optional.neon");
  c.dot = query("hw.optional.arm.FEAT_DotProd");
  c.i8mm = query("hw.optional.arm.FEAT_I8MM");
#elif defined(__linux__)
  errno = 0;
  const auto h = getauxval(AT_HWCAP), h2 = getauxval(AT_HWCAP2);
  if (errno != 0) {
    std::cerr << "auxv query failed; fallback\n";
    return c;
  }
  c.neon = (h & HWCAP_ASIMD) != 0;
  c.dot = (h & HWCAP_ASIMDDP) != 0;
  c.sve = (h & HWCAP_SVE) != 0;
#ifdef HWCAP2_I8MM
  c.i8mm = (h2 & HWCAP2_I8MM) != 0;
#endif
#ifdef HWCAP2_SVE2
  c.sve2 = (h2 & HWCAP2_SVE2) != 0;
#endif
  (void)h2;
#endif
  return c;
}
extern "C" __attribute__((noinline)) int64_t scalar(const int8_t* a, const int8_t* b, size_t n) {
  int64_t total = 0;
  for (size_t i = 0; i < n; ++i) {
    total += static_cast<int32_t>(a[i]) * b[i];
  }
  return total;
}
extern "C" __attribute__((noinline)) int64_t neon(const int8_t* a, const int8_t* b, size_t n) {
  int32x4_t acc = vdupq_n_s32(0);
  size_t i = 0;
  for (; i + 16 <= n; i += 16) {
    const auto x = vld1q_s8(a + i), y = vld1q_s8(b + i);
    acc = vpadalq_s16(acc, vmull_s8(vget_low_s8(x), vget_low_s8(y)));
    acc = vpadalq_s16(acc, vmull_high_s8(x, y));
  }
  int64_t total = vaddvq_s32(acc);
  for (; i < n; ++i) {
    total += static_cast<int32_t>(a[i]) * b[i];
  }
  return total;
}
using Fn = int64_t (*)(const int8_t*, const int8_t*, size_t);
Fn choose(Caps c, bool force_scalar) {
  if (force_scalar) {
    return scalar;
  }
  if (c.dot) {
    return dot_optional;
  }
  if (c.neon) {
    return neon;
  }
  return scalar;
}
int64_t run(const std::vector<int8_t>& a, const std::vector<int8_t>& b, Fn f) {
  // N上界使最坏值 65536*128*128=2^30，向量归约不会溢出int32。
  if (a.size() != b.size() || a.size() > 65536) {
    throw std::invalid_argument("shape/accumulator limit");
  }
  return f(a.data(), b.data(), a.size());
}
int main() {
  try {
    const auto c = capabilities();
    std::cout << "caps neon=" << c.neon << " dot=" << c.dot << " i8mm=" << c.i8mm
              << " sve=" << c.sve << " sve2=" << c.sve2 << " selected="
              << (choose(c, false) == dot_optional ? "dot"
                  : choose(c, false) == neon       ? "neon"
                                                   : "scalar")
              << "\n";
    if (choose({}, false) != scalar || choose({true, false, false, false, false}, false) != neon ||
        choose(c, true) != scalar) {
      throw std::runtime_error("dispatch contract");
    }
    size_t cases = 0;
    for (size_t n : {0, 1, 15, 16, 17, 31, 33, 65536}) {
      for (int mode : {0, 1}) {
        std::vector<int8_t> a(n), b(n);
        for (size_t i = 0; i < n; ++i) {
          a[i] = mode ? -128 : static_cast<int8_t>(static_cast<int>(i % 251) - 125);
          b[i] = mode ? -128 : static_cast<int8_t>(static_cast<int>((i * 7) % 251) - 125);
        }
        const auto ref = run(a, b, scalar);
        if (run(a, b, choose(c, false)) != ref) {
          throw std::runtime_error("selected mismatch");
        }
        if ((c.neon || c.dot) && run(a, b, neon) != ref) {
          throw std::runtime_error("neon mismatch");
        }
        ++cases;
      }
    }
    int rejected = 0;
    try {
      run(std::vector<int8_t>(1), {}, scalar);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    try {
      run(std::vector<int8_t>(65537), std::vector<int8_t>(65537), scalar);
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    if (rejected != 2) {
      throw std::runtime_error("missing rejections");
    }
    std::cout << "PASS cases=" << cases << " rejections=" << rejected
              << " synthetic_dispatch_only=3\n";
    return 0;
  } catch (const std::exception& e) {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
