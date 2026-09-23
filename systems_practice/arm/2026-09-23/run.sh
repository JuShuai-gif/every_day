#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 仅AArch64原生编译；不安装工具链，不冒充板端执行。
"${CXX:-clang++}" -std=c++17 -O2 -Wall -Wextra -Werror src/registers.cpp -o build/registers
"${CXX:-clang++}" -std=c++17 -O2 -S src/registers.cpp -o build/registers.s
./build/registers
