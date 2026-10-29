#pragma once
#include <algorithm>
#include <array>
#include <cmath>
#include <stdexcept>
#include <vector>

inline void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
inline void contract(int rows, int cols, int stride, float eps) {
  require(rows > 0 && rows <= 4096 && cols > 0 && cols <= 1024 && stride >= cols && stride <= 2048,
          "invalid shape/stride");
  require(std::isfinite(eps) && eps >= 1e-8f && eps <= 1.0f, "invalid epsilon");
}
inline std::vector<float> inputs(int rows, int cols, int stride, bool zero = false) {
  contract(rows, cols, stride, 1e-5f);
  std::vector<float> x(static_cast<size_t>(rows) * stride, 999.0f);
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      x[r * stride + c] = zero ? 0.0f : float((r * 17 + c * 13) % 257 - 128) / 8;
    }
  }
  return x;
}
inline void validate(const std::vector<float>& x, int rows, int cols, int stride, float eps) {
  contract(rows, cols, stride, eps);
  require(x.size() == static_cast<size_t>(rows) * stride, "input storage mismatch");
  for (int r = 0; r < rows; ++r) {
    for (int c = 0; c < cols; ++c) {
      require(std::isfinite(x[r * stride + c]) && std::abs(x[r * stride + c]) <= 128.0f,
              "input range/nonfinite");
    }
  }
}
inline std::vector<float> reference(
    const std::vector<float>& x, int rows, int cols, int stride, float eps) {
  validate(x, rows, cols, stride, eps);
  std::vector<float> y(static_cast<size_t>(rows) * cols);
  for (int r = 0; r < rows; ++r) {
    double sum = 0;
    for (int c = 0; c < cols; ++c) {
      const double a = x[r * stride + c];
      sum += a * a;
    }
    const double scale = 1.0 / std::sqrt(sum / cols + eps);
    for (int c = 0; c < cols; ++c) {
      y[r * cols + c] = float(x[r * stride + c] * scale);
    }
  }
  return y;
}
inline float compare(const std::vector<float>& y, const std::vector<float>& ref) {
  require(y.size() == ref.size(), "output shape");
  float worst = 0;
  for (size_t i = 0; i < y.size(); ++i) {
    require(std::isfinite(y[i]), "nonfinite output");
    const float error = std::abs(y[i] - ref[i]);
    require(error <= 3e-5f + 3e-5f * std::abs(ref[i]), "oracle mismatch");
    worst = std::max(worst, error);
  }
  return worst;
}
// 仅检查索引与浮点归约拓扑；不能模拟真实warp同步或GPU性能。
inline std::vector<float> warp_model(
    const std::vector<float>& x, int rows, int cols, int stride, float eps) {
  validate(x, rows, cols, stride, eps);
  std::vector<float> y(static_cast<size_t>(rows) * cols);
  for (int r = 0; r < rows; ++r) {
    std::array<float, 32> sum{};
    for (int lane = 0; lane < 32; ++lane) {
      for (int c = lane; c < cols; c += 32) {
        const float a = x[r * stride + c];
        sum[lane] += a * a;
      }
    }
    for (int d = 16; d > 0; d /= 2) {
      auto before = sum;
      for (int lane = 0; lane < 32; ++lane) {
        sum[lane] += before[lane ^ d];
      }
    }
    const float scale = 1 / std::sqrt(sum[0] / cols + eps);
    for (int c = 0; c < cols; ++c) {
      y[r * cols + c] = x[r * stride + c] * scale;
    }
  }
  return y;
}
