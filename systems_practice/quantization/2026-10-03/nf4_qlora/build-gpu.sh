#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# Thor固定目标，不生成架构专属后缀。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/nf4.cu -o build/nf4
build/nf4
