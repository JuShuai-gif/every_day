#include <iostream>
#include <limits>

#include "contract.hpp"
int main() {
  try {
    int cases = 0;
    for (int b : {1, 4, 8}) {
      for (int w : {1, 3, 4, 5, 31, 32, 33, 4097}) {
        std::vector<float> x(elements(b, w)), y(x.size());
        for (std::size_t i = 0; i < x.size(); ++i) {
          x[i] = static_cast<float>(static_cast<int>(i % 37) - 18) / 8;
          y[i] = reference(x[i]);
        }
        check(x, y);
        // 独立阈值检查，不只把 oracle 的输出交回同一函数。
        for (std::size_t i = 0; i < x.size(); ++i) {
          if ((x[i] <= -0.5F && y[i] != 0) || y[i] < 0) {
            throw std::runtime_error("relu threshold");
          }
        }
        ++cases;
      }
    }
    int rejected = 0;
    for (auto shape : {std::pair<int, int>{0, 33}, {9, 33}, {1, 0}, {1, 4098}}) {
      try {
        (void)elements(shape.first, shape.second);
      } catch (const std::invalid_argument&) {
        ++rejected;
      }
    }
    try {
      (void)reference(std::numeric_limits<float>::infinity());
    } catch (const std::invalid_argument&) {
      ++rejected;
    }
    if (rejected != 5) {
      throw std::runtime_error("missing rejection");
    }
    std::cout << "PASS CPU shape/reference cases=" << cases << " rejected=" << rejected
              << "; CUDA/TensorRT not validated\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
