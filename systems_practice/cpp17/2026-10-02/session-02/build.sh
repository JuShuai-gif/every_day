#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build results
cxx=${CXX:-clang++}
"$cxx" --version
"$cxx" -std=c++17 -O2 -g -Wall -Wextra -Wpedantic src/example.cpp -o build/example
"$cxx" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/example.cpp -o build/sanitize
