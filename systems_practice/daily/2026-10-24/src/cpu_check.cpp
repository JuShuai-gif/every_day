#include <iostream>
#include <limits>

#include "reference.hpp"
int main() {
  try {
    int cases = 0, rejects = 0;
    float worst = 0;
    for (int rows : {1, 3, 4, 5, 17}) {
      for (int cols : {1, 3, 31, 32, 33, 127, 128, 129, 513, 1024}) {
        for (bool zero : {false, true}) {
          auto x = inputs(rows, cols, cols + 3, zero);
          worst = std::max(worst,
                           compare(warp_model(x, rows, cols, cols + 3, 1e-5f),
                                   reference(x, rows, cols, cols + 3, 1e-5f)));
          ++cases;
        }
      }
    }
    auto fails = [&](auto action) {
      try {
        action();
      } catch (const std::runtime_error&) {
        ++rejects;
        return;
      }
      throw std::runtime_error("missing rejection");
    };
    fails([] {
      contract(0, 32, 32, 1e-5f);
    });
    fails([] {
      contract(1, 1025, 1025, 1e-5f);
    });
    fails([] {
      contract(1, 32, 31, 1e-5f);
    });
    fails([] {
      contract(1, 32, 32, 0);
    });
    fails([] {
      reference({std::numeric_limits<float>::quiet_NaN()}, 1, 1, 1, 1e-5f);
    });
    fails([] {
      reference({129}, 1, 1, 1, 1e-5f);
    });
    std::cout << "PASS CPU index/numerical model cases=" << cases << " rejects=" << rejects
              << " max_abs=" << worst << "\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
