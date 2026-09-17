#include <iomanip>

#include "common.hpp"

using namespace practice;
int main() try {
  std::cout << std::fixed << std::setprecision(6);
  const std::array<Shape, 4> cases{{{2, 224, 224}, {2, 223, 225}, {1, 1, 1}, {0, 224, 224}}};
  double observed = 0;
  for (const Shape s : cases) {
    auto input = input_for(s);
    if (s.batch == 1 && s.height == 1)
      input = {0, 127, 255};
    std::vector<float> expected(s.elements()), actual(s.elements());
    reference(input, expected, s);
    output_linear(input, actual, s);
    float max_error = 0;
    for (std::size_t i = 0; i < actual.size(); ++i) {
      const float error = std::abs(actual[i] - expected[i]);
      if (!std::isfinite(actual[i]) || error > 1e-6f)
        throw std::runtime_error("CPU layout check failed");
      max_error = std::max(max_error, error);
    }
    if (s.batch == 1 && s.height == 1) {
      const std::array<double, 3> independent{{(0.0 / 255.0 - 0.485) / 0.229,
                                               (127.0 / 255.0 - 0.456) / 0.224,
                                               (255.0 / 255.0 - 0.406) / 0.225}};
      for (int c = 0; c < 3; ++c)
        if (std::abs(actual[c] - independent[c]) > 1e-6)
          throw std::runtime_error("analytic RGB boundary check failed");
    }
    std::cout << "PASS shape=" << s.batch << 'x' << s.height << 'x' << s.width
              << "x3 max_abs_error=" << max_error << '\n';
    if (actual.empty())
      continue;
    for (int i = 0; i < warmups; ++i) {
      reference(input, actual, s);
      observed += checksum(actual);
    }
    std::vector<double> samples;
    for (int i = 0; i < repeats; ++i) {
      const auto start = Clock::now();
      reference(input, actual, s);
      samples.push_back(elapsed_ms(start, Clock::now()));
      observed += checksum(actual);  // Observable output, outside timed region.
    }
    std::cout << "CPU_reference_wall_ms p50=" << percentile(samples, .50)
              << " p95=" << percentile(samples, .95) << " warmups=" << warmups
              << " repeats=" << repeats << '\n';
  }
  bool rejected = false;
  try {
    (void)Shape{-1, 224, 224}.elements();
  } catch (const std::invalid_argument&) {
    rejected = true;
  }
  if (!rejected)
    throw std::runtime_error("invalid shape accepted");
  std::cout << "PASS invalid_shape_rejected\nchecksum=" << observed
            << "\nCUDA_compile=UNVERIFIED GPU_kernel_ms=UNVERIFIED GPU_e2e_ms=UNVERIFIED\n";
  return 0;
} catch (const std::exception& e) {
  std::cerr << "FAIL: " << e.what() << '\n';
  return 1;
}
