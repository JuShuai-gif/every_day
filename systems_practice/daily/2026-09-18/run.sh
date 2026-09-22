#!/bin/sh
set -eu
# 构建缓存只放在本练习的 build/，日志由调用方保存。
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-cpu}
if [ "$#" -gt 0 ]; then
  shift
fi
case "$mode" in
  cpu) options='-DENABLE_CUDA=OFF -DENABLE_SANITIZERS=OFF' ;;
  sanitize) options='-DENABLE_CUDA=OFF -DENABLE_SANITIZERS=ON' ;;
  gpu) options='-DENABLE_CUDA=ON -DENABLE_SANITIZERS=OFF -DCMAKE_CUDA_ARCHITECTURES=110' ;;
  *) echo 'usage: run.sh [cpu|sanitize|gpu] [GPU options]' >&2; exit 2 ;;
esac
# options 仅由上述固定分支生成；按多个 CMake 参数展开。
cmake -S "$root" -B "$root/build/$mode" -DCMAKE_BUILD_TYPE=Release $options
cmake --build "$root/build/$mode" -j 2
ctest --test-dir "$root/build/$mode" --output-on-failure
if [ "$mode" = gpu ]; then
  "$root/build/$mode/ptx_pool" "$@"
fi
