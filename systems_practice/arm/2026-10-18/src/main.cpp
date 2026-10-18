#include <arm_neon.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

using Bytes = std::vector<std::uint8_t>;
using Floats = std::vector<float>;
const std::array<float, 3> mean{123.0f, 117.0f, 104.0f};
const std::array<float, 3> scale{1.0f / 58, 1.0f / 57, 1.0f / 59};
void check(bool ok) {
  if (!ok) {
    throw std::runtime_error("check failed");
  }
}
void validate(const Bytes& input, int w, int h, int stride) {
  if (w < 0 || h < 0 || w > 4096 || h > 4096 || stride < w * 3 || stride > 65536 ||
      input.size() != static_cast<std::size_t>(stride) * h) {
    throw std::invalid_argument("shape/stride/storage");
  }
}
// 独立标量oracle：不复用SIMD的通道/尾部索引。
Floats reference(const Bytes& in, int w, int h, int stride) {
  validate(in, w, h, stride);
  Floats out(static_cast<std::size_t>(w) * h * 3);
  for (int c = 0; c < 3; ++c) {
    for (int y = 0; y < h; ++y) {
      for (int x = 0; x < w; ++x) {
        out[c * w * h + y * w + x] = (float(in[y * stride + 3 * x + c]) - mean[c]) * scale[c];
      }
    }
  }
  return out;
}
// 两版共享LD3/扩宽转换，只改变归一化放在哪个遍历中。
template <bool Fused>
__attribute__((noinline)) void convert(const Bytes& in, int w, int h, int stride, Floats& out) {
  validate(in, w, h, stride);
  if (out.size() != static_cast<std::size_t>(w) * h * 3) {
    throw std::invalid_argument("output size");
  }
  const int plane = w * h;
  for (int y = 0; y < h; ++y) {
    int x = 0;
    for (; x + 8 <= w; x += 8) {
      const auto rgb = vld3_u8(in.data() + y * stride + 3 * x);
      for (int c = 0; c < 3; ++c) {
        const auto wide = vmovl_u8(rgb.val[c]);
        auto lo = vcvtq_f32_u32(vmovl_u16(vget_low_u16(wide)));
        auto hi = vcvtq_f32_u32(vmovl_u16(vget_high_u16(wide)));
        if constexpr (Fused) {
          lo = vmulq_n_f32(vsubq_f32(lo, vdupq_n_f32(mean[c])), scale[c]);
          hi = vmulq_n_f32(vsubq_f32(hi, vdupq_n_f32(mean[c])), scale[c]);
        }
        vst1q_f32(out.data() + c * plane + y * w + x, lo);
        vst1q_f32(out.data() + c * plane + y * w + x + 4, hi);
      }
    }
    // 行尾不能读取下一行padding；输出保持CHW而不是RGB交错。
    for (; x < w; ++x) {
      for (int c = 0; c < 3; ++c) {
        float v = in[y * stride + 3 * x + c];
        if constexpr (Fused) {
          v = (v - mean[c]) * scale[c];
        }
        out[c * plane + y * w + x] = v;
      }
    }
  }
  if constexpr (!Fused) {
    for (int c = 0; c < 3; ++c) {
      for (int i = 0; i < plane; ++i) {
        out[c * plane + i] = (out[c * plane + i] - mean[c]) * scale[c];
      }
    }
  }
}
template <class F>
double measure(F fn) {
  for (int i = 0; i < 5; ++i) {
    fn();
  }
  std::vector<double> samples;
  for (int b = 0; b < 31; ++b) {
    const auto begin = std::chrono::steady_clock::now();
    for (int i = 0; i < 5; ++i) {
      fn();
      asm volatile("" ::: "memory");
    }
    samples.push_back(
        std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - begin)
            .count() /
        5);
  }
  std::sort(samples.begin(), samples.end());
  return samples[15];
}
int main() {
  try {
    int cases = 0;
    for (int w : {0, 1, 7, 8, 9, 15, 16, 17, 641}) {
      for (int h : {0, 1, 3}) {
        for (int pad : {0, 5}) {
          const int stride = 3 * w + pad;
          Bytes in(static_cast<std::size_t>(stride) * h);
          for (std::size_t i = 0; i < in.size(); ++i) {
            in[i] = static_cast<std::uint8_t>(i * 71);
          }
          const auto expected = reference(in, w, h, stride);
          Floats a(expected.size()), b(expected.size());
          convert<false>(in, w, h, stride, a);
          convert<true>(in, w, h, stride, b);
          check(a == expected && b == expected);
          ++cases;
        }
      }
    }
    int rejected = 0;
    for (int stride : {2, 4}) {
      try {
        reference(Bytes(3), 1, 1, stride);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    check(rejected == 2);
    const auto lane = reference(Bytes{0, 10, 20, 30, 40, 50}, 2, 1, 6);
    std::cout << "lane CHW:";
    for (float v : lane) {
      std::cout << ' ' << v;
    }
    std::cout << "\nPASS shapes=" << cases << " rejects=2 bitwise_equal=true\n";
    for (int w : {9, 641}) {
      const int h = w == 9 ? 3 : 480, stride = w * 3 + 5;
      Bytes in(static_cast<std::size_t>(h) * stride, 97);
      Floats out(static_cast<std::size_t>(w) * h * 3);
      const double split = measure([&] {
        convert<false>(in, w, h, stride, out);
      });
      const double fused = measure([&] {
        convert<true>(in, w, h, stride, out);
      });
      const double split_alloc = measure([&] {
        Floats tmp(out.size());
        convert<false>(in, w, h, stride, tmp);
        asm volatile("" : : "r"(tmp.data()) : "memory");
      });
      const double fused_alloc = measure([&] {
        Floats tmp(out.size());
        convert<true>(in, w, h, stride, tmp);
        asm volatile("" : : "r"(tmp.data()) : "memory");
      });
      check(out == reference(in, w, h, stride));
      std::cout << "CPU batch_mean_p50_us width=" << w << " height=" << h << " split=" << split
                << " fused=" << fused << " alloc_split=" << split_alloc
                << " alloc_fused=" << fused_alloc << '\n';
    }
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
