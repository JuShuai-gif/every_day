#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 保持C++17；显式sanitizer与Release使用独立运行记录。
case "${1:-release}" in
release) flags="-O3  -fno-vectorize -fno-slp-vectorize" ;;
sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
*) exit 2 ;;
esac
"${CXX:-clang++}" -std=c++17 -Wall -Wextra -pedantic $flags src/main.cpp -o build/example
