#include <cstdint>
#include <iostream>
#include <stdexcept>
extern "C" std::uint64_t combine(std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t,
                                 std::uint64_t);
// 分离翻译单元且不启用 LTO，迫使调用者遵守实际 ABI。
__attribute__((noinline)) std::uint64_t caller(std::uint64_t seed) {
  auto keep = seed * 19;
  return combine(seed, 2, 3, 4, 5, 6, 7, 8, 9) + keep;
}
int main() {
  try {
    for (std::uint64_t x = 0; x < 1000; ++x) {
      if (caller(x) != 20 * x + 284) {
        throw std::runtime_error("ABI mismatch");
      }
    }
    std::cout << "PASS 1000 calls, nine uint64 args, live value across call; native Darwin ABI\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
