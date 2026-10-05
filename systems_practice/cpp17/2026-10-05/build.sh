#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
mkdir -p build
# 所有产物留在课程目录，编译失败立即停止。
case "$mode" in
 release) flags="-O3" ;;
 sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
 tsan) flags="-O1 -g -fsanitize=thread" ;;
 *) echo "unknown build mode" >&2; exit 2 ;;
esac
${CXX:-c++} -std=c++17 -Wall -Wextra -Werror -pthread $flags src/main.cpp -o "build/$mode"
