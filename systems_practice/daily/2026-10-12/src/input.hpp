#pragma once
#include <array>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <stdexcept>
#include <vector>

namespace lesson {
inline std::size_t mul(std::size_t a, std::size_t b) {
  if (b && a > std::numeric_limits<std::size_t>::max() / b) {
    throw std::overflow_error("size multiplication");
  }
  return a * b;
}
struct Frame {
  std::size_t h, w, stride;
  std::vector<std::uint8_t> bytes;
  void validate() const {
    if (!h || !w || stride < mul(w, 3)) {
      throw std::invalid_argument("empty frame or short stride");
    }
    const auto prefix = mul(h - 1, stride);
    const auto row = mul(w, 3);
    if (prefix > std::numeric_limits<std::size_t>::max() - row || bytes.size() < prefix + row) {
      throw std::invalid_argument("truncated frame");
    }
  }
};
inline Frame make_frame(std::size_t h, std::size_t w, std::size_t padding) {
  const auto row = mul(w, 3);
  if (padding > std::numeric_limits<std::size_t>::max() - row) {
    throw std::overflow_error("padding overflow");
  }
  Frame f{h, w, row + padding, {}};
  f.bytes.assign(mul(h, f.stride), 0xED);
  for (std::size_t y = 0; y < h; ++y) {
    for (std::size_t x = 0; x < w; ++x) {
      for (std::size_t c = 0; c < 3; ++c) {
        f.bytes[y * f.stride + x * 3 + c] =
            static_cast<std::uint8_t>((y * 17 + x * 11 + c * 53) % 256);
      }
    }
  }
  return f;
}
inline std::vector<float> baseline(const Frame& f) {
  f.validate();
  std::vector<std::uint8_t> packed(mul(mul(f.h, f.w), 3));
  for (std::size_t y = 0; y < f.h; ++y) {
    for (std::size_t i = 0; i < f.w * 3; ++i) {
      packed[y * f.w * 3 + i] = f.bytes[y * f.stride + i];
    }
  }
  std::vector<float> out(packed.size());
  for (std::size_t i = 0; i < packed.size(); ++i) {
    out[i] = (static_cast<float>(packed[i]) - 127.5F) / 127.5F;
  }
  return out;
}
inline std::vector<float> fused(const Frame& f) {
  f.validate();
  std::vector<float> out(mul(mul(f.h, f.w), 3));
  // 相机stride只用于读源；RKNN输入是紧凑NHWC，归一化只在这里执行一次。
  for (std::size_t y = 0; y < f.h; ++y) {
    for (std::size_t x = 0; x < f.w; ++x) {
      for (std::size_t c = 0; c < 3; ++c) {
        out[(y * f.w + x) * 3 + c] =
            (static_cast<float>(f.bytes[y * f.stride + x * 3 + c]) - 127.5F) / 127.5F;
      }
    }
  }
  return out;
}
inline std::vector<float> oracle(const Frame& f) {
  f.validate();
  // 独立生成公式，不读取pack结果；输出固定NCHW的两通道1x1卷积。
  std::vector<float> y(mul(mul(f.h, f.w), 2));
  const std::array<std::array<float, 3>, 2> weight{{{0.25F, -0.5F, 0.75F}, {-0.25F, 0.5F, 0.25F}}};
  for (std::size_t o = 0; o < 2; ++o) {
    for (std::size_t r = 0; r < f.h; ++r) {
      for (std::size_t x = 0; x < f.w; ++x) {
        float v = o ? -0.125F : 0.125F;
        for (std::size_t c = 0; c < 3; ++c) {
          const float raw = static_cast<float>((r * 17 + x * 11 + c * 53) % 256);
          v += ((raw - 127.5F) / 127.5F) * weight[o][c];
        }
        y[o * f.h * f.w + r * f.w + x] = v;
      }
    }
  }
  return y;
}
}  // namespace lesson
