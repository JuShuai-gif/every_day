#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# Thor通用目标，不启用架构专属后缀。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 src/codec.cu -o build/codec
