#pragma once

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

namespace practice {
constexpr int kRows = 8;
constexpr int kColumns = 128;

struct Shape {
  int batch;
  int tokens;
  int channels;

  void validate() const {
    // 限制教学规模，同时避免维度乘积溢出。
    if (batch < 1 || batch > 8 || tokens < 1 || tokens > 4096 || channels < 1 ||
        channels > kColumns) {
      throw std::invalid_argument("require B=1..8, T=1..4096, K=1..128");
    }
  }
  int stride() const {
    return (channels + 3) / 4 * 4;
  }
  int tiles() const {
    return (tokens + kRows - 1) / kRows;
  }
  std::size_t input_size() const {
    return std::size_t(batch) * tokens * stride();
  }
  std::size_t output_size() const {
    return std::size_t(batch) * tiles() * channels;
  }
};

// 独立的 CPU 判定函数；GPU 中有对应表达式，CPU 通过不代表 PTX 已通过。
inline int valid_bytes(bool row_valid, int column, int channels) {
  return row_valid ? std::min(4, std::max(0, channels - column)) * int(sizeof(float)) : 0;
}

inline std::vector<float> make_input(const Shape& s) {
  s.validate();
  // 行尾毒值可以暴露把物理 stride 当成逻辑通道数的问题。
  std::vector<float> input(s.input_size(), std::numeric_limits<float>::quiet_NaN());
  for (int b = 0; b < s.batch; ++b) {
    for (int t = 0; t < s.tokens; ++t) {
      for (int c = 0; c < s.channels; ++c) {
        input[(std::size_t(b) * s.tokens + t) * s.stride() + c] =
            float((b * 7 + t * 3 + c) % 31 - 15) / 16.0F;
      }
    }
  }
  return input;
}

inline std::vector<float> reference(const Shape& s, const std::vector<float>& input) {
  s.validate();
  if (input.size() != s.input_size()) {
    throw std::invalid_argument("input size mismatch");
  }
  std::vector<float> output(s.output_size());
  for (int b = 0; b < s.batch; ++b) {
    for (int tile = 0; tile < s.tiles(); ++tile) {
      const int count = std::min(kRows, s.tokens - tile * kRows);
      for (int c = 0; c < s.channels; ++c) {
        float sum = 0.0F;
        for (int row = 0; row < count; ++row) {
          sum += input[(std::size_t(b) * s.tokens + tile * kRows + row) * s.stride() + c];
        }
        output[(std::size_t(b) * s.tiles() + tile) * s.channels + c] = sum / count;
      }
    }
  }
  return output;
}

inline float check(const std::vector<float>& actual, const std::vector<float>& expected) {
  if (actual.size() != expected.size()) {
    throw std::runtime_error("output size mismatch");
  }
  float max_error = 0;
  for (std::size_t i = 0; i < actual.size(); ++i) {
    if (!std::isfinite(actual[i]) || std::abs(actual[i] - expected[i]) > 1e-6F) {
      throw std::runtime_error("numerical mismatch at " + std::to_string(i));
    }
    max_error = std::max(max_error, std::abs(actual[i] - expected[i]));
  }
  return max_error;
}
}  // namespace practice
