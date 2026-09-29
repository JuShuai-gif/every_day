#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 宿主POSIX观察；不构建或模拟xv6。
${CXX:-clang++} -std=c++17 -O2 -Wall -Wextra -Wpedantic src/example.cpp -o build/observe
${CXX:-clang++} -std=c++17 -O1 -g -fsanitize=address,undefined src/example.cpp -o build/observe-san
