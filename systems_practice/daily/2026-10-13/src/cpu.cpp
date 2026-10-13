#include <array>
#include <iostream>

#include "contract.hpp"
// 独立CPU状态模型，只验证尾块置零合同，不能验证CUDA可见性。
std::vector<float> tiled(const Shape& s,
                         const std::vector<float>& a,
                         const std::vector<float>& b,
                         bool zero) {
  std::vector<float> c(s.m * s.n);
  for (int r = 0; r < s.m; ++r) {
    for (int n = 0; n < s.n; ++n) {
      std::array<float, 16> x{}, y{};
      x.fill(7);
      y.fill(9);
      float v = 0;
      for (int base = 0; base < s.k; base += 16) {
        for (int j = 0; j < 16; ++j) {
          if (base + j < s.k) {
            x[j] = a[r * s.lda + base + j];
            y[j] = b[(base + j) * s.ldb + n];
          } else if (zero) {
            x[j] = y[j] = 0;
          }
        }
        for (int j = 0; j < 16; ++j) {
          v = std::fma(x[j], y[j], v);
        }
      }
      c[r * s.n + n] = v;
    }
  }
  return c;
}
int main() {
  try {
    int cases = 0;
    for (int m : {1, 3, 15, 16, 17, 33}) {
      for (int n : {1, 3, 15, 16, 17, 33}) {
        for (int k : {1, 3, 15, 16, 17, 33}) {
          Shape s(m, n, k);
          auto a = input(m, k, s.lda, 1), b = input(k, n, s.ldb, 2);
          check(tiled(s, a, b, true), reference(s, a, b));
          ++cases;
        }
      }
    }
    Shape s(1, 1, 17);
    auto a = input(1, 17, s.lda, 1), b = input(17, 1, s.ldb, 2);
    bool caught = false;
    try {
      check(tiled(s, a, b, false), reference(s, a, b));
    } catch (const std::runtime_error&) {
      caught = true;
    }
    if (!caught) {
      throw std::runtime_error("stale-tile counterexample missing");
    }
    int rejects = 0;
    for (auto dims : {std::array<int, 3>{0, 1, 1}, {1, -1, 1}, {1, 1, 2049}}) {
      try {
        Shape bad(dims[0], dims[1], dims[2]);
      } catch (const std::invalid_argument&) {
        ++rejects;
      }
    }
    if (rejects != 3) {
      throw std::runtime_error("invalid shape accepted");
    }
    std::cout << "PASS shapes=" << cases << " invalid=3 stale_tile_detected=1; CPU contract only\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
