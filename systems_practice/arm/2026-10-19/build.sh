#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
out="build/$mode"
mkdir -p "$out"
cxx=${CXX:-clang++}
# 不定义NDEBUG，保留验收；sanitizer计时不可作为优化数据。
flags="-std=c++17 -Wall -Wextra -Wpedantic -pthread"
case "$mode" in
 release) flags="$flags -O3" ;;
 sanitize) flags="$flags -O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined" ;;
 tsan) flags="$flags -O1 -g -fsanitize=thread" ;;
 *) echo 'unknown build mode' >&2; exit 2 ;;
esac
# 基础分派不能被可选指令污染；关闭自动向量化便于检查标量回退。
"$cxx" $flags -march=armv8-a -fno-vectorize -fno-slp-vectorize -c src/main.cpp -o "$out/main.o"
"$cxx" $flags -march=armv8.2-a+dotprod -c src/dot.cpp -o "$out/dot.o"
"$cxx" $flags "$out/main.o" "$out/dot.o" -o "$out/practice"
"$cxx" $flags -march=armv8-a -fno-vectorize -fno-slp-vectorize -S src/main.cpp -o "$out/base.s"
"$cxx" $flags -march=armv8.2-a+dotprod -S src/dot.cpp -o "$out/dot.s"
