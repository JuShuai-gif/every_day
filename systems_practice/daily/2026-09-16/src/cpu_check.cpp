#include <climits>
#include <iomanip>

#include "common.hpp"

int main() {
  using namespace practice;
  try {
    std::cout << std::fixed << std::setprecision(9);
    constexpr std::size_t capacity = kMaxBatch * kFeatures;
    std::array<float, capacity> input{}, output{};
    unsigned frame = 0;
    for (int batch : {1, 4, 2, 1, 3, 2}) {
      fill_input(input.data(), batch, frame);
      output.fill(-999.0F);
      reference(input.data(), output.data(), batch);
      check_known(output.data(), batch, frame++);
      for (std::size_t i = elements(batch); i < capacity; ++i)
        if (output[i] != -999.0F)
          throw std::runtime_error("tail overwritten");
      std::cout << "CPU correctness PASS batch=" << batch << " tail_guard=PASS\n";
    }
    for (int batch : {-1, 0, 5, INT_MAX}) {
      bool rejected = false;
      try {
        (void)elements(batch);
      } catch (const std::invalid_argument&) {
        rejected = true;
      }
      if (!rejected)
        throw std::runtime_error("invalid batch accepted");
      std::cout << "CPU invalid batch=" << batch << " rejected=PASS\n";
    }
    bool rejected = false;
    try {
      reference(nullptr, output.data(), 1);
    } catch (const std::invalid_argument&) {
      rejected = true;
    }
    if (!rejected)
      throw std::runtime_error("null input accepted");
    std::cout << "CPU null input rejected=PASS\n";
    constexpr int batch = 2;
    constexpr int repeats = 1000;
    fill_input(input.data(), batch);
    std::vector<double> samples;
    samples.reserve(kSamples);
    for (int sample = -kWarmup; sample < kSamples; ++sample) {
      const auto start = Clock::now();
      for (int repeat = 0; repeat < repeats; ++repeat)
        reference(input.data(), output.data(), batch);
      const auto end = Clock::now();
      check_known(output.data(), batch);
      if (sample >= 0)
        samples.push_back(milliseconds(start, end) / repeats);
    }
    std::cout << "CPU reference batch=2 warmup_groups=" << kWarmup
              << " repeats_per_group=" << repeats << " unit=per_call\n";
    stats("cpu_reference", samples);
    std::cout << "GPU compile/execution/accuracy/performance: NOT VERIFIED on this CPU run\n";
    return 0;
  } catch (const std::exception& error) {
    std::cerr << "FAIL: " << error.what() << '\n';
    return 1;
  }
}
