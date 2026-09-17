#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

struct NhwcShape {
  int n, h, w, c, w_stride;
};

// 将紧凑 RGB 行复制到 Runtime 所要求的行跨度；padding 先清零，避免未初始化字节进入 NPU。
std::vector<uint8_t> pack_to_rknn_stride(const std::vector<uint8_t>& tight, const NhwcShape& s) {
  if (s.n <= 0 || s.h <= 0 || s.w <= 0 || s.c != 3 || s.w_stride < s.w)
    throw std::invalid_argument("invalid NHWC/stride");
  const size_t tight_bytes = static_cast<size_t>(s.n) * s.h * s.w * s.c;
  if (tight.size() != tight_bytes)
    throw std::invalid_argument("tight input size mismatch");
  std::vector<uint8_t> padded(static_cast<size_t>(s.n) * s.h * s.w_stride * s.c, 0);
  for (int n = 0; n < s.n; ++n)
    for (int y = 0; y < s.h; ++y) {
      const size_t src = (static_cast<size_t>(n) * s.h + y) * s.w * s.c;
      const size_t dst = (static_cast<size_t>(n) * s.h + y) * s.w_stride * s.c;
      std::copy_n(tight.data() + src, static_cast<size_t>(s.w * s.c), padded.data() + dst);
    }
  return padded;
}

int main() {
  const NhwcShape s{1, 4, 6, 3, 8};  // 模拟 Runtime 查询到的 w_stride=8，而非模型宽度 6。
  std::vector<uint8_t> input(static_cast<size_t>(s.n) * s.h * s.w * s.c);
  for (size_t i = 0; i < input.size(); ++i) input[i] = static_cast<uint8_t>(i % 251);
  const auto packed = pack_to_rknn_stride(input, s);
  for (int y = 0; y < s.h; ++y) {
    const size_t src = static_cast<size_t>(y) * s.w * s.c;
    const size_t dst = static_cast<size_t>(y) * s.w_stride * s.c;
    if (!std::equal(input.begin() + src, input.begin() + src + s.w * s.c, packed.begin() + dst))
      return 2;
    if (std::any_of(packed.begin() + dst + s.w * s.c, packed.begin() + dst + s.w_stride * s.c,
                    [](uint8_t v) { return v != 0; }))
      return 3;
  }
  try {
    (void)pack_to_rknn_stride({}, s);
    return 4;
  } catch (const std::invalid_argument&) {
  }
  constexpr int kWarmup = 1000, kSamples = 10000;
  for (int i = 0; i < kWarmup; ++i) (void)pack_to_rknn_stride(input, s);
  const auto start = std::chrono::steady_clock::now();
  for (int i = 0; i < kSamples; ++i) (void)pack_to_rknn_stride(input, s);
  const auto end = std::chrono::steady_clock::now();
  const double us = std::chrono::duration<double, std::micro>(end - start).count() / kSamples;
  std::cout << "CPU stride-pack correctness=PASS; host preprocessing average_us=" << us << "\n";
}
