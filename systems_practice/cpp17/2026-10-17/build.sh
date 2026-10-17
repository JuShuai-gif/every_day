#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
export TMPDIR="$PWD/build"
# 只写本课忽略的构建目录；Sanitizer可单独执行。
c++ -std=c++17 -O2 -Wall -Wextra -Werror -pthread src/main.cpp src/reader.cpp -o build/example
