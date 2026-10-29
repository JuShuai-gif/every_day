#include <arm_neon.h>  // NEON 向量类型和 intrinsic（内建函数）。

#include <array>      // std::array：固定长度数组。
#include <cstdint>    // std::uint32_t、std::uint64_t 等定宽整数类型。
#include <iomanip>    // std::hex、std::dec：控制整数输出进制。
#include <iostream>   // std::cout、std::cerr。
#include <stdexcept>  // std::runtime_error。

// AArch64 中，Wn 是 Xn 的低 32 位视图。向 Wn 写入时，硬件会将 Xn 的高 32 位清零。
// 此处用内联汇编显式写 W 寄存器后再由 C++ 读取结果，而非把 C++ 的类型转换当作证据。
// noinline 防止编译器把函数并入调用方，方便在反汇编中观察这段寄存器操作。
extern "C" __attribute__((noinline)) std::uint64_t write_w(std::uint64_t x) {
  // out 使用 64 位变量接收结果；寄存器约束 "r" 让编译器分配通用寄存器。
  std::uint64_t out;
  // %w0 和 %w1 强制使用分配给操作数 0、1 的寄存器的 32 位 W 视图。
  // mov 写入 W 寄存器时会发生零扩展，因此返回值应为 x 的低 32 位。
  // "=r" 表示只写输出操作数，"r" 表示只读输入操作数。
  /*
  为什么w0就是32位寄存器呢？
  因为 AArch64 同时需要兼容两种常见整数宽度：
  X0–X30：64 位通用寄存器，用于指针、uint64_t、64 位整数。
  W0–W30：同一批物理寄存器的低 32 位视图，用于 int、uint32_t 等 32 位整数。

  也就是说，W0 不是另一个独立寄存器，而是 X0 的低 32 位：
  X0：| 高 32 位 | 低 32 位 |
  W0：          | 低 32 位 |

  其实这里的 x 也是 64 位的，但是由于它写入了寄存器 w1，所以它只取了32位，然后写入另一个32位寄存器w0

  x = 0xffff000012345678
           └─低 32 位：0x12345678

  写入 W 寄存器后：
  out = 0x0000000012345678
  */
  asm("mov %w0, %w1" : "=r"(out) : "r"(x));
  return out;
}

// NEON 的一个 128 位 V 寄存器可存放 4 个 32 位元素（汇编常写作 4s）。
// V 寄存器用于 SIMD 数据，和通用 X/W 寄存器是两套不同的寄存器。
// noinline 同样便于在生成的汇编中查看 NEON 加载、加法和存储指令。
extern "C" __attribute__((noinline)) void add_lanes(const std::uint32_t* x,
                                                    const std::uint32_t* y,
                                                    std::uint32_t* out) {
  // vld1q_u32：分别从 x、y 加载四个 uint32_t 到 128 位 NEON 向量。
  // vaddq_u32：四条 lane 独立执行无符号 32 位加法，溢出时按模 2^32 回绕。
  // vst1q_u32：把四个结果 lane 写回 out。
  vst1q_u32(out, vaddq_u32(vld1q_u32(x), vld1q_u32(y)));
}

int main() {
  try {
    // 依次测试全零、带非零高 32 位的数、全 1，验证写 W 后高 32 位被清零。
    for (auto x : {UINT64_C(0), UINT64_C(0xffff000012345678), UINT64_C(0xffffffffffffffff)}) {
      const auto out = write_w(x);
      // 期望值是 x 的低 32 位；若不相等，说明观察结果不符合 AArch64 W/X 规则。
      if (out != (x & UINT64_C(0xffffffff))) {
        throw std::runtime_error("W/X observation mismatch");
      }
      // 以十六进制显示输入和结果，随后恢复十进制格式，避免影响后续 lane 输出。
      std::cout << "input=0x" << std::hex << x << " write_W_read_X=0x" << out << std::dec << '\n';
    }
    // 最后一个元素 UINT32_MAX 用于展示 NEON 的 32 位无符号加法会自然回绕：MAX + 1 = 0。
    const std::array<std::uint32_t, 4> x = {1, 2, 3, UINT32_MAX};
    const std::array<std::uint32_t, 4> y = {10, 20, 30, 1};
    std::array<std::uint32_t, 4> out{};
    add_lanes(x.data(), y.data(), out.data());
    // 逐 lane 验证 NEON 向量加法的结果；C++ 强制转换同样给出模 2^32 的预期值。
    for (std::size_t i = 0; i < out.size(); ++i) {
      if (out[i] != static_cast<std::uint32_t>(x[i] + y[i])) {
        throw std::runtime_error("V lane observation mismatch");
      }
      std::cout << "lane" << i << '=' << out[i] << '\n';
    }
    // 该结论只证明当前 CPU 上观察到的 W/X 与 NEON 行为；没有进行性能测试。
    std::cout << "PASS 3 W/X cases + 4 V lanes; CPU observation only\n";
  } catch (const std::exception& e) {
    // 验证失败时输出原因，并向操作系统返回非零状态码。
    std::cerr << e.what() << '\n';
    return 1;
  }
}
