#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
${CXX:-clang++} -std=c++17 -O2 -Wall -Wextra -Werror src/main.cpp -o build/main
