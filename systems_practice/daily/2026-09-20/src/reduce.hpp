#pragma once
#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>
#ifdef __CUDACC__
#define HD __host__ __device__
#else
#define HD
#endif
namespace practice {
struct Shape {
  int rows, cols, stride;
  void validate() const {
    // 教学内存上限同时防止地址乘法溢出；stride可包含NaN填充。
    if (rows < 1 || rows > 4096 || cols < 1 || cols > 65536 || stride < cols || stride > 65544) {
      throw std::invalid_argument("invalid rows/cols/stride");
    }
  }
  std::size_t count() const {
    validate();
    return std::size_t(rows) * stride;
  }
};
// 与CUDA共用线程内分区；多个累加器打断单条循环携带依赖。
template <int Acc, int Threads>
HD float partial(const float* row, int cols, int tid) {
  static_assert(Acc == 1 || Acc == 2 || Acc == 4 || Acc == 8);
  float sums[Acc] = {};
  for (int base = tid; base < cols; base += Acc * Threads) {
#ifdef __CUDACC__
#pragma unroll
#endif
    for (int j = 0; j < Acc; ++j) {
      int c = base + j * Threads;
      if (c < cols) {
        sums[j] += row[c];
      }
    }
  }
  float total = sums[0];
#ifdef __CUDACC__
#pragma unroll
#endif
  for (int j = 1; j < Acc; ++j) {
    total += sums[j];
  }
  return total;
}
inline std::vector<float> input(Shape s, int pattern = 0) {
  std::vector<float> a(s.count(), std::numeric_limits<float>::quiet_NaN());
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      float v = float(std::sin((r * 17 + c) * .013) + .1 * std::cos(c * .071));
      if (pattern == 1) {
        v = 0;
      }
      if (pattern == 2) {
        v = (c % 2 ? -100.0f : 100.0f) + .001f;
      }
      a[std::size_t(r) * s.stride + c] = v;
    }
  }
  return a;
}
inline std::vector<double> oracle(Shape s, const std::vector<float>& a) {
  if (a.size() != s.count()) {
    throw std::invalid_argument("input size mismatch");
  }
  std::vector<double> y(s.rows, 0);
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      y[r] += double(a[std::size_t(r) * s.stride + c]);
    }
  }
  return y;
}
inline void check(Shape s, const std::vector<float>& a, const std::vector<float>& y) {
  auto ref = oracle(s, a);
  if (y.size() != ref.size()) {
    throw std::runtime_error("output size");
  }
  for (int r = 0; r < s.rows; ++r) {
    double l1 = 0;
    for (int c = 0; c < s.cols; ++c) {
      l1 += std::abs(double(a[std::size_t(r) * s.stride + c]));
    }
    // 同一容限覆盖不同结合顺序；近零和使用绝对/L1界，不使用相对误差除零。
    double tolerance = 2e-5 + 2e-6 * l1;
    if (!std::isfinite(y[r]) || std::abs(y[r] - ref[r]) > tolerance) {
      throw std::runtime_error("FP64 oracle mismatch at row " + std::to_string(r));
    }
  }
}
template <int Acc, int Threads>
std::vector<float> emulate(Shape s, const std::vector<float>& a) {
  std::vector<float> y(s.rows);
  for (int r = 0; r < s.rows; ++r) {
    std::array<float, Threads> lanes{};
    for (int t = 0; t < Threads; ++t) {
      lanes[t] = partial<Acc, Threads>(a.data() + std::size_t(r) * s.stride, s.cols, t);
    }
    // 使用快照模拟shuffle并行读取，不能在原数组上顺序覆盖。
    for (int offset = 16; offset > 0; offset /= 2) {
      auto old = lanes;
      for (int t = 0; t < Threads; ++t) {
        if (t % 32 + offset < 32) {
          lanes[t] += old[t + offset];
        }
      }
    }
    std::array<float, 32> warp{};
    for (int w = 0; w < Threads / 32; ++w) {
      warp[w] = lanes[w * 32];
    }
    for (int offset = 16; offset > 0; offset /= 2) {
      auto old = warp;
      for (int t = 0; t + offset < 32; ++t) {
        warp[t] += old[t + offset];
      }
    }
    y[r] = warp[0];
  }
  return y;
}
inline std::vector<Shape> cases() {
  std::vector<Shape> result;
  for (int rows : {1, 3, 65}) {
    for (int cols : {1, 17, 31, 32, 33, 127, 128, 129, 255, 256, 257, 1023, 1024, 1025, 4097}) {
      result.push_back({rows, cols, cols + 3});
    }
  }
  return result;
}
}  // namespace practice
#undef HD
