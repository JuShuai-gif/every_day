#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 消毒器结果仅验证宿主语义；性能以Release独立运行计量。
flags='-O2'
case "${SANITIZE:-0}" in
  1) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer';;
  thread) flags='-O1 -g -fsanitize=thread';;
esac
${CXX:-clang++} -std=c++17 -pthread -Wall -Wextra -Werror $flags src/main.cpp -o build/main
