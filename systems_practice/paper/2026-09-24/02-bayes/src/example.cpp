#include <algorithm>
#include <array>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>
// 已经是log因子的数值，padding填0，不对填入的0再取log。
int main() {
  try {
    const std::array<double, 4> a{.2, .7, -.3, .4};
    const std::array<double, 6> b{1, .2, .4, .3, -.1, .7};
    const std::array<double, 2> x{.4, .6};
    const std::array<double, 3> y{.2, .3, .5};
    std::vector<double> block(4 * 5, 0), v{x[0], x[1], y[0], y[1], y[2]}, ref(4), got(4);
    for (int i = 0; i < 2; ++i) {
      for (int j = 0; j < 2; ++j) {
        block[i * 5 + j] = a[i * 2 + j];
        ref[i] += a[i * 2 + j] * x[j];
      }
      for (int j = 0; j < 3; ++j) {
        block[(i + 2) * 5 + j + 2] = b[i * 3 + j];
        ref[i + 2] += b[i * 3 + j] * y[j];
      }
    }
    double max_error = 0;
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 5; ++j) {
        got[i] += block[i * 5 + j] * v[j];
      }
      max_error = std::max(max_error, std::abs(got[i] - ref[i]));
    }
    if (max_error > 1e-12) {
      throw std::runtime_error("layout mismatch");
    }
    std::cout << "max_error=" << max_error
              << " original_values=10 merged_values=20 padding_values=10\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
