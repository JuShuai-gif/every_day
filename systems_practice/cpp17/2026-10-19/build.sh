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
"$cxx" $flags src/main.cpp -o "$out/practice"
