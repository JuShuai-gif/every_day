#!/bin/sh
set -eu
# 只在本机编译 CPU 参考，避免把 Mac 的结果误标为 NPU 结果。
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir="$root/results/mac-cpu-build"
cmake -S "$root" -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
cmake --build "$build_dir" --target cpu_stride_check
"$build_dir/cpu_stride_check"
