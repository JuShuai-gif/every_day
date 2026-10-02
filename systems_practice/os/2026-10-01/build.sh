#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$root/build"
# 禁用标量基线自动向量化，但NEON intrinsic仍生成向量指令。
cxx=${CXX:-clang++}
"$cxx" --version
"$cxx" -std=c++17 -O2 -g -Wall -Wextra -Wpedantic  "$root/src/example.cpp" -o "$root/build/example"
"$cxx" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer  "$root/src/example.cpp" -o "$root/build/sanitize"
