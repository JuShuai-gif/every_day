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
"$cxx" -std=c++17 -O3 -S src/example.cpp -o build/vectorized.s
"$cxx" -std=c++17 -O3 src/example.cpp -o build/vectorized
./build/vectorized
