#include <cstddef>
#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>

// 顺序相机特征流：预取只是一条提示，绝不改变越界/正确性合同。
std::uint64_t sum_prefetch(const std::vector<std::uint16_t>& x) {
  std::uint64_t sum = 0;
  for (std::size_t i = 0; i < x.size(); ++i) {
    if (i + 32 < x.size()) __builtin_prefetch(&x[i + 32], 0, 1);
    sum += x[i];
  }
  return sum;
}
int main() {
  std::vector<std::uint16_t> x(4097);
  for (std::size_t i = 0; i < x.size(); ++i) x[i] = static_cast<std::uint16_t>(i % 251);
  std::uint64_t ref = 0; for (auto v : x) ref += v;
  if (sum_prefetch(x) != ref || sum_prefetch({}) != 0) throw std::runtime_error("sum contract");
  std::cout << "PASS prefetch contract: 4097 elements and empty boundary\n";
}
