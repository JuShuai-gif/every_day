#include <sys/utsname.h>

#include <cstdio>
#include <cstdlib>
#include <iostream>

int main() {
  // uname 查询当前运行环境；交叉编译时，它与下方的编译目标概念不同。
  utsname environment{};
  if (uname(&environment) != 0) {
    std::perror("uname");
    return EXIT_FAILURE;
  }

  std::cout << "runtime.os=" << environment.sysname << '\n';
  std::cout << "runtime.release=" << environment.release << '\n';
  std::cout << "runtime.machine=" << environment.machine << '\n';

#if defined(__clang__)
  std::cout << "compiler=Clang " << __clang_version__ << '\n';
#elif defined(__GNUC__)
  std::cout << "compiler=GCC " << __VERSION__ << '\n';
#else
  std::cout << "compiler=unrecognized\n";
#endif

#if defined(__APPLE__)
  std::cout << "compile.os=Apple\n";
#elif defined(__linux__)
  std::cout << "compile.os=Linux\n";
#else
  std::cout << "compile.os=other\n";
#endif

  // sizeof 说明当前程序的 ABI，不用于推断另一块板的 CPU 或指令能力。
  std::cout << "compile.pointer_bytes=" << sizeof(void*) << '\n';

  // 这些条件在编译时求值，不执行被查询的可选 ARM 指令。
#if defined(__aarch64__)
  std::cout << "__aarch64__=" << __aarch64__ << '\n';
#else
  std::cout << "__aarch64__=not_defined\n";
#endif

#if defined(__ARM_NEON)
  std::cout << "__ARM_NEON=" << __ARM_NEON << '\n';
#else
  std::cout << "__ARM_NEON=not_defined\n";
#endif

#if defined(__ARM_FEATURE_DOTPROD)
  std::cout << "__ARM_FEATURE_DOTPROD=" << __ARM_FEATURE_DOTPROD << '\n';
#else
  std::cout << "__ARM_FEATURE_DOTPROD=not_defined\n";
#endif

#if defined(__ARM_FEATURE_FP16_VECTOR_ARITHMETIC)
  std::cout << "__ARM_FEATURE_FP16_VECTOR_ARITHMETIC=" << __ARM_FEATURE_FP16_VECTOR_ARITHMETIC
            << '\n';
#else
  std::cout << "__ARM_FEATURE_FP16_VECTOR_ARITHMETIC=not_defined\n";
#endif

#if defined(__ARM_FEATURE_MATMUL_INT8)
  std::cout << "__ARM_FEATURE_MATMUL_INT8=" << __ARM_FEATURE_MATMUL_INT8 << '\n';
#else
  std::cout << "__ARM_FEATURE_MATMUL_INT8=not_defined\n";
#endif

#if defined(__ARM_FEATURE_SVE)
  std::cout << "__ARM_FEATURE_SVE=" << __ARM_FEATURE_SVE << '\n';
#else
  std::cout << "__ARM_FEATURE_SVE=not_defined\n";
#endif

#if defined(__ARM_FEATURE_SVE2)
  std::cout << "__ARM_FEATURE_SVE2=" << __ARM_FEATURE_SVE2 << '\n';
#else
  std::cout << "__ARM_FEATURE_SVE2=not_defined\n";
#endif

#if defined(__ARM_NEON_SVE_BRIDGE)
  std::cout << "__ARM_NEON_SVE_BRIDGE=" << __ARM_NEON_SVE_BRIDGE << '\n';
#else
  std::cout << "__ARM_NEON_SVE_BRIDGE=not_defined\n";
#endif

  std::cout << "scope=compile-time features; no remote board capability query\n";
  std::cout << "compute_kernel_executed=false\n";
  std::cout << "performance_measured=false\n";
  if (!std::cout) {
    std::fputs("failed to write target report\n", stderr);
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
