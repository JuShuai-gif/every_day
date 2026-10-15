#pragma once
#include <cstddef>
#include <stdexcept>
#include <vector>
struct Shape {
  int rows, cols, in_stride, out_stride;
  void check() const {
    // 限制规模也避免网格和地址乘法溢出；零尺寸按空操作处理。
    if (rows < 0 || cols < 0 || rows > 16384 || cols > 16384 || in_stride < cols ||
        out_stride < rows || in_stride > 32768 || out_stride > 32768) {
      throw std::invalid_argument("invalid shape/stride");
    }
  }
  std::size_t input_size() const {
    return std::size_t(rows) * in_stride;
  }
  std::size_t output_size() const {
    return std::size_t(cols) * out_stride;
  }
};
inline std::vector<float> reference(const std::vector<float>& a, Shape s) {
  s.check();
  if (a.size() != s.input_size()) {
    throw std::invalid_argument("input extent");
  }
  std::vector<float> b(s.output_size(), -999.0f);
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      b[std::size_t(c) * s.out_stride + r] = a[std::size_t(r) * s.in_stride + c];
    }
  }
  return b;
}
inline std::vector<float> input(Shape s) {
  s.check();
  std::vector<float> a(s.input_size(), -123.0f);
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      a[std::size_t(r) * s.in_stride + c] = float((r * 131 + c * 17) % 1009) - 504.0f;
    }
  }
  return a;
}
