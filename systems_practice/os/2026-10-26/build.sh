#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
mkdir -p build
flags="-O2"
case "$mode" in
release) ;;
sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
thread) flags="-O1 -g -fsanitize=thread" ;;
*) exit 2 ;;
esac
# 只使用已有编译器，所有产物进入忽略的build目录。
c++ -std=c++17 -Wall -Wextra -Werror -pthread $flags src/main.cpp -o "build/$mode"
