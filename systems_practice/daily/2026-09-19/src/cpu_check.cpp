#include <array>
#include <iostream>

#include "layout.hpp"
using namespace practice;

// 顺序模拟CTA的两个阶段；只验证索引/覆盖，不模拟GPU并发或缓存性能。
template <int Pad, int BlockRows>
void simulate(const Shape& s, const std::vector<float>& a, const std::vector<float>& expected) {
  static_assert(32 % BlockRows == 0);
  std::vector<float> out(s.output_count(), sentinel);
  std::vector<int> writers(s.output_count(), 0);
  for (int b = 0; b < s.batches; ++b) {
    for (int by = 0; by < (s.rows + 31) / 32; ++by) {
      for (int bx = 0; bx < (s.cols + 31) / 32; ++bx) {
        std::array<float, 32 * (32 + Pad)> tile;
        tile.fill(sentinel);
        for (int ty = 0; ty < BlockRows; ++ty) {
          for (int tx = 0; tx < 32; ++tx) {
            for (int j = 0; j < 32; j += BlockRows) {
              int r = by * 32 + ty + j, c = bx * 32 + tx;
              if (r < s.rows && c < s.cols) {
                tile[(ty + j) * (32 + Pad) + tx] =
                    a[(std::size_t(b) * s.rows + r) * s.input_stride + c];
              }
            }
          }
        }
        // 对应无条件CTA barrier后的读阶段，所有有效读都必须有生产者。
        for (int ty = 0; ty < BlockRows; ++ty) {
          for (int tx = 0; tx < 32; ++tx) {
            for (int j = 0; j < 32; j += BlockRows) {
              int r = by * 32 + tx, c = bx * 32 + ty + j;
              if (r < s.rows && c < s.cols) {
                auto offset = (std::size_t(b) * s.cols + c) * s.output_stride + r;
                out[offset] = tile[tx * (32 + Pad) + ty + j];
                ++writers[offset];
              }
            }
          }
        }
      }
    }
  }
  check(out, expected);
  for (int b = 0; b < s.batches; ++b) {
    for (int c = 0; c < s.cols; ++c) {
      for (int r = 0; r < s.output_stride; ++r) {
        if (writers[(std::size_t(b) * s.cols + c) * s.output_stride + r] != (r < s.rows ? 1 : 0)) {
          throw std::runtime_error("write ownership");
        }
      }
    }
  }
}
int main() {
  try {
    for (auto s : cases()) {
      auto a = input(s), expected = oracle(s, a);
      simulate<0, 8>(s, a, expected);
      simulate<1, 8>(s, a, expected);
      simulate<1, 4>(s, a, expected);
    }
    int rejected = 0;
    for (Shape bad : {Shape{0, 1, 1, 1, 1},
                      Shape{1, 33, 7, 6, 33},
                      Shape{1, 33, 7, 7, 32},
                      Shape{1, 4097, 1, 1, 4097}}) {
      try {
        bad.validate();
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    if (rejected != 4) {
      throw std::runtime_error("invalid shape accepted");
    }
    // 32位标量、32 banks模型：列读取的地址对bank取模；不是硬件计数器。
    for (int pad : {0, 1}) {
      std::array<int, 32> counts{};
      for (int lane = 0; lane < 32; ++lane) {
        ++counts[(lane * (32 + pad)) % 32];
      }
      std::cout << "analytical_bank_max_multiplicity pad=" << pad
                << " value=" << *std::max_element(counts.begin(), counts.end()) << '\n';
    }
    std::cout << "PASS " << cases().size()
              << " shapes x 3 tile configurations; exact oracle, unique writers, padding; 4 "
                 "invalid shapes\n";
    std::cout << "CPU indexing validation only; no GPU timing or race validation\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
