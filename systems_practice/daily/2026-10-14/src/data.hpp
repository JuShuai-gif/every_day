#pragma once
#include <cmath>
#include <cstdint>
#include <fstream>
#include <stdexcept>
#include <string>
#include <vector>
struct Data {
  std::uint32_t h[8]{};
  std::vector<std::uint8_t> a, w;
  std::vector<float> sa, sw, oracle;
  int m() const {
    return static_cast<int>(h[1]);
  }
  int n() const {
    return static_cast<int>(h[2]);
  }
  int k() const {
    return static_cast<int>(h[3]);
  }
  int wb() const {
    return static_cast<int>(h[4]);
  }
  int ab() const {
    return static_cast<int>(h[5]);
  }
  int groups() const {
    return static_cast<int>(h[7]);
  }
};
inline Data read_data(const std::string& path) {
  std::ifstream f(path, std::ios::binary);
  if (!f) {
    throw std::runtime_error("open fixture");
  }
  Data d;
  f.read(reinterpret_cast<char*>(d.h), sizeof(d.h));
  if (!f || d.h[0] != 0x51474D31 || d.h[6] != 16 || d.m() < 1 || d.n() < 1 || d.k() < 1 ||
      d.m() > 4096 || d.n() > 4096 || d.k() > 4096 || (d.wb() != 4 && d.wb() != 8) ||
      (d.ab() != 4 && d.ab() != 8 && d.ab() != 16) || d.h[7] != (d.h[3] + 15) / 16) {
    throw std::runtime_error("invalid fixture header");
  }
  d.a.resize((std::size_t(d.m()) * d.k() * d.ab() + 7) / 8);
  d.w.resize((std::size_t(d.n()) * d.k() * d.wb() + 7) / 8);
  if (d.ab() != 16) {
    d.sa.resize(d.m() * d.groups());
  }
  d.sw.resize(d.n() * d.groups());
  d.oracle.resize(d.m() * d.n());
  auto read = [&](auto& v) {
    if (!v.empty()) {
      f.read(reinterpret_cast<char*>(v.data()), std::streamsize(v.size() * sizeof(v[0])));
      if (!f) {
        throw std::runtime_error("truncated fixture");
      }
    }
  };
  read(d.a);
  read(d.w);
  read(d.sa);
  read(d.sw);
  read(d.oracle);
  char extra;
  if (f.read(&extra, 1)) {
    throw std::runtime_error("trailing fixture bytes");
  }
  return d;
}
inline int code(const std::vector<std::uint8_t>& v, int i, int bits) {
  int u = bits == 4 ? ((v[std::size_t(i) / 2] >> ((i % 2) * 4)) & 15) : v[i];
  return u >= (1 << (bits - 1)) ? u - (1 << bits) : u;
}
inline float half_at(const std::vector<std::uint8_t>& v, int i) {
  unsigned u = unsigned(v[2 * i]) | (unsigned(v[2 * i + 1]) << 8);
  int e = (u >> 10) & 31;
  unsigned mant = u & 1023;
  if (e == 31) {
    throw std::runtime_error("nonfinite FP16 input");
  }
  float x = e == 0 ? std::ldexp(float(mant), -24) : std::ldexp(float(mant + 1024), e - 25);
  return (u & 32768) ? -x : x;
}
inline std::vector<float> reference(const Data& d) {
  std::vector<float> out(d.m() * d.n(), 0);
  for (int m = 0; m < d.m(); ++m) {
    for (int n = 0; n < d.n(); ++n) {
      for (int g = 0; g < d.groups(); ++g) {
        std::int32_t ii = 0;
        float ff = 0;
        for (int k = g * 16; k < d.k() && k < (g + 1) * 16; ++k) {
          int w = code(d.w, n * d.k() + k, d.wb());
          if (d.ab() == 16) {
            ff += half_at(d.a, m * d.k() + k) * float(w);
          } else {
            ii += code(d.a, m * d.k() + k, d.ab()) * w;
          }
        }
        out[m * d.n() + n] +=
            (d.ab() == 16 ? ff : float(ii) * d.sa[m * d.groups() + g]) * d.sw[n * d.groups() + g];
      }
    }
  }
  return out;
}
inline void compare(const std::vector<float>& got, const std::vector<float>& expected) {
  if (got.size() != expected.size()) {
    throw std::runtime_error("size mismatch");
  }
  for (std::size_t i = 0; i < got.size(); ++i) {
    if (!std::isfinite(got[i]) ||
        std::abs(got[i] - expected[i]) > 3e-4f * (1 + std::abs(expected[i]))) {
      throw std::runtime_error("numeric mismatch at " + std::to_string(i));
    }
  }
}
