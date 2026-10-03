#pragma once
#include <algorithm>
#include <array>
#include <cmath>
#include <stdexcept>
#include <vector>
struct Shape {
  int rows, cols, stride;
};
inline void require(bool ok, const char* why) {
  if (!ok) {
    throw std::runtime_error(why);
  }
}
inline void validate(Shape s) {
  require(s.rows > 0 && s.rows <= 4096 && s.cols > 0 && s.cols <= 16384 && s.stride >= s.cols &&
              s.stride <= 32768,
          "invalid shape");
}
inline std::vector<float> input(Shape s) {
  validate(s);
  std::vector<float> a(std::size_t(s.rows) * s.stride, 9000.0f);
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      a[std::size_t(r) * s.stride + c] = float((r * 17 + c * 13) % 101 - 50) / 32.0f;
    }
  }
  return a;
}
inline std::vector<double> oracle(const std::vector<float>& a, Shape s) {
  std::vector<double> out(s.rows);
  for (int r = 0; r < s.rows; ++r) {
    for (int c = 0; c < s.cols; ++c) {
      double v = a[std::size_t(r) * s.stride + c];
      out[r] += v * v;
    }
  }
  return out;
}
inline void compare(const std::vector<float>& out, const std::vector<double>& gold) {
  require(out.size() == gold.size(), "size mismatch");
  for (std::size_t i = 0; i < out.size(); ++i) {
    require(std::isfinite(out[i]) && std::abs(out[i] - gold[i]) <= 2e-5 * std::max(1.0, gold[i]),
            "energy mismatch");
  }
}
// 宿主只模拟索引及加法树，不能验证warp屏障或设备性能。
inline std::vector<float> model(const std::vector<float>& a, Shape s, int width) {
  std::vector<float> out(s.rows);
  for (int r = 0; r < s.rows; ++r) {
    std::vector<float> v(width, 0);
    std::vector<int> visits(s.cols, 0);
    for (int lane = 0; lane < width; ++lane) {
      for (int c = lane; c < s.cols; c += width) {
        float x = a[std::size_t(r) * s.stride + c];
        v[lane] = std::fma(x, x, v[lane]);
        ++visits[c];
      }
    }
    for (int step = width / 2; step; step /= 2) {
      for (int lane = 0; lane < step; ++lane) {
        v[lane] += v[lane + step];
      }
    }
    for (int count : visits) {
      require(count == 1, "coverage mismatch");
    }
    out[r] = v[0];
  }
  return out;
}
