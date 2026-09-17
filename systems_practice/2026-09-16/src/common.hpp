#pragma once
#include <algorithm>
#include <array>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

namespace practice {
constexpr int kFeatures = 8;
constexpr int kMaxBatch = 4;
constexpr int kWarmup = 10;
constexpr int kSamples = 100;
inline std::size_t elements(int batch) {
  if (batch < 1 || batch > kMaxBatch)
    throw std::invalid_argument("batch must be in [1,4]");
  return static_cast<std::size_t>(batch) * kFeatures;
}
inline void fill_input(float* input, int batch, unsigned frame = 0) {
  for (std::size_t i = 0; i < elements(batch); ++i)
    input[i] = static_cast<float>(static_cast<int>((i + frame % 17) % 17) - 8) / 4.0F;
}
// Kept out of line so CPU timing cannot discard or hoist repeated calls.
void reference(const float* input, float* output, int batch);
inline void check_known(const float* output, int batch, unsigned frame = 0) {
  for (std::size_t i = 0; i < elements(batch); ++i) {
    // Independent closed-form oracle for the deterministic input above.
    const float expected =
        static_cast<float>(std::max(0, static_cast<int>((i + frame % 17) % 17) - 6)) / 8.0F;
    if (!std::isfinite(output[i]) || std::abs(output[i] - expected) > 1.0e-6F)
      throw std::runtime_error("known-answer mismatch at " + std::to_string(i));
  }
}
inline float compare(const float* actual, const float* expected, int batch) {
  float max_error = 0;
  for (std::size_t i = 0; i < elements(batch); ++i) {
    const float error = std::abs(actual[i] - expected[i]);
    if (!std::isfinite(actual[i]) || error > 1.0e-6F + 1.0e-6F * std::abs(expected[i]))
      throw std::runtime_error("GPU/CPU mismatch at " + std::to_string(i));
    max_error = std::max(max_error, error);
  }
  return max_error;
}
using Clock = std::chrono::steady_clock;
inline double milliseconds(Clock::time_point start, Clock::time_point end) {
  return std::chrono::duration<double, std::milli>(end - start).count();
}
inline double percentile(std::vector<double> values, double fraction) {
  if (values.empty())
    throw std::invalid_argument("empty samples");
  std::sort(values.begin(), values.end());
  return values.at(static_cast<std::size_t>(std::ceil(fraction * values.size())) - 1);
}
inline void stats(const char* name, const std::vector<double>& values) {
  std::cout << name << " samples=" << values.size() << " p50_ms=" << percentile(values, .50)
            << " p95_ms=" << percentile(values, .95) << '\n';
}
}  // namespace practice
