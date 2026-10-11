#pragma once
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <stdexcept>
#include <vector>

inline std::size_t elements(int batch, int width) {
  // 同一个合同用于 CPU oracle、CUDA 与 TensorRT 的提交前检查。
  if (batch < 1 || batch > 8 || width < 1 || width > 4097) {
    throw std::invalid_argument("shape outside [1..8,1..4097]");
  }
  return static_cast<std::size_t>(batch) * static_cast<std::size_t>(width);
}
inline float reference(float x) {
  if (!std::isfinite(x)) {
    throw std::invalid_argument("finite input required");
  }
  return std::max(0.0F, x * 0.5F + 0.25F);
}
inline void check(const std::vector<float>& x, const std::vector<float>& y) {
  if (x.size() != y.size()) {
    throw std::runtime_error("output size");
  }
  for (std::size_t i = 0; i < x.size(); ++i) {
    if (!std::isfinite(y[i]) || std::abs(y[i] - reference(x[i])) > 1e-6F) {
      throw std::runtime_error("output mismatch at " + std::to_string(i));
    }
  }
}
