#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 禁止自动向量化，便于本节只观察标量地址和半字加载；后续再学 NEON。
cxx=${CXX:-clang++}
"$cxx" -std=c++17 -O2 -Wall -Wextra -Werror -fno-vectorize -fno-slp-vectorize src/stride.cpp -o build/stride
./build/stride
"$cxx" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S src/stride.cpp -o build/stride.s
"$cxx" -std=c++17 -O1 -g -fsanitize=address,undefined src/stride.cpp -o build/stride-sanitize
./build/stride-sanitize

# 展示真正要学习的函数体；数值PASS不替代ARM指令观察。
if "$cxx" -dumpmachine | grep -Eq "aarch64|arm64"; then
  printf "\n%s\n" "sum_rows：A64加载与寻址"
  awk '/^__?Z8sum_rows.*:/ {show=1} show {print} show && /[.]cfi_endproc/ {show=0}' build/stride.s
else
  printf "%s\n" "当前编译目标不是AArch64；数值检查不计为ARM指令验证。"
fi
