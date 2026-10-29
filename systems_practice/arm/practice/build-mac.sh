#!/bin/sh
set -eu

# Mac 本机构建只检查源代码、正确性和 Apple arm64 上的行为；它不是 RK3588 性能结果。
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir="$root/build/mac"
cmake -S "$root" -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
cmake --build "$build_dir" --parallel
for binary in "$build_dir"/example_*; do "$binary"; done
