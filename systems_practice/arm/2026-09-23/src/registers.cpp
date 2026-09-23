#include <arm_neon.h>

#include <array>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <stdexcept>

// 显式W写入再读取对应X，不把编译器的C++类型转换当作寄存器实验证据。
extern "C" __attribute__((noinline)) std::uint64_t write_w(std::uint64_t x) {
  std::uint64_t out;
  asm("mov %w0, %w1" : "=r"(out) : "r"(x));
  return out;
}

// 4s是四个32位lane；V寄存器不是额外的四个通用X寄存器。
extern "C" __attribute__((noinline)) void add_lanes(const std::uint32_t* x,
                                                    const std::uint32_t* y,
                                                    std::uint32_t* out) {
  vst1q_u32(out, vaddq_u32(vld1q_u32(x), vld1q_u32(y)));
}

int main() {
  try {
    for (auto x : {UINT64_C(0), UINT64_C(0xffff000012345678), UINT64_C(0xffffffffffffffff)}) {
      const auto out = write_w(x);
      if (out != (x & UINT64_C(0xffffffff))) {
        throw std::runtime_error("W/X observation mismatch");
      }
      std::cout << "input=0x" << std::hex << x << " write_W_read_X=0x" << out << std::dec << '\n';
    }
    const std::array<std::uint32_t, 4> x = {1, 2, 3, UINT32_MAX};
    const std::array<std::uint32_t, 4> y = {10, 20, 30, 1};
    std::array<std::uint32_t, 4> out{};
    add_lanes(x.data(), y.data(), out.data());
    for (std::size_t i = 0; i < out.size(); ++i) {
      if (out[i] != static_cast<std::uint32_t>(x[i] + y[i])) {
        throw std::runtime_error("V lane observation mismatch");
      }
      std::cout << "lane" << i << '=' << out[i] << '\n';
    }
    std::cout << "PASS 3 W/X cases + 4 V lanes; CPU observation only\n";
  } catch (const std::exception& e) {
    std::cerr << e.what() << '\n';
    return 1;
  }
}
