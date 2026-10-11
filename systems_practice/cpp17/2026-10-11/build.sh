#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 只用本机已有工具链；编译产物留在忽略目录。
case "${1:-release}" in
release) c++ -std=c++17 -O2 -g -Wall -Wextra -Werror src/main.cpp -o build/example ;;
sanitize) c++ -std=c++17 -O1 -g -fsanitize=address,undefined src/main.cpp -o build/example ;;
*) exit 2 ;;
esac
