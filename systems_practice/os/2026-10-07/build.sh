#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
mkdir -p build
case "$mode" in
 release) flags='-O3' ;;
 sanitize) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ;;
 tsan) flags='-O1 -g -fsanitize=thread' ;;
 *) echo 'usage: build.sh release|sanitize|tsan' >&2; exit 2 ;;
esac
# 编译输出只进入忽略的build，检查源码与线程/资源合同。
${CXX:-clang++} -std=c++17 -Wall -Wextra -Werror -pthread $flags src/main.cpp -o "build/example-$mode"
