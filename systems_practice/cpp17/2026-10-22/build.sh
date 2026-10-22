#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
mode=${1:-release}
case "$mode" in
 release) flags='-O2' ;;
 sanitize) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ;;
 tsan) flags='-O1 -g -fsanitize=thread' ;;
 *) echo 'expected release|sanitize|tsan' >&2; exit 2 ;;
esac
# C++17与错误检查；不依赖额外库、不安装任何包。
${CXX:-c++} -std=c++17 -Wall -Wextra -Wpedantic -Werror -pthread $flags src/main.cpp -o "build/check-$mode"
