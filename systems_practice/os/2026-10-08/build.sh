#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# MODE决定验证工具，发布模式也保留显式合同检查。
case "${MODE:-release}" in
 release) flags="-O3" ;;
 sanitize) flags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" ;;
 tsan) flags="-O1 -g -fsanitize=thread" ;;
 *) exit 2 ;;
esac
${CXX:-c++} -std=c++17 -Wall -Wextra -Werror -pthread $flags src/main.cpp -o "build/${MODE:-release}"
