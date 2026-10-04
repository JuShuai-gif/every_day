#pragma once
#include <array>
#include <cmath>
#include <cstdint>
#include <stdexcept>
#include <vector>
struct Data {
  int t, d;
  std::vector<std::uint32_t> code;
  std::vector<float> scale, mn, q, raw;
  Data(int tokens, int dims) : t(tokens), d(dims) {
    if (t < 0 || t > 4096 || d <= 0 || d > 1024) {
      throw std::invalid_argument("shape");
    }
    code.resize(((t + 15) / 16) * d);
    scale.resize(((t + 31) / 32) * d);
    mn.resize(scale.size());
    q.resize(d);
    raw.resize(t * d);
    for (int j = 0; j < d; ++j) {
      q[j] = std::cos(j * 0.17f);
    }
    for (int i = 0; i < t * d; ++i) {
      raw[i] = std::sin(i * 0.23f);
    }
    for (int g = 0; g < (t + 31) / 32; ++g) {
      for (int j = 0; j < d; ++j) {
        float low = raw[g * 32 * d + j], high = low;
        for (int x = g * 32; x < t && x < (g + 1) * 32; ++x) {
          low = std::fmin(low, raw[x * d + j]);
          high = std::fmax(high, raw[x * d + j]);
        }
        mn[g * d + j] = low;
        scale[g * d + j] = (high - low) / 3;
        for (int x = g * 32; x < t && x < (g + 1) * 32; ++x) {
          unsigned v =
              high == low
                  ? 0U
                  : static_cast<unsigned>(std::round((raw[x * d + j] - low) / scale[g * d + j]));
          code[(x / 16) * d + j] |= v << (2 * (x % 16));
        }
      }
    }
  }
  float decode(int x, int j) const {
    return static_cast<float>((code[(x / 16) * d + j] >> (2 * (x % 16))) & 3U) *
               scale[(x / 32) * d + j] +
           mn[(x / 32) * d + j];
  }
  double reference(int x) const {
    double s = 0;
    for (int j = 0; j < d; ++j) {
      s += static_cast<double>(q[j]) * decode(x, j);
    }
    return s;
  }
  float warp_model(int x) const {
    std::array<float, 32> lanes{};
    for (int lane = 0; lane < 32; ++lane) {
      for (int j = lane; j < d; j += 32) {
        lanes[lane] += q[j] * decode(x, j);
      }
    }
    for (int delta = 16; delta; delta /= 2) {
      auto old = lanes;
      for (int lane = 0; lane + delta < 32; ++lane) {
        lanes[lane] += old[lane + delta];
      }
    }
    return lanes[0];
  }
};
