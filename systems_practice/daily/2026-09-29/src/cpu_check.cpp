#include <iostream>
#include <limits>

#include "contract.hpp"

int main() {
  try {
    int cases = 0;
    for (int zero : {-128, -7, 0, 127}) {
      for (int q = -128; q <= 127; ++q) {
        const auto code = static_cast<std::int8_t>(q);
        const auto y = decode(&code, 1, 1, 0.125F, zero);
        require(y[0] == (q - zero) * 0.125F, "decode mismatch");
        ++cases;
      }
    }
    int invalid = 0;
    std::int8_t value = 0;
    auto reject = [&](auto call) {
      try {
        call();
      } catch (const std::runtime_error&) {
        ++invalid;
      }
    };
    reject([&] {
      decode(nullptr, 1, 1, 1, 0);
    });
    reject([&] {
      decode(&value, 0, 0, 1, 0);
    });
    reject([&] {
      decode(&value, 2, 1, 1, 0);
    });
    reject([&] {
      decode(&value, 1, 1, 0, 0);
    });
    reject([&] {
      decode(&value, 1, 1, std::numeric_limits<float>::quiet_NaN(), 0);
    });
    reject([&] {
      decode(&value, 1, 1, 1, 128);
    });
    require(invalid == 6, "invalid contract accepted");
    int released = 0;
    for (int i = 0; i < 1000; ++i) {
      try {
        OutputLease lease([&]() noexcept {
          ++released;
        });
        OutputLease moved(std::move(lease));
        if (i % 2) {
          throw std::runtime_error("postprocess failure injection");
        }
      } catch (const std::runtime_error&) {
      }
    }
    require(released == 1000, "lease double release or leak");
    for (unsigned frame = 0; frame < 16; ++frame) {
      auto y = oracle(input(frame));
      require(y.size() == 40 && std::isfinite(y.back()), "oracle");
    }
    std::cout << "PASS affine=" << cases << " invalid=" << invalid
              << " lease=1000 (500 exception unwinds) frames=16\nCPU contract only; no NPU "
                 "performance measured\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
