#include <cmath>
#include <iostream>
#include <string>

#include "input.hpp"
void require(bool ok, const char* message) {
  if (!ok) {
    throw std::runtime_error(message);
  }
}
int main() {
  try {
    int cases = 0;
    for (std::size_t h : {1U, 3U, 7U}) {
      for (std::size_t w : {1U, 5U, 16U, 17U, 641U}) {
        for (std::size_t pad : {0U, 1U, 13U}) {
          const auto f = lesson::make_frame(h, w, pad);
          const auto a = lesson::baseline(f), b = lesson::fused(f);
          require(a == b, "baseline/fused mismatch");
          for (std::size_t i = 0; i < b.size(); ++i) {
            const auto row = i / (w * 3), x = (i / 3) % w, c = i % 3;
            const float expected =
                (static_cast<float>((row * 17 + x * 11 + c * 53) % 256) - 127.5F) / 127.5F;
            require(std::abs(b[i] - expected) < 1e-6F, "independent oracle");
          }
          ++cases;
        }
      }
    }
    int rejected = 0;
    auto bad = [&](lesson::Frame f) {
      try {
        (void)lesson::fused(f);
      } catch (const std::exception&) {
        ++rejected;
        return;
      }
      throw std::runtime_error("accepted invalid frame");
    };
    bad({0, 1, 3, {}});
    bad({1, 0, 0, {}});
    bad({2, 5, 14, std::vector<std::uint8_t>(30)});
    bad({2, 5, 20, std::vector<std::uint8_t>(34)});
    bad({1, std::numeric_limits<std::size_t>::max(), 3, {}});
    auto tight = lesson::make_frame(2, 5, 5);
    tight.bytes.resize(35);  // 最后一行无需尾部padding，最低合法跨度仍通过。
    require(lesson::fused(tight).size() == 30, "minimum extent");
    auto f = lesson::make_frame(3, 5, 13);
    auto correct = lesson::fused(f);
    int stride_errors = 0, normalized_twice = 0;
    for (std::size_t i = 0; i < correct.size(); ++i) {
      const float wrong = (float(f.bytes[i]) - 127.5F) / 127.5F;
      stride_errors += std::abs(wrong - correct[i]) > 1e-6F;
      normalized_twice += std::abs((correct[i] - 127.5F) / 127.5F - correct[i]) > 1e-6F;
    }
    require(stride_errors > 0 && normalized_twice > 0, "fault injection detection");
    std::cout << "PASS shapes=" << cases << " rejected=" << rejected << " minimum_extent=35B\n"
              << "stride_fault_elements=" << stride_errors
              << " double_normalization_fault_elements=" << normalized_twice << "\n"
              << "CPU correctness only; no NPU/GPU or end-to-end timing\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
