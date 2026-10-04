#include <iostream>

#include "qk.hpp"
int main() {
  try {
    int count = 0;
    for (int t : {0, 1, 15, 16, 17, 31, 32, 33, 96}) {
      for (int d : {1, 17, 32, 65}) {
        Data data(t, d);
        for (int x = 0; x < t; ++x) {
          if (std::abs(data.reference(x) - data.warp_model(x)) > 1e-4) {
            throw std::runtime_error("warp mapping");
          }
          ++count;
        }
      }
    }
    int rejected = 0;
    for (auto shape : {std::pair<int, int>{-1, 32}, {32, 0}}) {
      try {
        Data d(shape.first, shape.second);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    if (rejected != 2) {
      return 1;
    }
    std::cout
        << "PASS independent packed QK " << count
        << " rows, 36 shapes, zero/constant/tails, 2 invalid; not native KIVI or GPU execution\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
