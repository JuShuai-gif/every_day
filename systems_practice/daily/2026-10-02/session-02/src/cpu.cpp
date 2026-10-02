#include <iostream>

#include "contract.hpp"
// CPU只核对地址映射和尾部合同，不模拟GPU吞吐、调度或同步。
int main() {
  try {
    int tests = 0;
    for (int h : {1, 7, 31, 32, 33, 65, 129})
      for (int w : {1, 7, 31, 32, 33, 65, 129})
        for (int pad : {0, 3}) {
          Shape s{h, w, w + pad, h + pad};
          auto a = input(s);
          auto gold = oracle(a, s);
          for (int pitch : {32, 33}) {
            std::vector<float> b(gold.size(), -999);
            for (int by = 0; by < h; by += 32)
              for (int bx = 0; bx < w; bx += 32) {
                std::vector<float> tile(32 * pitch, 0);
                for (int ty = 0; ty < 8; ++ty)
                  for (int tx = 0; tx < 32; ++tx)
                    for (int j = 0; j < 32; j += 8)
                      if (by + ty + j < h && bx + tx < w)
                        tile[(ty + j) * pitch + tx] = a[std::size_t(by + ty + j) * s.ldi + bx + tx];
                for (int ty = 0; ty < 8; ++ty)
                  for (int tx = 0; tx < 32; ++tx)
                    for (int j = 0; j < 32; j += 8)
                      if (bx + ty + j < w && by + tx < h)
                        b[std::size_t(bx + ty + j) * s.ldo + by + tx] = tile[tx * pitch + ty + j];
              }
            check(b == gold, "mapping or padding mismatch");
            ++tests;
          }
        }
    int rejected = 0;
    for (Shape s :
         std::vector<Shape>{{0, 1, 1, 1}, {1, 2, 1, 1}, {2, 1, 1, 1}, {9000, 1, 1, 9000}}) {
      try {
        validate(s);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    check(rejected == 4, "invalid shapes");
    std::cout << "PASS mapping_cases=" << tests << " invalid=" << rejected
              << " CPU correctness only\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
