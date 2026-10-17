#pragma once
#include <cmath>
#include <cstddef>
#include <stdexcept>
#include <vector>
inline void validate(int rows, int cols, int stride) {
  if (rows < 1 || rows > 65535 || cols < 1 || cols > 65536 || stride < cols || stride > 65540) {
    throw std::invalid_argument("shape/stride outside bounded contract");
  }
}
inline std::vector<float> input(int rows, int cols, int stride) {
  validate(rows, cols, stride);
  std::vector<float> x(static_cast<std::size_t>(rows) * stride, -999.0f);
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      x[static_cast<std::size_t>(r) * stride + c] =
          static_cast<float>((r * 7 + c * 13) % 101 - 50) / 32.0f;
    }
  }
  return x;
}
inline double reference(const float* x, int cols) {
  double sum = 0;
  for (int c = 0; c < cols; ++c) {
    sum += static_cast<double>(x[c]) * x[c];
  }
  return sum;
}
inline void check(float got, double expected) {
  if (!std::isfinite(got) || std::abs(got - expected) > 1e-5 + 3e-5 * expected) {
    throw std::runtime_error("energy mismatch");
  }
}
