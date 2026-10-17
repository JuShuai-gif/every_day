#include <array>
#include <iostream>

#include "contract.hpp"
// 仅模拟索引/归约次序；不是GPU同步或性能验证。
template <int U>
float mapped(const float* x, int cols) {
  std::array<float, 32> lanes{};
  std::vector<int> visits(cols, 0);
  for (int lane = 0; lane < 32; ++lane) {
    std::array<float, U> acc{};
    for (int base = lane; base < cols; base += 32 * U) {
      for (int u = 0; u < U; ++u) {
        const int c = base + 32 * u;
        if (c < cols) {
          acc[u] = std::fma(x[c], x[c], acc[u]);
          ++visits[c];
        }
      }
    }
    for (float a : acc) {
      lanes[lane] += a;
    }
  }
  for (int n : visits) {
    if (n != 1) {
      throw std::runtime_error("coverage");
    }
  }
  for (int d = 16; d > 0; d /= 2) {
    auto old = lanes;
    for (int l = 0; l < 32 - d; ++l) {
      lanes[l] += old[l + d];
    }
  }
  return lanes[0];
}
int main() {
  try {
    int cases = 0;
    for (int rows : {1, 3, 4, 5, 17}) {
      for (int cols : {1, 7, 31, 32, 33, 127, 128, 129, 1023, 4097, 65536}) {
        for (int pad : {0, 3}) {
          auto x = input(rows, cols, cols + pad);
          for (int r = 0; r < rows; ++r) {
            const auto* row = x.data() + static_cast<std::size_t>(r) * (cols + pad);
            check(mapped<1>(row, cols), reference(row, cols));
            check(mapped<4>(row, cols), reference(row, cols));
          }
          ++cases;
        }
      }
    }
    int rejected = 0;
    for (auto dims : {std::array<int, 3>{0, 1, 1}, {1, 0, 1}, {1, 2, 1}, {1, 65537, 65537}}) {
      try {
        validate(dims[0], dims[1], dims[2]);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    std::vector<float> zero(129, 0);
    check(mapped<4>(zero.data(), 129), 0);
    if (rejected != 4) {
      throw std::runtime_error("rejection");
    }
    std::cout << "PASS shapes=" << cases
              << " two_mappings exact_coverage zero rejected=" << rejected << "\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
