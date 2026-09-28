#!/bin/sh
set -eu
# 在本课目录执行；构建/中间输出仅放忽略目录，不安装依赖。
cd "$(dirname "$0")"
mkdir -p build
cxx=${CXX:-clang++}
"$cxx" -std=c++17 -O2 -Wall -Wextra -Werror -fno-vectorize -fno-slp-vectorize src/*.cpp -o build/example
./build/example
"$cxx" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S src/example.cpp -o build/native.s
"$cxx" -std=c++17 -O1 -g -fsanitize=address,undefined src/*.cpp -o build/sanitize
./build/sanitize

# 展示真正要学习的函数体；数值PASS不替代ARM指令观察。
if "$cxx" -dumpmachine | grep -Eq "aarch64|arm64"; then
  printf "\n%s\n" "caller：AArch64参数与保存寄存器"
  awk '/^__?Z6caller.*:/ {show=1} show {print} show && /[.]cfi_endproc/ {show=0}' build/native.s
else
  printf "%s\n" "当前编译目标不是AArch64；数值检查不计为ARM指令验证。"
fi
