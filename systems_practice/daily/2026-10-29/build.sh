#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# SANITIZE=1仅验证CPU解码和数值合同，不替代CUDA验证。
flags='-O2'
if [ "${SANITIZE:-0}" = 1 ]; then flags='-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer'; fi
${CXX:-clang++} -std=c++17 -Wall -Wextra -Werror $flags src/check.cpp -o build/check
if [ "${CUDA_BUILD:-0}" = 1 ]; then
 nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 src/gemm.cu -o build/gemm
fi
