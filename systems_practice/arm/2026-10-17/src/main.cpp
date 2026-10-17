#include <arm_neon.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
struct Block {
  std::array<uint8_t, 16> q{};
  float scale = 1;
};
// 自定义FP32 scale块，nibble布局启发自ggml q4_0；不是GGUF兼容格式。
std::vector<Block> pack(const std::vector<int8_t>& q) {
  if (q.empty()) {
    throw std::invalid_argument("empty");
  }
  std::vector<Block> blocks((q.size() + 31) / 32);
  for (std::size_t b = 0; b < blocks.size(); ++b) {
    blocks[b].scale = 0.125f * static_cast<float>(1 + b % 3);
    for (int j = 0; j < 16; ++j) {
      int lo = b * 32 + j < q.size() ? q[b * 32 + j] : 0;
      int hi = b * 32 + j + 16 < q.size() ? q[b * 32 + j + 16] : 0;
      if (lo < -8 || lo > 7 || hi < -8 || hi > 7) {
        throw std::invalid_argument("int4 range");
      }
      blocks[b].q[j] = static_cast<uint8_t>((lo + 8) | ((hi + 8) << 4));
    }
  }
  return blocks;
}
void decode(const std::vector<Block>& b, std::vector<float>& dst) {
  for (std::size_t i = 0; i < dst.size(); ++i) {
    const auto& block = b[i / 32];
    const auto code = block.q[i % 16];
    const int q = (i % 32 < 16 ? code & 15 : code >> 4) - 8;
    dst[i] = q * block.scale;
  }
}
float separated(const std::vector<Block>& b,
                const std::vector<float>& x,
                std::vector<float>& scratch) {
  decode(b, scratch);
  float32x4_t acc = vdupq_n_f32(0);
  std::size_t i = 0;
  for (; i + 4 <= x.size(); i += 4) {
    acc = vfmaq_f32(acc, vld1q_f32(x.data() + i), vld1q_f32(scratch.data() + i));
  }
  float sum = vaddvq_f32(acc);
  for (; i < x.size(); ++i) {
    sum = std::fma(x[i], scratch[i], sum);
  }
  return sum;
}
// 16个字节生成低/高半块；不写回FP32权重，直接进入NEON乘加。
__attribute__((noinline)) float fused(const std::vector<Block>& b, const std::vector<float>& x) {
  float32x4_t acc = vdupq_n_f32(0);
  std::size_t i = 0;
  for (; i + 32 <= x.size(); i += 32) {
    const auto& block = b[i / 32];
    const auto raw = vld1q_u8(block.q.data());
    int8x16_t low = vsubq_s8(vreinterpretq_s8_u8(vandq_u8(raw, vdupq_n_u8(15))), vdupq_n_s8(8));
    int8x16_t high = vsubq_s8(vreinterpretq_s8_u8(vshrq_n_u8(raw, 4)), vdupq_n_s8(8));
    const int16x8_t halfs[] = {vmovl_s8(vget_low_s8(low)),
                               vmovl_s8(vget_high_s8(low)),
                               vmovl_s8(vget_low_s8(high)),
                               vmovl_s8(vget_high_s8(high))};
    for (int h = 0; h < 4; ++h) {
      const auto a = vmulq_n_f32(vcvtq_f32_s32(vmovl_s16(vget_low_s16(halfs[h]))), block.scale);
      const auto c = vmulq_n_f32(vcvtq_f32_s32(vmovl_s16(vget_high_s16(halfs[h]))), block.scale);
      acc = vfmaq_f32(acc, a, vld1q_f32(x.data() + i + 8 * h));
      acc = vfmaq_f32(acc, c, vld1q_f32(x.data() + i + 8 * h + 4));
    }
  }
  float sum = vaddvq_f32(acc);
  for (; i < x.size(); ++i) {
    const auto& block = b[i / 32];
    int raw = block.q[i % 16];
    int q = (i % 32 < 16 ? raw & 15 : raw >> 4) - 8;
    sum = std::fma(q * block.scale, x[i], sum);
  }
  return sum;
}
volatile float sink = 0;
template <class F>
double bench(F f) {
  for (int i = 0; i < 10; ++i) {
    asm volatile("" ::: "memory");  // 防止只读函数被移出重复测量循环。
    sink = f();
  }
  std::vector<double> t;
  for (int s = 0; s < 31; ++s) {
    auto start = std::chrono::steady_clock::now();
    for (int i = 0; i < 100; ++i) {
      asm volatile("" ::: "memory");  // 防止只读函数被移出重复测量循环。
      sink = f();
    }
    t.push_back(std::chrono::duration<double, std::micro>(std::chrono::steady_clock::now() - start)
                    .count() /
                100);
  }
  std::sort(t.begin(), t.end());
  return t[15];
}
int main() {
  try {
    int count = 0;
    for (int n : {1, 15, 16, 17, 31, 32, 33, 63, 64, 65, 4097, 65539}) {
      std::vector<int8_t> q(n);
      std::vector<float> x(n), scratch(n);
      for (int i = 0; i < n; ++i) {
        q[i] = static_cast<int8_t>(i % 16 - 8);
        x[i] = static_cast<float>((i * 7) % 23 - 11) / 16;
      }
      auto b = pack(q);
      double ref = 0;
      for (int i = 0; i < n; ++i) {
        ref += q[i] * b[i / 32].scale * static_cast<double>(x[i]);
      }
      for (float got : {separated(b, x, scratch), fused(b, x)}) {
        if (std::abs(got - ref) > 1e-4 + std::abs(ref) * 2e-5) {
          throw std::runtime_error("dot mismatch");
        }
      }
      ++count;
      if (n == 33 || n == 65539) {
        std::cout << "N=" << n << " payload_with_scale_bytes=" << b.size() * 20
                  << " object_bytes=" << b.size() * sizeof(Block) << " FP32_weight_bytes=" << n * 4
                  << " CPU_batch_mean_P50_us separated=" << bench([&] {
                       return separated(b, x, scratch);
                     })
                  << " fused=" << bench([&] {
                       return fused(b, x);
                     })
                  << '\n';
      }
    }
    int rejected = 0;
    try {
      pack({});
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    try {
      pack({8});
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    if (rejected != 2) {
      throw std::runtime_error("reject");
    }
    std::cout << "PASS lengths=" << count << " rejected=" << rejected << "\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
