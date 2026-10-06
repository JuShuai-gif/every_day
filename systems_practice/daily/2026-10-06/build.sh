#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
mkdir -p build
# 优化基线禁止自动向量化，手写intrinsics仍生成NEON。
case "$mode" in
 release) flags="-O3 -fno-vectorize -fno-slp-vectorize" ;;
 sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
 *) echo "release|sanitize" >&2; exit 2 ;;
esac
${CXX:-clang++} -std=c++17 -Wall -Wextra -Werror $flags src/main.cpp -o "build/$mode"
