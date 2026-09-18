#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-cpu}
if [ "$#" -gt 0 ]; then shift; fi
# 只使用本工程build/，不安装依赖；CUDA目标固定Thor SM110。
case "$mode" in
  cpu) options='-DENABLE_CUDA=OFF -DENABLE_SANITIZERS=OFF'; binary=quant_cpu ;;
  sanitize) options='-DENABLE_CUDA=OFF -DENABLE_SANITIZERS=ON'; binary=quant_cpu ;;
  gpu) options='-DENABLE_CUDA=ON -DENABLE_SANITIZERS=OFF -DCMAKE_CUDA_ARCHITECTURES=110'; binary=quant_gpu ;;
  *) echo 'usage: run.sh [cpu|sanitize|gpu] [GPU arguments]' >&2; exit 2 ;;
esac
cmake -S "$root" -B "$root/build/$mode" -DCMAKE_BUILD_TYPE=Release $options
cmake --build "$root/build/$mode" -j 2
"$root/build/$mode/$binary" "$@"
