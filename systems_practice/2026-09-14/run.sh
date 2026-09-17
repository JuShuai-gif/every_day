#!/bin/sh
set -eu

# 构建缓存放在本练习 results 内，源码和真实日志可长期归档。
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir="$root/results/mac-release-build"
cmake -S "$root" -B "$build_dir" -DCMAKE_BUILD_TYPE=Release
cmake --build "$build_dir" --target frame_arena
"$build_dir/frame_arena"
