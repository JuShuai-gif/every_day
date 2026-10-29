#include <chrono>
#include <iostream>
#include <limits>
#include <random>
#include <vector>

#include "quantize.hpp"

void require(bool value, const char* reason) {
  if (!value) {
    throw std::runtime_error(reason);
  }
}
// 与SIMD不共用舍入实现，先转换为double后按半整数远离零作独立oracle。
int oracle(float x, float scale) {
  const float product = x * scale;
  if (std::isnan(product)) {
    return 0;
  }
  if (product >= 127) {
    return 127;
  }
  if (product <= -127) {
    return -127;
  }
  const double y = product;
  return static_cast<int>(y >= 0 ? std::floor(y + 0.5) : std::ceil(y - 0.5));
}
using Fn = void (*)(const float*, std::int8_t*, std::size_t, float);
double measure(Fn fn,
               const std::vector<float>& x,
               std::vector<std::int8_t>& q,
               std::size_t repeats) {
  const auto start = std::chrono::steady_clock::now();
  for (std::size_t j = 0; j < repeats; ++j) {
    fn(x.data(), q.data(), x.size(), 1.25f);
    // 防止重复输出被优化掉；不代表CPU缓存刷新或硬件屏障。
    asm volatile("" : : "r"(q.data()) : "memory");
  }
  return std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
             .count() /
         repeats;
}
int main() {
  try {
    std::mt19937 rng(20261020);
    std::uniform_real_distribution<float> dist(-200, 200);
    std::size_t cases = 0;
    for (std::size_t n : {0, 1, 3, 7, 8, 9, 15, 16, 17, 31, 65, 1025}) {
      for (std::size_t offset : {0, 1, 3}) {
        for (float scale : {0.5f, 1.0f, 1.25f}) {
          practice::validate_scale(scale);
          std::vector<float> x(n + offset);
          for (auto& v : x) {
            v = dist(rng);
          }
          // 精确半整数、邻值、溢出、非有限值覆盖在向量与尾部不同位置。
          const float edge[] = {-0.5f,
                                0.5f,
                                -126.5f,
                                126.5f,
                                0,
                                -0.0f,
                                std::nextafter(0.5f, 0.0f),
                                std::nextafter(0.5f, 1.0f),
                                std::numeric_limits<float>::max(),
                                -std::numeric_limits<float>::max(),
                                std::numeric_limits<float>::infinity(),
                                -std::numeric_limits<float>::infinity(),
                                std::numeric_limits<float>::quiet_NaN()};
          for (std::size_t shift = 0; shift < 13; ++shift) {
            for (std::size_t i = 0; i < n; ++i) {
              if (i % 17 < 13) {
                x[offset + i] = edge[(i + shift) % 13];
              }
            }
            std::vector<std::int8_t> a(n + 2, 42), b(n + 2, 42);
            const float* ptr = n ? x.data() + offset : nullptr;
            practice::scalar(ptr, a.data() + 1, n, scale);
            practice::neon(ptr, b.data() + 1, n, scale);
            require(a.front() == 42 && a.back() == 42 && b.front() == 42 && b.back() == 42,
                    "guard overwritten");
            for (std::size_t i = 0; i < n; ++i) {
              require(a[i + 1] == oracle(x[offset + i], scale), "scalar oracle mismatch");
              require(b[i + 1] == a[i + 1], "neon mismatch");
            }
            ++cases;
          }
        }
      }
    }
    int rejected = 0;
    for (float s : {0.0f,
                    -1.0f,
                    std::numeric_limits<float>::infinity(),
                    std::numeric_limits<float>::quiet_NaN()}) {
      try {
        practice::validate_scale(s);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    require(rejected == 4, "scale validation");
    require(practice::one(0.5f, 1) == 1 && static_cast<int>(0.5f) == 0, "rounding counterexample");
    std::cout << "PASS cases=" << cases << " invalid_scales=" << rejected
              << " ties/NaN/Inf/tails/offsets/guards\n";
    for (std::size_t n : {7, 65, 4096, 1048576}) {
      std::vector<float> x(n);
      for (auto& v : x) {
        v = dist(rng);
      }
      std::vector<std::int8_t> q(n);
      for (int j = 0; j < 8; ++j) {
        practice::scalar(x.data(), q.data(), n, 1.25f);
        practice::neon(x.data(), q.data(), n, 1.25f);
      }
      const std::size_t repeats = std::max<std::size_t>(4, 1048576 / n);
      std::vector<double> a, b;
      for (int j = 0; j < 11; ++j) {
        if (j % 2 == 0) {
          a.push_back(measure(practice::scalar, x, q, repeats));
          b.push_back(measure(practice::neon, x, q, repeats));
        } else {
          b.push_back(measure(practice::neon, x, q, repeats));
          a.push_back(measure(practice::scalar, x, q, repeats));
        }
      }
      std::sort(a.begin(), a.end());
      std::sort(b.begin(), b.end());
      std::cout << "CPU batch_mean_us n=" << n << " repeats=" << repeats << " scalar_p50=" << a[5]
                << " neon_p50=" << b[5] << " scalar_p95=" << a[10] << " neon_p95=" << b[10] << "\n";
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
