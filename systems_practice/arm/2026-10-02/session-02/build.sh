#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build results
cxx=${CXX:-clang++}
"$cxx" --version
"$cxx" -std=c++17 -O2 -g -Wall -Wextra -Wpedantic -ffp-contract=off -fno-vectorize -fno-slp-vectorize src/example.cpp -o build/example
"$cxx" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -ffp-contract=off -fno-vectorize -fno-slp-vectorize src/example.cpp -o build/sanitize
"$cxx" -std=c++17 -O2 -ffp-contract=off -fno-vectorize -fno-slp-vectorize -S src/example.cpp -o results/host-arm64.s
