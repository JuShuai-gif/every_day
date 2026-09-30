#pragma once
#include <cmath>
#include <stdexcept>
#include <string>
#include <vector>

struct Shape {
  int m, n, k;
  void validate() const {
    // 限制教学规模，同时确保设备索引乘法不会溢出。
    if (m < 1 || n < 1 || k < 1 || m > 512 || n > 512 || k > 2048) {
      throw std::invalid_argument("shape outside M,N=1..512 K=1..2048");
    }
  }
};
inline std::vector<float> input(int size, int salt) {
  std::vector<float> v(size);
  for (int i = 0; i < size; ++i) {
    v[i] = static_cast<float>((i * 17 + salt) % 31 - 15) / 16.0f;
  }
  return v;
}
inline std::vector<float> oracle(const std::vector<float>& a,
                                 const std::vector<float>& b,
                                 Shape s) {
  s.validate();
  std::vector<float> c(s.m * s.n);
  for (int i = 0; i < s.m; ++i) {
    for (int j = 0; j < s.n; ++j) {
      double sum = 0;
      for (int k = 0; k < s.k; ++k) {
        sum += static_cast<double>(a.at(i * s.k + k)) * b.at(k * s.n + j);
      }
      c[i * s.n + j] = static_cast<float>(sum);
    }
  }
  return c;
}
inline void check(const std::vector<float>& got, const std::vector<float>& expected) {
  if (got.size() != expected.size()) {
    throw std::runtime_error("output size mismatch");
  }
  for (std::size_t i = 0; i < got.size(); ++i) {
    if (!std::isfinite(got[i]) ||
        std::abs(got[i] - expected[i]) > 1e-4f + 1e-4f * std::abs(expected[i])) {
      throw std::runtime_error("GEMM mismatch at " + std::to_string(i));
    }
  }
}
