#include <array>
#include <iostream>
#include <set>

#include "contract.hpp"
// 只检验索引/写入覆盖模型；不模拟CUDA同步和性能。
std::vector<float> tiled(const std::vector<float>& a, Shape s) {
  std::vector<float> b(s.output_size(), -999.f);
  for (int by = 0; by < s.rows; by += 32) {
    for (int bx = 0; bx < s.cols; bx += 32) {
      float tile[32][33]{};
      for (int y = 0; y < 32; ++y) {
        for (int x = 0; x < 32; ++x) {
          if (by + y < s.rows && bx + x < s.cols) {
            tile[y][x] = a[std::size_t(by + y) * s.in_stride + bx + x];
          }
        }
      }
      for (int y = 0; y < 32; ++y) {
        for (int x = 0; x < 32; ++x) {
          if (bx + y < s.cols && by + x < s.rows) {
            b[std::size_t(bx + y) * s.out_stride + by + x] = tile[x][y];
          }
        }
      }
    }
  }
  return b;
}
int main() {
  try {
    int cases = 0;
    for (int r : {0, 1, 7, 31, 32, 33, 65}) {
      for (int c : {0, 1, 9, 31, 32, 33, 67}) {
        for (int pad : {0, 3}) {
          Shape s{r, c, c + pad, r + pad};
          auto a = input(s);
          if (tiled(a, s) != reference(a, s)) {
            throw std::runtime_error("transpose mismatch");
          }
          ++cases;
        }
      }
    }
    int rejected = 0;
    for (Shape s : {Shape{-1, 1, 1, 1}, Shape{2, 3, 2, 2}, Shape{2, 3, 3, 1}}) {
      try {
        s.check();
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    std::set<int> bank32, bank33;
    for (int lane = 0; lane < 32; ++lane) {
      bank32.insert((lane * 32) % 32);
      bank33.insert((lane * 33) % 32);
    }
    if (rejected != 3 || bank32.size() != 1 || bank33.size() != 32) {
      throw std::runtime_error("contract/model");
    }
    std::cout << "PASS CPU index model cases=" << cases << " rejections=" << rejected
              << " bank sets=" << bank32.size() << "," << bank33.size()
              << " (analytical, not GPU measurement)\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
