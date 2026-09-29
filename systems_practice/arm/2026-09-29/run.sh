#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build results
# 禁止向量化和循环展开，仅观察已学过的一链/四链A64形态。
CXX=${CXX:-clang++}
"$CXX" --version
uname -sm
"$CXX" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -fno-unroll-loops -c src/kernels.cpp -o build/kernels.o
"$CXX" -std=c++17 -O2 src/main.cpp build/kernels.o -o build/bench
./build/bench
"$CXX" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -fno-unroll-loops -S src/kernels.cpp -o build/kernels.s
# 直接展示小内核，读者无需翻完整汇编。
cat build/kernels.s
"$CXX" -std=c++17 -O1 -g -fsanitize=address,undefined src/main.cpp src/kernels.cpp -o build/check
./build/check
