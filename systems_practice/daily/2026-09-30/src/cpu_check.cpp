#include <array>
#include <iostream>
#include <limits>

#include "contract.hpp"

// CPU只检查tile索引/补零/轮转数学；不能证明GPU屏障或异步完成。
std::vector<float> staged(const std::vector<float>& a,
                          const std::vector<float>& b,
                          Shape s,
                          int stages) {
  std::vector<float> c(s.m * s.n, std::numeric_limits<float>::quiet_NaN());
  std::array<std::array<float, 256>, 2> as{}, bs{};
  for (int bi = 0; bi < s.m; bi += 16) {
    for (int bj = 0; bj < s.n; bj += 16) {
      std::array<float, 256> sums{};
      auto load = [&](int tile, int slot) {
        as[slot].fill(std::numeric_limits<float>::quiet_NaN());
        bs[slot].fill(std::numeric_limits<float>::quiet_NaN());
        for (int y = 0; y < 16; ++y) {
          for (int x = 0; x < 16; ++x) {
            int ak = tile * 16 + x, bk = tile * 16 + y;
            as[slot][y * 16 + x] = bi + y < s.m && ak < s.k ? a[(bi + y) * s.k + ak] : 0;
            bs[slot][y * 16 + x] = bj + x < s.n && bk < s.k ? b[bk * s.n + bj + x] : 0;
          }
        }
      };
      int count = (s.k + 15) / 16;
      load(0, 0);
      for (int t = 0; t < count; ++t) {
        int slot = t % stages;
        if (stages == 2 && t + 1 < count) {
          load(t + 1, (t + 1) % stages);
        }
        for (int y = 0; y < 16; ++y) {
          for (int x = 0; x < 16; ++x) {
            for (int k = 0; k < 16; ++k) {
              sums[y * 16 + x] =
                  std::fma(as[slot][y * 16 + k], bs[slot][k * 16 + x], sums[y * 16 + x]);
            }
          }
        }
        if (stages == 1 && t + 1 < count) {
          load(t + 1, 0);
        }
      }
      for (int y = 0; y < 16 && bi + y < s.m; ++y) {
        for (int x = 0; x < 16 && bj + x < s.n; ++x) {
          c[(bi + y) * s.n + bj + x] = sums[y * 16 + x];
        }
      }
    }
  }
  return c;
}
int main() {
  try {
    int count = 0;
    for (int m : {1, 15, 16, 17, 33}) {
      for (int n : {1, 15, 16, 17, 35}) {
        for (int k : {1, 15, 16, 17, 31, 32, 33, 65}) {
          Shape s{m, n, k};
          auto a = input(m * k, 1), b = input(k * n, 3), ref = oracle(a, b, s);
          for (int stages : {1, 2}) {
            check(staged(a, b, s, stages), ref);
            ++count;
          }
        }
      }
    }
    for (Shape s :
         {Shape{0, 1, 1}, Shape{1, -1, 1}, Shape{1, 1, 0}, Shape{513, 1, 1}, Shape{1, 1, 2049}}) {
      bool rejected = false;
      try {
        s.validate();
      } catch (const std::invalid_argument&) {
        rejected = true;
      }
      if (!rejected) {
        throw std::runtime_error("invalid shape accepted");
      }
    }
    // 全零输入覆盖补零合同；独立小矩阵给手算结果。
    check(staged({1, 2, 3, 4, 5, 6}, {7, 8, 9, 10, 11, 12}, {2, 2, 3}, 2), {58, 64, 139, 154});
    check(staged(std::vector<float>(17 * 33), std::vector<float>(33 * 19), {17, 19, 33}, 2),
          std::vector<float>(17 * 19));
    std::cout << "PASS " << count
              << " tiled comparisons, 5 invalid shapes, hand oracle, zero input\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
