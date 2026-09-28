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
