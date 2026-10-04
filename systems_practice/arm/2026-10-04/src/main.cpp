#include <arm_neon.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
struct Image {
  std::size_t w, h, stride;
  void validate() const {
    if (w > 100000 || h > 100000 || stride < 3 * w || stride > 1000000) {
      throw std::invalid_argument("invalid shape/stride");
    }
  }
};
using U8 = std::uint8_t;
__attribute__((noinline)) void scalar(const U8* rgb, U8* y, Image s) {
  for (std::size_t row = 0; row < s.h; ++row) {
    for (std::size_t x = 0; x < s.w; ++x) {
      const auto* p = rgb + row * s.stride + 3 * x;
      y[row * s.w + x] = static_cast<U8>((p[0] + 2U * p[1] + p[2]) >> 2);
    }
  }
}
uint8x16_t weighted(uint8x16_t r, uint8x16_t g, uint8x16_t b) {
  // 扩宽后最大和1020不会溢出；右移是截断，不是四舍五入。
  auto lo = vaddq_u16(vaddl_u8(vget_low_u8(r), vget_low_u8(b)), vshll_n_u8(vget_low_u8(g), 1));
  auto hi = vaddq_u16(vaddl_u8(vget_high_u8(r), vget_high_u8(b)), vshll_n_u8(vget_high_u8(g), 1));
  return vcombine_u8(vshrn_n_u16(lo, 2), vshrn_n_u16(hi, 2));
}
__attribute__((noinline)) void direct(const U8* rgb, U8* y, Image s) {
  for (std::size_t row = 0; row < s.h; ++row) {
    const auto* p = rgb + row * s.stride;
    std::size_t x = 0;
    for (; x + 16 <= s.w; x += 16) {
      // LD3将连续48字节拆成R/G/B各16个lane，无临时平面。
      auto v = vld3q_u8(p + 3 * x);
      vst1q_u8(y + row * s.w + x, weighted(v.val[0], v.val[1], v.val[2]));
    }
    for (; x < s.w; ++x) {
      y[row * s.w + x] = static_cast<U8>((p[3 * x] + 2U * p[3 * x + 1] + p[3 * x + 2]) >> 2);
    }
  }
}
__attribute__((noinline)) void pack(const U8* rgb, U8* planar, Image s) {
  const auto n = s.w * s.h;
  for (std::size_t row = 0; row < s.h; ++row) {
    std::size_t x = 0;
    for (; x + 16 <= s.w; x += 16) {
      auto v = vld3q_u8(rgb + row * s.stride + 3 * x);
      for (int c = 0; c < 3; ++c) {
        vst1q_u8(planar + c * n + row * s.w + x, v.val[c]);
      }
    }
    for (; x < s.w; ++x) {
      for (int c = 0; c < 3; ++c) {
        planar[c * n + row * s.w + x] = rgb[row * s.stride + 3 * x + c];
      }
    }
  }
}
__attribute__((noinline)) void soa(const U8* p, U8* y, std::size_t n) {
  std::size_t x = 0;
  for (; x + 16 <= n; x += 16) {
    vst1q_u8(y + x, weighted(vld1q_u8(p + x), vld1q_u8(p + n + x), vld1q_u8(p + 2 * n + x)));
  }
  for (; x < n; ++x) {
    y[x] = static_cast<U8>((p[x] + 2U * p[n + x] + p[2 * n + x]) >> 2);
  }
}
volatile std::uint64_t sink = 0;
template <class F>
void bench(const char* label, F f, const std::vector<U8>& out) {
  for (int i = 0; i < 20; ++i) {
    f();
  }
  std::vector<double> samples;
  for (int sample = 0; sample < 31; ++sample) {
    auto start = std::chrono::steady_clock::now();
    for (int j = 0; j < 16; ++j) {
      f();
      sink += out[sample % out.size()];
    }
    samples.push_back(
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
            .count() /
        16);
  }
  std::sort(samples.begin(), samples.end());
  std::cout << label << " CPU batch_mean_us P50=" << samples[15] << " P95=" << samples[29] << '\n';
}
int main() {
  try {
    int cases = 0;
    for (std::size_t w = 0; w <= 65; ++w) {
      Image s{w, 3, 3 * w + 7};
      s.validate();
      std::vector<U8> input(s.h * s.stride + 1, 239), a(w * 3 + 1, 213), b = a, c = a,
                                                                         p(w * 9 + 1, 221);
      for (std::size_t r = 0; r < s.h; ++r) {
        for (std::size_t x = 0; x < w * 3; ++x) {
          input[1 + r * s.stride + x] = static_cast<U8>((x * 13 + r * 7) % 256);
        }
      }
      scalar(input.data() + 1, a.data(), s);
      direct(input.data() + 1, b.data(), s);
      pack(input.data() + 1, p.data(), s);
      soa(p.data(), c.data(), w * 3);
      if (a != b || a != c || p.back() != 221) {
        throw std::runtime_error("layout/tail failed");
      }
      ++cases;
    }
    bool invalid = false;
    try {
      Image{17, 2, 50}.validate();
    } catch (const std::invalid_argument&) {
      invalid = true;
    }
    if (!invalid) {
      throw std::runtime_error("stride accepted");
    }
    std::cout << "PASS " << cases
              << " shapes, offset1, odd stride, tails, guards, invalid stride\n";
    for (Image s : {Image{17, 1, 58}, Image{641, 480, 1930}}) {
      std::vector<U8> input(s.h * s.stride, 17), out(s.w * s.h), p(3 * s.w * s.h);
      for (std::size_t i = 0; i < input.size(); ++i) {
        input[i] = static_cast<U8>(i * 17);
      }
      pack(input.data(), p.data(), s);
      std::cout << "shape=" << s.w << 'x' << s.h << " stride=" << s.stride << '\n';
      bench(
          "scalar/autovec",
          [&] {
            scalar(input.data(), out.data(), s);
          },
          out);
      bench(
          "AoS LD3 direct",
          [&] {
            direct(input.data(), out.data(), s);
          },
          out);
      bench(
          "SoA reused",
          [&] {
            soa(p.data(), out.data(), out.size());
          },
          out);
      bench(
          "pack+SoA",
          [&] {
            pack(input.data(), p.data(), s);
            soa(p.data(), out.data(), out.size());
          },
          out);
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
