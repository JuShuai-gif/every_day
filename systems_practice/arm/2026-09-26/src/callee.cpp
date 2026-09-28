#include <cstdint>
extern "C" __attribute__((noinline)) std::uint64_t combine(std::uint64_t a,
                                                           std::uint64_t b,
                                                           std::uint64_t c,
                                                           std::uint64_t d,
                                                           std::uint64_t e,
                                                           std::uint64_t f,
                                                           std::uint64_t g,
                                                           std::uint64_t h,
                                                           std::uint64_t i) {
  return a + b * 2 + c * 3 + d * 4 + e * 5 + f * 6 + g * 7 + h * 8 + i * 9;
}
