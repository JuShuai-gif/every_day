#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
mkdir -p build
flags="-O2"
case "$mode" in
 release) ;;
 sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
 tsan) flags="-O1 -g -fsanitize=thread" ;;
 *) echo "unknown build mode" >&2; exit 2 ;;
esac
# 所有二进制只留在忽略的build中；严格使用C++17。
${CXX:-clang++} -std=c++17 -Wall -Wextra -Werror -pedantic -pthread $flags src/main.cpp -o "build/check-$mode"
