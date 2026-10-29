#include <array>
#include <cmath>
#include <iostream>

#include "input.hpp"
int main() {
  int cases = 0, bad = 0;
  for (int h : {1, 2, 3, 7, 16})
    for (int w : {1, 5, 17, 224})
      for (int p : {0, 1, 13}) {
        auto f = lesson::make(h, w, p);
        auto a = lesson::baseline(f), c = lesson::fused(f);
        cases++;
        if (a.size() != c.size())
          return 2;
        for (size_t i = 0; i < a.size(); i++)
          if (std::abs(a[i] - c[i]) > 1e-7f)
            return 3;
      }
  for (auto z :
       {std::array<int, 3>{0, 5, 15}, std::array<int, 3>{3, 5, 14}, std::array<int, 3>{3, 0, 0}}) {
    try {
      lesson::Frame f{z[0], z[1], z[2], {}};
      (void)lesson::fused(f);
    } catch (...) {
      bad++;
    }
  }
  try {
    (void)lesson::make(3, 5, -1);
  } catch (...) {
    bad++;
  }
  std::cout << "PASS cases=" << cases << " rejects=" << bad << std::endl;
  return cases == 60 && bad == 4 ? 0 : 4;
}
