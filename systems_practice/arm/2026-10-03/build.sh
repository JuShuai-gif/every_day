#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 同一C++17源码分别生成优化及内存/未定义行为检查版本。
c++ -std=c++17 -O3 -Wall -Wextra -Werror src/main.cpp -o build/example
c++ -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/main.cpp -o build/sanitize
