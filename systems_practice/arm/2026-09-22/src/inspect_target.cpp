#include <sys/utsname.h>  // utsname 和 uname()：读取程序实际运行的系统信息。

#include <cstdio>    // std::perror、stderr。
#include <cstdlib>   // EXIT_SUCCESS、EXIT_FAILURE。
#include <iostream>  // std::cout。

int main() {
  // uname() 查询“此刻运行程序的机器”。若是交叉编译，结果可能与编译目标不同。
  utsname environment{};
  if (uname(&environment) != 0) {
    // uname() 失败时输出系统错误原因，并以失败状态退出。
    std::perror("uname");
    return EXIT_FAILURE;
  }

  // sysname、release、machine 分别是系统内核名称、内核发行版本和机器架构。
  std::cout << "runtime.os=" << environment.sysname << '\n';
  std::cout << "runtime.release=" << environment.release << '\n';
  std::cout << "runtime.machine=" << environment.machine << '\n';

#if defined(__clang__)  // 预处理阶段判断：本程序是否由 Clang 编译。
  std::cout << "compiler=Clang " << __clang_version__ << '\n';
#elif defined(__GNUC__)  // 若不是 Clang，再检查是否为 GCC。
  std::cout << "compiler=GCC " << __VERSION__ << '\n';
#else
  std::cout << "compiler=unrecognized\n";
#endif

#if defined(__APPLE__)  // 编译目标平台，而不是 uname() 查询到的运行平台。
  std::cout << "compile.os=Apple\n";
#elif defined(__linux__)
  std::cout << "compile.os=Linux\n";
#else
  std::cout << "compile.os=other\n";
#endif

  // 指针大小反映当前程序的 ABI（应用二进制接口），例如 8 表示 64 位指针。
  // 它不能用来推断另一块开发板的 CPU 型号或可选指令集。
  std::cout << "compile.pointer_bytes=" << sizeof(void*) << '\n';

  // 以下宏均由编译器在预处理阶段提供，表示“当前编译目标启用了什么”。
  // defined(...) 只在编译时判断宏是否存在，不会执行任何 ARM 可选指令。
#if defined(__aarch64__)
  // AArch64：ARM 的 64 位执行状态。
  std::cout << "__aarch64__=" << __aarch64__ << '\n';
#else
  std::cout << "__aarch64__=not_defined\n";
#endif

#if defined(__ARM_NEON)
  // NEON / Advanced SIMD：固定 128 位向量指令扩展。
  std::cout << "__ARM_NEON=" << __ARM_NEON << '\n';
#else
  std::cout << "__ARM_NEON=not_defined\n";
#endif

#if defined(__ARM_FEATURE_DOTPROD)
  // 整数点积扩展：可高效执行多组小整数乘法并累加。
  std::cout << "__ARM_FEATURE_DOTPROD=" << __ARM_FEATURE_DOTPROD << '\n';
#else
  std::cout << "__ARM_FEATURE_DOTPROD=not_defined\n";
#endif

#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
  // FP16 向量算术：可对半精度浮点数执行向量计算。
  std::cout << "__ARM_FEATURE_FP16_VECTOR_ARITHMETIC=" << __ARM_FEATURE_FP16_VECTOR_ARITHMETIC
            << '\n';
#else
  std::cout << "__ARM_FEATURE_FP16_VECTOR_ARITHMETIC=not_defined\n";
#endif

#if defined(__ARM_FEATURE_MATMUL_INT8)
  // I8MM：INT8 整数矩阵乘法扩展；未定义仅说明本次编译未启用它。
  std::cout << "__ARM_FEATURE_MATMUL_INT8=" << __ARM_FEATURE_MATMUL_INT8 << '\n';
#else
  std::cout << "__ARM_FEATURE_MATMUL_INT8=not_defined\n";
#endif

#if defined(__ARM_FEATURE_SVE)
  // SVE：长度可伸缩的向量扩展。
  std::cout << "__ARM_FEATURE_SVE=" << __ARM_FEATURE_SVE << '\n';
#else
  std::cout << "__ARM_FEATURE_SVE=not_defined\n";
#endif

#if defined(__ARM_FEATURE_SVE2)
  // SVE2：在 SVE 基础上增加更多整数和信号处理类向量指令。
  std::cout << "__ARM_FEATURE_SVE2=" << __ARM_FEATURE_SVE2 << '\n';
#else
  std::cout << "__ARM_FEATURE_SVE2=not_defined\n";
#endif

#if defined(__ARM_NEON_SVE_BRIDGE)
  // 表示工具链提供 NEON/SVE 类型转换相关的头文件；不单独证明 SVE 已启用。
  std::cout << "__ARM_NEON_SVE_BRIDGE=" << __ARM_NEON_SVE_BRIDGE << '\n';
#else
  std::cout << "__ARM_NEON_SVE_BRIDGE=not_defined\n";
#endif

  // 说明报告边界：只检查编译期宏，未连接或查询远程开发板。
  std::cout << "scope=compile-time features; no remote board capability query\n";
  // 程序没有执行计算内核，也没有计时，因此输出不包含性能结论。
  std::cout << "compute_kernel_executed=false\n";
  std::cout << "performance_measured=false\n";
  if (!std::cout) {
    // 若写入标准输出失败，以失败状态退出。
    std::fputs("failed to write target report\n", stderr);
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
