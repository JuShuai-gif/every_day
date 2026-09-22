#include <iostream>

#include "reduce.hpp"
using namespace practice;
template <int Acc, int Threads>
void verify(Shape s, const std::vector<float>& a) {
  // 独立统计每个输入的读者数，防止不同浮点数恰好抵消而掩盖漏读。
  std::vector<int> visits(s.cols, 0);
  for (int t = 0; t < Threads; ++t) {
    for (int base = t; base < s.cols; base += Acc * Threads) {
      for (int j = 0; j < Acc; ++j) {
        if (base + j * Threads < s.cols) {
          ++visits[base + j * Threads];
        }
      }
    }
  }
  for (int count : visits) {
    if (count != 1) {
      throw std::runtime_error("input coverage");
    }
  }
  check(s, a, emulate<Acc, Threads>(s, a));
}
int main() {
  try {
    int comparisons = 0;
    for (Shape s : cases()) {
      for (int pattern = 0; pattern < 3; ++pattern) {
        auto a = input(s, pattern);
        verify<1, 128>(s, a);
        verify<2, 128>(s, a);
        verify<4, 128>(s, a);
        verify<8, 128>(s, a);
        verify<4, 256>(s, a);
        comparisons += 5;
      }
    }
    int rejected = 0;
    for (Shape s : {Shape{0, 1, 1}, Shape{1, 0, 1}, Shape{1, 8, 7}, Shape{4097, 1, 1}}) {
      try {
        s.validate();
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    if (rejected != 4) {
      throw std::runtime_error("invalid shape accepted");
    }
    auto a = input({1, 33, 36});
    try {
      check({1, 33, 36}, a, {NAN});
      throw std::logic_error("NaN accepted");
    } catch (const std::runtime_error&) {
    }
    std::cout << "PASS shapes=" << cases().size()
              << " patterns=3 variants=5 comparisons=" << comparisons
              << " invalid=4 NaN-rejected; independent FP64 oracle and unique input coverage\n"
              << "CPU contract simulation only; GPU "
                 "synchronization/registers/occupancy/performance UNVERIFIED\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
