#pragma once

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <vector>

#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
#include <arm_neon.h>
#endif

namespace normalize {

struct Frame {
  std::size_t width;
  std::size_t height;
  std::size_t stride;
  std::vector<std::uint8_t> pixels;
};

struct Parameters {
  std::array<float, 3> mean{0.485f, 0.456f, 0.406f};
  std::array<float, 3> stddev{0.229f, 0.224f, 0.225f};
};

enum class Mode { Multipass, Fused, Vectorized };

inline void validate(const Frame& frame, const Parameters& parameters) {
  // 显式资源边界也使随后的乘法不会溢出；实际相机格式要先协商再修改上限。
  if (frame.width == 0 || frame.height == 0 || frame.width > 4096 || frame.height > 2160 ||
      frame.stride < frame.width * 3 || frame.stride > frame.width * 3 + 4096 ||
      frame.pixels.size() != frame.stride * frame.height) {
    throw std::invalid_argument("invalid image dimensions, row stride, or backing storage");
  }
  for (std::size_t channel = 0; channel < 3; ++channel) {
    if (!std::isfinite(parameters.mean[channel]) || !std::isfinite(parameters.stddev[channel]) ||
        parameters.stddev[channel] < 1e-6f) {
      throw std::invalid_argument("normalization mean/stddev must be finite; stddev >= 1e-6");
    }
    // 参数自身有限还不够：极大的 mean 除以极小 stddev 仍会让 FP32 输出溢出。
    // 映射在输入 [0, 1] 上是线性的，检查两个端点即可覆盖全部 uint8 输入。
    const double low = -static_cast<double>(parameters.mean[channel]) /
                       static_cast<double>(parameters.stddev[channel]);
    const double high = (1.0 - static_cast<double>(parameters.mean[channel])) /
                        static_cast<double>(parameters.stddev[channel]);
    const double safe_limit = static_cast<double>(std::numeric_limits<float>::max()) *
                              (1.0 - 4.0 * std::numeric_limits<float>::epsilon());
    if (std::abs(low) > safe_limit || std::abs(high) > safe_limit) {
      throw std::invalid_argument("normalization endpoints exceed finite FP32 range");
    }
  }
}

inline Frame make_frame(std::size_t width, std::size_t height, std::size_t padding) {
  if (width == 0 || width > 4096 || height == 0 || height > 2160 || padding > 4096) {
    throw std::invalid_argument("invalid generated frame shape");
  }
  Frame frame{width, height, width * 3 + padding, {}};
  frame.pixels.assign(frame.stride * height, 0xed);
  for (std::size_t y = 0; y < height; ++y) {
    for (std::size_t x = 0; x < width; ++x) {
      for (std::size_t c = 0; c < 3; ++c) {
        frame.pixels[y * frame.stride + x * 3 + c] =
            static_cast<std::uint8_t>((x * 17 + y * 31 + c * 67) % 256);
      }
    }
  }
  return frame;
}

inline void multipass(const Frame& frame, const Parameters& p, std::vector<float>& out) {
  const auto plane = frame.width * frame.height;
  // 基线模拟独立的格式转换、归一化、布局转换算子；中间张量分配包含在计时中。
  std::vector<float> interleaved(plane * 3);
  for (std::size_t y = 0; y < frame.height; ++y) {
    for (std::size_t x = 0; x < frame.width * 3; ++x) {
      interleaved[y * frame.width * 3 + x] = frame.pixels[y * frame.stride + x] / 255.0f;
    }
  }
  for (std::size_t i = 0; i < plane; ++i) {
    for (std::size_t c = 0; c < 3; ++c) {
      interleaved[i * 3 + c] = (interleaved[i * 3 + c] - p.mean[c]) / p.stddev[c];
    }
  }
  for (std::size_t c = 0; c < 3; ++c) {
    for (std::size_t i = 0; i < plane; ++i) {
      out[c * plane + i] = interleaved[i * 3 + c];
    }
  }
}

#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
inline void store_eight(uint8x8_t bytes, float mean, float inv_stddev, float* out) {
  const auto wide = vmovl_u8(bytes);
  const auto lo = vcvtq_f32_u32(vmovl_u16(vget_low_u16(wide)));
  const auto hi = vcvtq_f32_u32(vmovl_u16(vget_high_u16(wide)));
  const auto mean_v = vdupq_n_f32(mean);
  const auto normalized_lo =
      vmulq_n_f32(vsubq_f32(vmulq_n_f32(lo, 1.0f / 255.0f), mean_v), inv_stddev);
  const auto normalized_hi =
      vmulq_n_f32(vsubq_f32(vmulq_n_f32(hi, 1.0f / 255.0f), mean_v), inv_stddev);
  vst1q_f32(out, normalized_lo);
  vst1q_f32(out + 4, normalized_hi);
}
#endif

inline void fused(const Frame& frame, const Parameters& p, bool use_neon, std::vector<float>& out) {
  const auto plane = frame.width * frame.height;
  const std::array<float, 3> inv{1.0f / p.stddev[0], 1.0f / p.stddev[1], 1.0f / p.stddev[2]};
  for (std::size_t y = 0; y < frame.height; ++y) {
    const auto* row = frame.pixels.data() + y * frame.stride;
    std::size_t x = 0;
#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
    if (use_neon) {
      // 每次读 8 个 RGB 像素，正好 24 字节。尾部不足 8 像素必须走标量路径。
      for (; x + 8 <= frame.width; x += 8) {
        const auto rgb = vld3_u8(row + x * 3);
        for (std::size_t c = 0; c < 3; ++c) {
          store_eight(rgb.val[c], p.mean[c], inv[c], out.data() + c * plane + y * frame.width + x);
        }
      }
    }
#else
    (void)use_neon;
#endif
    for (; x < frame.width; ++x) {
      for (std::size_t c = 0; c < 3; ++c) {
        out[c * plane + y * frame.width + x] =
            (static_cast<float>(row[x * 3 + c]) * (1.0f / 255.0f) - p.mean[c]) * inv[c];
      }
    }
  }
}

inline void run(const Frame& frame,
                const Parameters& parameters,
                Mode mode,
                std::vector<float>& output) {
  validate(frame, parameters);
  if (output.size() != frame.width * frame.height * 3) {
    throw std::invalid_argument("output tensor shape mismatch");
  }
  if (mode == Mode::Multipass) {
    multipass(frame, parameters, output);
  } else {
    fused(frame, parameters, mode == Mode::Vectorized, output);
  }
}

inline std::uint64_t token(const std::vector<float>& output) {
  std::uint32_t first = 0;
  std::uint32_t last = 0;
  std::memcpy(&first, &output.front(), sizeof(first));
  std::memcpy(&last, &output.back(), sizeof(last));
  return (static_cast<std::uint64_t>(first) << 32) | last;
}

inline const char* backend() {
#if defined(__ARM_NEON) && !defined(EDGE_DISABLE_NEON)
  return "NEON_8_RGB_pixels";
#else
  return "scalar_fallback";
#endif
}

}  // namespace normalize
