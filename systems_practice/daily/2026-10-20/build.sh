#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 构建缓存不归档；严格C++17，不启用fast-math。
mkdir -p build
case "${MODE:-release}" in
  release) flags="-O3" ;;
  sanitize) flags="-O1 -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
  tsan) flags="-O1 -fsanitize=thread -fno-omit-frame-pointer" ;;
  *) echo "unknown MODE" >&2; exit 2 ;;
esac
${CXX:-clang++} -std=c++17 -Wall -Wextra -Wpedantic -g $flags -pthread src/main.cpp -o "build/${MODE:-release}"
