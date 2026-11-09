#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
flags='-O2'
case "${1:-release}" in
 release) ;;
 sanitize) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ;;
 *) echo 'use release or sanitize' >&2; exit 2 ;;
esac
# 编译产物留在忽略目录；失败直接返回。
${CXX:-c++} -std=c++17 -Wall -Wextra -Werror $flags src/main.cpp -o build/check
exec build/check
