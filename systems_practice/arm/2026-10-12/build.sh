#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 严格C++17；无依赖安装。
"${CXX:-c++}" -std=c++17 -O2 -Wall -Wextra -Werror -pthread src/main.cpp -o build/check
