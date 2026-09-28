#include <iostream>
#include <limits>

#include "reference.hpp"
int main() {
  try {
    int cases = 0;
    for (int r : {1, 2, 7, 33}) {
      for (int c : {1, 7, 31, 32, 33, 127, 255, 256}) {
        for (int p = 0; p < 3; ++p) {
          auto x = input(r, c, p);
          auto y = softmax_reference(x, r, c);
          verify(y, y, c);
          auto z = x;
          for (auto& a : z) {
            a += 32.0F;
          }
          verify(softmax_reference(z, r, c), y, c);
          ++cases;
        }
      }
    }
    int invalid = 0;
    for (int c : {0, -1, 257}) {
      try {
        (void)softmax_reference({}, 1, c);
      } catch (const std::invalid_argument&) {
        ++invalid;
      }
    }
    try {
      (void)softmax_reference({std::numeric_limits<float>::infinity()}, 1, 1);
    } catch (const std::invalid_argument&) {
      ++invalid;
    }
    if (invalid != 4) {
      throw std::runtime_error("invalid contract");
    }
    std::cout << "CPU oracle PASS " << cases
              << " shapes/patterns, translation invariance, 4 invalid; GPU untested\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
