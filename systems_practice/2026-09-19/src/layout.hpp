#pragma once
#include <algorithm>
#include <cmath>
#include <cstddef>
#include <stdexcept>
#include <string>
#include <vector>

namespace practice {
constexpr int tile_size = 32;
constexpr float sentinel = -1234567.0f;
struct Shape {
  int batches, rows, cols, input_stride, output_stride;
  void validate() const {
    // 限制教学输入规模，同时避免下标、grid与分配大小溢出。
    if (batches < 1 || batches > 4 || rows < 1 || rows > 4096 || cols < 1 || cols > 4096 ||
        input_stride < cols || input_stride > 8192 || output_stride < rows ||
        output_stride > 8192) {
      throw std::invalid_argument("invalid Shape/stride");
    }
  }
  std::size_t input_count() const {
    return std::size_t(batches) * rows * input_stride;
  }
  std::size_t output_count() const {
    return std::size_t(batches) * cols * output_stride;
  }
};
inline std::vector<float> input(const Shape& s) {
  s.validate();
  std::vector<float> a(s.input_count(), sentinel);
  for (int b = 0; b < s.batches; ++b) {
    for (int r = 0; r < s.rows; ++r) {
      for (int c = 0; c < s.cols; ++c) {
        // 可精确表示、随坐标变化；不能用全零输入掩盖转置错误。
        a[(std::size_t(b) * s.rows + r) * s.input_stride + c] =
            float((b * 131 + r * 37 + c * 17) % 1009 - 504) / 16;
      }
    }
  }
  return a;
}
inline std::vector<float> oracle(const Shape& s, const std::vector<float>& a) {
  s.validate();
  if (a.size() != s.input_count()) {
    throw std::invalid_argument("input size");
  }
  std::vector<float> out(s.output_count(), sentinel);
  for (int b = 0; b < s.batches; ++b) {
    for (int c = 0; c < s.cols; ++c) {
      for (int r = 0; r < s.rows; ++r) {
        out[(std::size_t(b) * s.cols + c) * s.output_stride + r] =
            a[(std::size_t(b) * s.rows + r) * s.input_stride + c];
      }
    }
  }
  return out;
}
inline void check(const std::vector<float>& got, const std::vector<float>& expected) {
  if (got.size() != expected.size()) {
    throw std::runtime_error("output size");
  }
  for (std::size_t i = 0; i < got.size(); ++i) {
    if (!std::isfinite(got[i]) || got[i] != expected[i]) {
      throw std::runtime_error("value/padding mismatch at " + std::to_string(i));
    }
  }
}
inline std::vector<Shape> cases() {
  std::vector<Shape> shapes;
  for (int b : {1, 2}) {
    for (int r : {1, 7, 31, 32, 33, 65, 197}) {
      for (int c : {1, 8, 31, 32, 33, 67, 128}) {
        for (int pad : {0, 3}) {
          shapes.push_back({b, r, c, c + pad, r + pad});
        }
      }
    }
  }
  return shapes;
}
}  // namespace practice
