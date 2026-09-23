#include <sys/utsname.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <iostream>
#include <limits>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

#include "dot.hpp"

namespace {
volatile float sink = 0;
void require(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
template <class F>
void rejects(F f) {
  bool caught = false;
  try {
    f();
  } catch (const std::invalid_argument&) {
    caught = true;
  }
  require(caught, "invalid argument not rejected");
}
}  // namespace

int main(int argc, char** argv) {
  try {
    const bool bench = argc == 1 || (argc == 2 && std::string(argv[1]) == "--bench");
    if (argc > 2 ||
        (argc == 2 && std::string(argv[1]) != "--bench" && std::string(argv[1]) != "--check")) {
      throw std::invalid_argument("usage: q8_dot [--check|--bench]");
    }
    struct utsname info{};
    require(uname(&info) == 0, "uname failed");
    std::cout << "system=" << info.sysname << " " << info.release << " " << info.machine
              << " compiler=" << __VERSION__ << " dotprod_compiled=" << has_compiled_dot() << '\n';
    std::mt19937 rng(20260923);
    const std::array<BlockDot, 3> impl = {scalar_dot, neon_dot, optional_dot};
    std::size_t cases = 0;
    // 精确长度分配，ASan可以发现跨尾加载；额外测试非16B对齐起点。
    for (std::size_t n = 0; n <= 32; ++n) {
      for (std::size_t offset : {0U, 1U, 3U}) {
        for (int pattern = 0; pattern < 4; ++pattern) {
          std::vector<std::int8_t> x(n + offset), y(n + offset);
          std::int64_t expected = 0;
          for (std::size_t i = 0; i < n; ++i) {
            x[offset + i] = pattern == 0   ? -128
                            : pattern == 1 ? 127
                            : pattern == 2 ? 0
                                           : static_cast<int>(rng() % 256) - 128;
            y[offset + i] = pattern == 0   ? -128
                            : pattern == 1 ? -128
                            : pattern == 2 ? 0
                                           : static_cast<int>(rng() % 256) - 128;
            expected += static_cast<std::int64_t>(x[offset + i]) * y[offset + i];
          }
          for (auto f : impl) {
            require(
                f(n ? x.data() + offset : nullptr, n ? y.data() + offset : nullptr, n) == expected,
                "integer oracle mismatch");
            ++cases;
          }
        }
      }
    }
    for (std::size_t n : {0U, 1U, 17U, 31U, 32U, 33U, 63U, 64U, 65U, 1027U}) {
      std::vector<std::int8_t> x(n), y(n);
      std::vector<float> sx((n + 31) / 32), sy(sx.size());
      for (std::size_t i = 0; i < n; ++i) {
        x[i] = static_cast<int>(rng() % 256) - 128;
        y[i] = static_cast<int>(rng() % 256) - 128;
      }
      // 二进制精确scale，独立double oracle逐元素求和。
      double ref = 0;
      for (std::size_t b = 0; b < sx.size(); ++b) {
        sx[b] = (b % 5 + 1) / 128.0f;
        sy[b] = (b % 7 + 1) / 256.0f;
      }
      for (std::size_t i = 0; i < n; ++i) {
        ref += static_cast<double>(x[i]) * y[i] * sx[i / 32] * sy[i / 32];
      }
      const float base = scaled_dot(x.data(), y.data(), sx.data(), sy.data(), n, scalar_dot);
      require(std::abs(base - ref) <= 1e-4 + std::abs(ref) * 1e-6, "scale oracle mismatch");
      for (auto f : impl) {
        require(scaled_dot(x.data(), y.data(), sx.data(), sy.data(), n, f) == base,
                "scaled mismatch");
        ++cases;
      }
    }
    std::int8_t a = 1;
    float s = 1;
    for (auto f : impl) {
      rejects([&] {
        f(&a, &a, 33);
      });
      rejects([&] {
        f(nullptr, &a, 1);
      });
    }
    rejects([&] {
      scaled_dot(nullptr, &a, &s, &s, 1, scalar_dot);
    });
    rejects([&] {
      scaled_dot(&a, &a, &s, &s, 1, nullptr);
    });
    float bad = std::numeric_limits<float>::quiet_NaN();
    rejects([&] {
      scaled_dot(&a, &a, &bad, &s, 1, neon_dot);
    });
    bad = -1;
    rejects([&] {
      scaled_dot(&a, &a, &bad, &s, 1, neon_dot);
    });
    std::cout << "correctness_cases=" << cases << " invalid_cases=10 PASS\n";
    if (!bench) {
      return 0;
    }
    constexpr std::size_t k = 1027, rows = 64, blocks = (k + 31) / 32;
    std::vector<std::int8_t> x(k), weights(k * rows);
    std::vector<float> sx(blocks), sw(blocks * rows), out(rows);
    for (auto& v : x) {
      v = static_cast<int>(rng() % 256) - 128;
    }
    for (auto& v : weights) {
      v = static_cast<int>(rng() % 256) - 128;
    }
    for (auto& v : sx) {
      v = (rng() % 5 + 1) / 128.0f;
    }
    for (auto& v : sw) {
      v = (rng() % 7 + 1) / 256.0f;
    }
    auto run = [&](BlockDot f) {
      for (std::size_t r = 0; r < rows; ++r) {
        out[r] =
            scaled_dot(x.data(), weights.data() + r * k, sx.data(), sw.data() + r * blocks, k, f);
      }
      sink = out[0];
    };
    run(scalar_dot);
    const auto oracle = out;
    for (auto f : impl) {
      run(f);
      require(out == oracle, "benchmark input mismatch");
    }
    for (int i = 0; i < 20; ++i) {
      for (auto f : impl) {
        run(f);
      }
    }
    std::array<std::vector<double>, 3> times;
    // 交错轮转版本顺序，减少温度/调频随时间漂移对一方的偏向。
    for (int sample = 0; sample < 100; ++sample) {
      for (int j = 0; j < 3; ++j) {
        const int which = (j + sample) % 3;
        auto start = std::chrono::steady_clock::now();
        run(impl[which]);
        auto end = std::chrono::steady_clock::now();
        times[which].push_back(std::chrono::duration<double, std::micro>(end - start).count());
      }
    }
    const std::array<const char*, 3> names = {"scalar", "neon_widen", "dot_or_fallback"};
    std::cout << "CPU only: M=1 N=64 K=1027 warmups=20 samples=100 includes_scale_checks_and_calls "
                 "excludes_quantization_allocation_io\n";
    for (std::size_t i = 0; i < times.size(); ++i) {
      auto& t = times[i];
      std::sort(t.begin(), t.end());
      std::cout << names[i] << " p50_us=" << t[49] << " p95_us=" << t[94] << '\n';
    }
    std::cout << "checksum=" << sink << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
