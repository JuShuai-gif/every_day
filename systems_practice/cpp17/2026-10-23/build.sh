#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 产物留在忽略目录；不安装依赖，明确C++17。
mode=${1:-release}
case "$mode" in
 release) flags='-O2' ;;
 sanitize) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ;;
 tsan) flags='-O1 -g -fsanitize=thread' ;;
 *) echo 'unknown build mode' >&2; exit 2 ;;
esac
mkdir -p build
${CXX:-c++} -std=c++17 -Wall -Wextra -Wpedantic -pthread $flags src/main.cpp -o "build/app-$mode"
