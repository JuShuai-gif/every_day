#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# sanitizer单独构建，不把其耗时用于性能结论。
mode=${1:-release}
case "$mode" in
 release) flags='-O2' ;;
 sanitize) flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer' ;;
 tsan) flags='-O1 -g -fsanitize=thread' ;;
 *) exit 2 ;;
esac
"${CXX:-c++}" -std=c++17 -Wall -Wextra -Werror -pthread $flags src/main.cpp -o "build/$mode"
