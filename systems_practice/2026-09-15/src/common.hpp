#pragma once
#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

namespace practice {
using Clock = std::chrono::steady_clock;
constexpr int warmups = 10;
constexpr int repeats = 50;
constexpr std::array<float, 3> mean{0.485f, 0.456f, 0.406f};
constexpr std::array<float, 3> stddev{0.229f, 0.224f, 0.225f};
struct Shape {
  int batch, height, width;
  std::size_t elements() const {
    if (batch < 0 || batch > 2 || height <= 0 || width <= 0 || height > 4096 || width > 4096)
      throw std::invalid_argument("requires B in [0,2], H/W in [1,4096]");
    return static_cast<std::size_t>(batch) * height * width * 3;
  }
};
inline std::vector<std::uint8_t> input_for(Shape s) {
  std::vector<std::uint8_t> input(s.elements());
  for (std::size_t i = 0; i < input.size(); ++i)
    input[i] = static_cast<std::uint8_t>((i * 37 + i / 7) % 256);
  return input;
}
// Independent reference: traverse input pixels, scatter into output channels.
inline void reference(const std::vector<std::uint8_t>& input, std::vector<float>& output, Shape s) {
  if (input.size() != s.elements() || output.size() != input.size())
    throw std::invalid_argument("reference buffer size mismatch");
  const std::size_t plane = static_cast<std::size_t>(s.height) * s.width;
  for (int b = 0; b < s.batch; ++b)
    for (std::size_t p = 0; p < plane; ++p)
      for (int c = 0; c < 3; ++c)
        output[(static_cast<std::size_t>(b) * 3 + c) * plane + p] =
            (static_cast<float>(input[(b * plane + p) * 3 + c]) / 255.0f - mean[c]) / stddev[c];
}
// CPU-only check of the output-linear indexing used by the CUDA kernel.
inline void output_linear(const std::vector<std::uint8_t>& input, std::vector<float>& output,
                          Shape s) {
  if (input.size() != s.elements() || output.size() != input.size())
    throw std::invalid_argument("linear buffer size mismatch");
  const std::size_t plane = static_cast<std::size_t>(s.height) * s.width;
  for (std::size_t i = 0; i < output.size(); ++i) {
    const auto p = i % plane;
    const auto c = (i / plane) % 3;
    const auto b = i / (3 * plane);
    output[i] = (input[(b * plane + p) * 3 + c] / 255.0f - mean[c]) / stddev[c];
  }
}
inline double elapsed_ms(Clock::time_point begin, Clock::time_point end) {
  return std::chrono::duration<double, std::milli>(end - begin).count();
}
inline double percentile(std::vector<double> values, double q) {
  if (values.empty())
    throw std::invalid_argument("empty samples");
  std::sort(values.begin(), values.end());
  return values[static_cast<std::size_t>(std::ceil(q * values.size())) - 1];
}
inline double checksum(const std::vector<float>& values) {
  double sum = 0;
  for (float v : values) sum += v;
  return sum;
}
}  // namespace practice
