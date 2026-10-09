#include <cmath>
#include <iostream>
#include <stdexcept>
#include <vector>

std::vector<float> reference(const std::vector<float>& x, int rows, int cols) {
  if (rows <= 0 || cols <= 0 || cols > 256 || x.size() != static_cast<size_t>(rows * cols)) {
    throw std::invalid_argument("shape must be rows x cols, 1 <= cols <= 256");
  }
  std::vector<float> y(x.size());
  for (int r = 0; r < rows; ++r) {
    float maximum = -INFINITY;
    for (int c = 0; c < cols; ++c) maximum = std::fmax(maximum, x[r * cols + c]);
    float sum = 0.0F;
    for (int c = 0; c < cols; ++c) sum += std::exp(x[r * cols + c] - maximum);
    for (int c = 0; c < cols; ++c) y[r * cols + c] = std::exp(x[r * cols + c] - maximum) / sum;
  }
  return y;
}

int main() {
  int comparisons = 0;
  for (int cols : {1, 7, 31, 32, 33, 127, 255, 256}) {
    std::vector<float> x(7 * cols);
    for (size_t i = 0; i < x.size(); ++i) x[i] = static_cast<float>(static_cast<int>(i % 17) - 8);
    const auto a = reference(x, 7, cols);
    for (float& v : x) v += 25.0F;  // softmax 对逐行平移不变。
    const auto b = reference(x, 7, cols);
    for (size_t i = 0; i < a.size(); ++i) {
      if (std::abs(a[i] - b[i]) > 2e-6F) throw std::runtime_error("translation invariance failed");
    }
    ++comparisons;
  }
  int rejected = 0;
  for (int cols : {0, 257}) {
    try { (void)reference({}, 1, cols); } catch (const std::invalid_argument&) { ++rejected; }
  }
  if (rejected != 2) throw std::runtime_error("invalid shape was accepted");
  std::cout << "PASS: " << comparisons << " stable-softmax cases, " << rejected
            << " invalid shapes; CUDA kernels not run on this Mac\n";
}
