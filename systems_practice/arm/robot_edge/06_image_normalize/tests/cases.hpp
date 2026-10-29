#pragma once

#include <limits>

#include "../src/pipeline.hpp"
#include "edge_bench.hpp"

namespace normalize {

inline void verify(const Frame& frame, const Parameters& parameters) {
  const auto count = frame.width * frame.height * 3;
  std::vector<float> reference(count);
  std::vector<float> candidate(count);
  run(frame, parameters, Mode::Multipass, reference);
  for (const auto mode : {Mode::Fused, Mode::Vectorized}) {
    run(frame, parameters, mode, candidate);
    for (std::size_t i = 0; i < count; ++i) {
      const float tolerance = 2e-6f + std::abs(reference[i]) * 2e-6f;
      edge::require(
          std::isfinite(candidate[i]) && std::abs(reference[i] - candidate[i]) <= tolerance,
          "every normalized element matches reference");
    }
  }
}

inline void self_test() {
  const Parameters defaults;
  // 7/8/9 与 15/16/17 覆盖两个 SIMD 边界；零 padding 时 ASan 可捕获越界读取。
  for (const auto width : {1U, 2U, 7U, 8U, 9U, 15U, 16U, 17U, 63U}) {
    for (const auto padding : {0U, 1U, 64U}) {
      verify(make_frame(width, 3, padding), defaults);
    }
  }

  Frame known{2, 1, 6, {0, 127, 255, 255, 0, 127}};
  const Parameters identity{{0, 0, 0}, {1, 1, 1}};
  std::vector<float> output(6);
  run(known, identity, Mode::Vectorized, output);
  const std::array<float, 6> expected{0.0f, 1.0f, 127.0f / 255.0f, 0.0f, 1.0f, 127.0f / 255.0f};
  for (std::size_t i = 0; i < expected.size(); ++i) {
    edge::require(std::abs(output[i] - expected[i]) < 1e-6f, "known RGB to planar values");
  }

  auto padded = make_frame(9, 2, 7);
  auto altered = padded;
  for (std::size_t y = 0; y < padded.height; ++y) {
    for (std::size_t i = padded.width * 3; i < padded.stride; ++i) {
      altered.pixels[y * padded.stride + i] = 0;
    }
  }
  output.resize(9 * 2 * 3);
  std::vector<float> second(output.size());
  run(padded, defaults, Mode::Vectorized, output);
  run(altered, defaults, Mode::Vectorized, second);
  edge::require(output == second, "row padding does not enter tensor");

  // 后续负例使用正确的输出形状，避免因另一个错误而假通过。
  output.resize(known.width * known.height * 3);
  for (int fault = 0; fault < 6; ++fault) {
    auto bad = known;
    auto p = defaults;
    if (fault == 0) {
      bad.stride = 5;
    }
    if (fault == 1) {
      bad.pixels.pop_back();
    }
    if (fault == 2) {
      bad.width = 0;
    }
    if (fault == 3) {
      p.stddev[0] = 0;
    }
    if (fault == 4) {
      p.mean[1] = std::numeric_limits<float>::quiet_NaN();
    }
    if (fault == 5) {
      p.mean[0] = std::numeric_limits<float>::max();
      p.stddev[0] = 1e-6f;
    }
    bool rejected = false;
    try {
      run(bad, p, Mode::Vectorized, output);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    edge::require(rejected, "invalid frame/normalization contract rejected");
  }

  output.pop_back();
  bool shape_rejected = false;
  try {
    run(known, defaults, Mode::Vectorized, output);
  } catch (const std::invalid_argument&) {
    shape_rejected = true;
  }
  edge::require(shape_rejected, "output shape mismatch rejected");
}

}  // namespace normalize
