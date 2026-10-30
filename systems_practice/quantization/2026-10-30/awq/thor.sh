#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 普通SM110，无架构专用后缀。缺少工具即停止。
nvcc --version
nvcc --list-gpu-code | grep -w sm_110
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/gemv.cu -o build/gemv
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/gemv.cu -o build/gemv.ptx
cuobjdump --dump-sass build/gemv > build/gemv.sass
./build/gemv
