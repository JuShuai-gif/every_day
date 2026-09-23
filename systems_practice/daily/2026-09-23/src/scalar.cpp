#include <stdexcept>

#include "dot.hpp"

// 单独翻译单元关闭自动向量化，避免把编译器SIMD当作标量基线。
std::int32_t scalar_dot(const std::int8_t* x, const std::int8_t* y, std::size_t n) {
  if (n > 32 || (n != 0 && (x == nullptr || y == nullptr))) {
    throw std::invalid_argument("block needs valid pointers and n<=32");
  }
  std::int32_t sum = 0;
  for (std::size_t i = 0; i < n; ++i) {
    sum += static_cast<std::int32_t>(x[i]) * y[i];
  }
  return sum;
}
