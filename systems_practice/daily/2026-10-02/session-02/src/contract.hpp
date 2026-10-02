#pragma once
#include <algorithm>
#include <cstddef>
#include <stdexcept>
#include <vector>
struct Shape {
  int h, w, ldi, ldo;
};
inline void validate(Shape s) {
  if (s.h <= 0 || s.w <= 0 || s.h > 8192 || s.w > 8192 || s.ldi < s.w || s.ldo < s.h ||
      s.ldi > 16384 || s.ldo > 16384)
    throw std::invalid_argument("shape/stride outside bounded contract");
}
inline std::vector<float> input(Shape s) {
  validate(s);
  std::vector<float> a(std::size_t(s.h) * s.ldi, -777);
  for (int r = 0; r < s.h; ++r)
    for (int c = 0; c < s.w; ++c)
      a[std::size_t(r) * s.ldi + c] = float((r * 17 + c * 3) % 251 - 125);
  return a;
}
inline std::vector<float> oracle(const std::vector<float>& a, Shape s) {
  validate(s);
  if (a.size() != std::size_t(s.h) * s.ldi)
    throw std::invalid_argument("input size");
  std::vector<float> b(std::size_t(s.w) * s.ldo, -999);
  for (int r = 0; r < s.h; ++r)
    for (int c = 0; c < s.w; ++c)
      b[std::size_t(c) * s.ldo + r] = a[std::size_t(r) * s.ldi + c];
  return b;
}
inline void check(bool b, const char* m) {
  if (!b)
    throw std::runtime_error(m);
}
