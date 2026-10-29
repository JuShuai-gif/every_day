#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# PYTHON指定已有NumPy环境；不安装依赖。
${PYTHON:-python3} experiment.py > build/experiment.json
sh build.sh
./build/check build/case-*.bin
if [ "${CUDA_BUILD:-0}" = 1 ]; then
 for casefile in build/case-*.bin; do
  ./build/gemm "$casefile" baseline
  ./build/gemm "$casefile" tiled
 done
fi
