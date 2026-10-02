#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$root/build.sh"
"$root/build/example"
"$root/build/sanitize"
# 保存真实Mac A64汇编，不当作Cortex实板结果。
"${CXX:-clang++}" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S "$root/src/example.cpp" -o "$root/results/host-arm64.s"
sed -n '/^_neon:/,/End function/p' "$root/results/host-arm64.s"
