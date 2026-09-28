#include <cstdint>
#include <iostream>
#include <stdexcept>
#include <vector>
__attribute__((noinline)) std::uint32_t checksum(const std::uint32_t* p, std::size_t n) {
  std::uint32_t sum = 0;
  for (std::size_t i = 0; i < n; ++i) {
    sum += p[i];
  }
  return sum;
}
int main() {
  try {
    for (std::size_t n = 0; n < 1025; ++n) {
      std::vector<std::uint32_t> x(n, 17);
      if (checksum(x.data(), n) != static_cast<std::uint32_t>(n * 17)) {
        throw std::runtime_error("checksum");
      }
    }
    std::cout << "PASS 1025 lengths C++17; ";
#if defined(__aarch64__)
    std::cout << "target=aarch64 ";
#endif
#if defined(__ARM_NEON)
    std::cout << "NEON compiled ";
#endif
#if defined(__ARM_FEATURE_DOTPROD)
    std::cout << "DOTPROD compiled (not runtime detection) ";
#endif
    std::cout << "compiler=" << __VERSION__ << '\n';
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
