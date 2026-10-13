#pragma once
#include <algorithm>
#include <cmath>
#include <stdexcept>
#include <vector>
struct Shape {
  int m, n, k, lda, ldb;
  Shape(int a, int b, int c) : m(a), n(b), k(c), lda(0), ldb(0) {
    if (m < 1 || n < 1 || k < 1 || m > 2048 || n > 2048 || k > 2048) {
      throw std::invalid_argument("shape outside [1,2048]");
    }
    lda = (k + 3) / 4 * 4;
    ldb = (n + 3) / 4 * 4;
  }
};
inline std::vector<float> input(int rows, int cols, int stride, int seed) {
  // padding故意写入脏值；逻辑边界必须由加载器处理。
  std::vector<float> x(rows * stride, 999.0f);
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      x[r * stride + c] = float(((r * 17 + c * 13 + seed) % 23) - 11) / 16;
    }
  }
  return x;
}
inline std::vector<float> reference(const Shape& s,
                                    const std::vector<float>& a,
                                    const std::vector<float>& b) {
  std::vector<float> c(s.m * s.n);
  for (int r = 0; r < s.m; ++r) {
    for (int n = 0; n < s.n; ++n) {
      double v = 0;
      for (int k = 0; k < s.k; ++k) {
        v += double(a[r * s.lda + k]) * b[k * s.ldb + n];
      }
      c[r * s.n + n] = float(v);
    }
  }
  return c;
}
inline void check(const std::vector<float>& got, const std::vector<float>& want) {
  if (got.size() != want.size()) {
    throw std::runtime_error("size mismatch");
  }
  for (std::size_t i = 0; i < got.size(); ++i) {
    if (!std::isfinite(got[i]) || std::abs(got[i] - want[i]) > 1e-4f + 1e-4f * std::abs(want[i])) {
      throw std::runtime_error("numerical mismatch");
    }
  }
}
