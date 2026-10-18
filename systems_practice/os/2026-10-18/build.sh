#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 所有模式保持C++17；浮点禁用收缩以固定对照的舍入语义。
mode=${1:-release}
case "$mode" in
 release) flags="-O3" ;;
 sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
 tsan) flags="-O1 -g -fsanitize=thread" ;;
 noelide) flags="-O1 -fno-elide-constructors" ;;
 *) echo "unknown mode" >&2; exit 2 ;;
esac
${CXX:-clang++} -std=c++17 -Wall -Wextra -Wpedantic -pthread -ffp-contract=off $flags src/main.cpp -o "build/$mode"
