#pragma once
#include <algorithm>
#include <cmath>
#include <stdexcept>
#include <vector>
inline std::vector<float> softmax_reference(const std::vector<float>& x, int rows, int cols) {
  if (rows < 1 || rows > 4096 || cols < 1 || cols > 256 ||
      x.size() != static_cast<std::size_t>(rows) * cols) {
    throw std::invalid_argument("shape");
  }
  for (float v : x) {
    if (!std::isfinite(v)) {
      throw std::invalid_argument("finite logits required");
    }
  }
  std::vector<float> out(x.size());
  for (int r = 0; r < rows; ++r) {
    const double m = *std::max_element(x.begin() + r * cols, x.begin() + (r + 1) * cols);
    double sum = 0;
    for (int c = 0; c < cols; ++c) {
      sum += std::exp(static_cast<double>(x[r * cols + c]) - m);
    }
    for (int c = 0; c < cols; ++c) {
      out[r * cols + c] =
          static_cast<float>(std::exp(static_cast<double>(x[r * cols + c]) - m) / sum);
    }
  }
  return out;
}
inline std::vector<float> input(int rows, int cols, int pattern = 0) {
  std::vector<float> x(static_cast<std::size_t>(rows) * cols);
  for (std::size_t i = 0; i < x.size(); ++i) {
    x[i] = pattern == 1   ? 10000.0F
           : pattern == 2 ? (i % cols == 0 ? 10000.0F : -10000.0F)
                          : std::sin(static_cast<float>(i) * 0.37F) * 13.0F;
  }
  return x;
}
inline void verify(const std::vector<float>& got, const std::vector<float>& ref, int cols) {
  if (got.size() != ref.size()) {
    throw std::runtime_error("size mismatch");
  }
  for (std::size_t i = 0; i < ref.size(); ++i) {
    if (!std::isfinite(got[i]) || std::abs(got[i] - ref[i]) > 2e-6F + 2e-5F * std::abs(ref[i])) {
      throw std::runtime_error("value mismatch");
    }
  }
  for (std::size_t row = 0; row < got.size(); row += cols) {
    double sum = 0;
    for (int c = 0; c < cols; ++c) {
      sum += got[row + c];
    }
    if (std::abs(sum - 1) > 2e-5) {
      throw std::runtime_error("normalization");
    }
  }
}
