#include <cstddef>
#include <cstdint>
#ifndef NAME
#define NAME transform_auto
#endif
extern "C" void NAME(std::uint32_t* dst, const std::uint32_t* src, std::size_t n) {
  // 允许重叠：每次迭代读取当前src值，再写dst；没有restrict承诺。
  for (std::size_t i = 0; i < n; ++i) {
    dst[i] = src[i] * 3u + 1u;
  }
}
