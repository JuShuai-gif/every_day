#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
// 无符号累加以模 2^64 定义，拆依赖链不会引入有符号溢出 UB。
__attribute__((noinline)) std::uint64_t serial(const std::uint64_t* p, std::size_t n) {
  std::uint64_t a = 0;
  for (std::size_t i = 0; i < n; ++i) {
    a += p[i];
  }
  return a;
}
__attribute__((noinline)) std::uint64_t four(const std::uint64_t* p, std::size_t n) {
  std::uint64_t a = 0, b = 0, c = 0, d = 0;
  std::size_t i = 0;
  for (; n - i >= 4; i += 4) {
    a += p[i];
    b += p[i + 1];
    c += p[i + 2];
    d += p[i + 3];
  }
  for (; i < n; ++i) {
    a += p[i];
  }
  return (a + b) + (c + d);
}
int main() {
  try {
    for (std::size_t n = 0; n < 1025; ++n) {
      std::vector<std::uint64_t> x(n);
      for (std::size_t i = 0; i < n; ++i) {
        x[i] = UINT64_MAX - i * 31;
      }
      if (serial(x.data(), n) != four(x.data(), n)) {
        throw std::runtime_error("tail or overflow");
      }
    }
    std::cout << "PASS 1025 lengths with tails and modulo overflow; no board performance claim\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
