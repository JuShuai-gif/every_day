#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 使用现有编译器；所有构建产物留在忽略目录。
flags="-O2"
case "${1:-release}" in
release) ;;
sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
tsan) flags="-O1 -g -fsanitize=thread" ;;
*) exit 2 ;;
esac
"${CXX:-clang++}" -std=c++17 -Wall -Wextra -Werror -pthread  $flags src/main.cpp -o build/example
