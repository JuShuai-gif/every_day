#!/bin/sh
set -eu
# 在本课目录执行；构建/中间输出仅放忽略目录，不安装依赖。
cd "$(dirname "$0")"
mkdir -p build
${CXX:-clang++} -std=c++17 -O2 -Wall -Wextra -Werror src/example.cpp -o build/example
./build/example
${CXX:-clang++} -std=c++17 -O1 -g -fsanitize=address,undefined src/example.cpp -o build/sanitize
./build/sanitize
