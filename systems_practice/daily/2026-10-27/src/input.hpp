#pragma once
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>
namespace lesson {
struct Frame {
  int h{}, w{}, stride{};
  std::vector<uint8_t> bytes;
};
inline size_t bytes(int h, int stride) {
  if (h <= 0 || stride <= 0)
    throw std::invalid_argument("shape");
  auto n = uint64_t(h) * uint64_t(stride);
  if (n > std::numeric_limits<size_t>::max())
    throw std::overflow_error("size");
  return size_t(n);
}
inline Frame make(int h, int w, int pad) {
  if (w <= 0 || pad < 0)
    throw std::invalid_argument("shape");
  Frame f{h, w, w * 3 + pad, {}};
  f.bytes.resize(bytes(h, f.stride), 0xA5);
  for (int y = 0; y < h; y++)
    for (int x = 0; x < w * 3; x++)
      f.bytes[y * f.stride + x] = uint8_t((y * 31 + x * 7) & 255);
  return f;
}
inline void check(const Frame& f) {
  if (f.w <= 0 || f.h <= 0 || f.stride < f.w * 3 || f.bytes.size() < bytes(f.h, f.stride))
    throw std::invalid_argument("stride");
}
inline std::vector<float> baseline(const Frame& f) {
  check(f);
  std::vector<uint8_t> packed(size_t(f.h * f.w * 3));
  for (int y = 0; y < f.h; y++)
    for (int x = 0; x < f.w * 3; x++)
      packed[y * f.w * 3 + x] = f.bytes[y * f.stride + x];
  std::vector<float> o(packed.size());
  for (size_t i = 0; i < o.size(); i++)
    o[i] = (float(packed[i]) - 127.5f) / 127.5f;
  return o;
}
inline std::vector<float> fused(const Frame& f) {
  check(f);
  std::vector<float> o(size_t(f.h * f.w * 3));
  for (int y = 0; y < f.h; y++)
    for (int x = 0; x < f.w * 3; x++)
      o[y * f.w * 3 + x] = (float(f.bytes[y * f.stride + x]) - 127.5f) / 127.5f;
  return o;
}
}  // namespace lesson
