#pragma once
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <vector>

namespace lesson {
using Vec = std::vector<double>;
using Matrix = std::vector<Vec>;
using Bytes = std::vector<uint8_t>;
inline void require(bool ok, const std::string& message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
// 显式 little-endian，避免宿主端序和结构体 padding 进入磁盘格式。
inline void put(Bytes& b, uint64_t value, size_t count) {
  for (size_t i = 0; i < count; ++i) {
    b.push_back(uint8_t(value >> (8 * i)));
  }
}
inline uint64_t get(const Bytes& b, size_t& pos, size_t count) {
  require(pos <= b.size() && count <= b.size() - pos && count <= 8, "truncated binary record");
  uint64_t value = 0;
  for (size_t i = 0; i < count; ++i) {
    value |= uint64_t(b[pos++]) << (8 * i);
  }
  return value;
}
template <class T>
void put_float(Bytes& b, T value) {
  static_assert(std::numeric_limits<T>::is_iec559 && (sizeof(T) == 4 || sizeof(T) == 8));
  uint64_t bits = 0;
  if constexpr (sizeof(T) == 4) {
    uint32_t v;
    std::memcpy(&v, &value, 4);
    bits = v;
  } else {
    std::memcpy(&bits, &value, 8);
  }
  put(b, bits, sizeof(T));
}
template <class T>
T get_float(const Bytes& b, size_t& pos) {
  const auto bits = get(b, pos, sizeof(T));
  T value;
  if constexpr (sizeof(T) == 4) {
    const uint32_t v = uint32_t(bits);
    std::memcpy(&value, &v, 4);
  } else {
    std::memcpy(&value, &bits, 8);
  }
  return value;
}
inline Bytes pack_u4(const std::vector<int>& codes) {
  Bytes out((codes.size() + 1) / 2, 0);
  for (size_t i = 0; i < codes.size(); ++i) {
    require(codes[i] >= 0 && codes[i] <= 15, "u4 code out of range");
    out[i / 2] |= uint8_t(codes[i] << (4 * (i % 2)));
  }
  return out;
}
inline std::vector<int> unpack_u4(const Bytes& b, size_t count) {
  require(b.size() == count / 2 + count % 2, "u4 size mismatch");
  require(count % 2 == 0 || (b.back() >> 4) == 0, "nonzero tail nibble");
  std::vector<int> out(count);
  for (size_t i = 0; i < count; ++i) {
    out[i] = (b[i / 2] >> (4 * (i % 2))) & 15;
  }
  return out;
}
// IEEE binary16，round-to-nearest-ties-to-even；独立存储参考，不代表 FP16 指令性能。
inline uint16_t half_bits(double x) {
  require(std::isfinite(x) && std::abs(x) <= 65504, "FP16 input outside finite range");
  const uint16_t sign = std::signbit(x) ? 0x8000 : 0;
  x = std::abs(x);
  if (x < std::ldexp(1.0, -14)) {
    return sign | uint16_t(std::nearbyint(std::ldexp(x, 24)));
  }
  int exponent;
  std::frexp(x, &exponent);
  int e = exponent - 1;
  int significand = int(std::nearbyint(std::ldexp(x, 10 - e)));
  if (significand == 2048) {
    significand = 1024;
    ++e;
  }
  return sign | uint16_t((e + 15) << 10) | uint16_t(significand - 1024);
}
inline double from_half(uint16_t h) {
  const int e = (h >> 10) & 31;
  require(e != 31, "nonfinite FP16 record");
  const int f = h & 1023;
  const double v = e == 0 ? std::ldexp(double(f), -24) : std::ldexp(double(1024 + f), e - 25);
  return (h & 0x8000) ? -v : v;
}
struct Random {
  std::mt19937 engine;
  explicit Random(unsigned seed) : engine(seed) {
  }
  double uniform() {
    return (double(engine()) + 0.5) / 4294967296.0;
  }
  double normal() {
    return std::sqrt(-2 * std::log(uniform())) * std::cos(6.283185307179586 * uniform());
  }
};
inline double dot(const Vec& a, const Vec& b) {
  require(a.size() == b.size(), "dot shape mismatch");
  return std::inner_product(a.begin(), a.end(), b.begin(), 0.0);
}
inline Vec matvec(const Matrix& w, const Vec& x) {
  Vec y;
  for (const auto& row : w) {
    y.push_back(dot(row, x));
  }
  return y;
}
template <class T>
void json_array(const std::vector<T>& values) {
  std::cout << '[';
  for (size_t i = 0; i < values.size(); ++i) {
    if (i) {
      std::cout << ',';
    }
    std::cout << values[i];
  }
  std::cout << ']';
}
inline void save(const std::string& path, const Bytes& b) {
  std::ofstream f(path, std::ios::binary);
  require(bool(f), "cannot open output");
  f.write(reinterpret_cast<const char*>(b.data()), std::streamsize(b.size()));
  f.close();
  require(bool(f), "binary write failed");
}
inline Bytes load(const std::string& path) {
  std::ifstream f(path, std::ios::binary);
  require(bool(f), "cannot open binary input");
  Bytes b((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
  require(!f.bad(), "binary read failed");
  return b;
}
}  // namespace lesson
