#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 真实编译后才生成PTX/SASS，不预填任何机器指令结果。
nvcc --version > build/nvcc-version.txt
ptxas --version > build/ptxas-version.txt
nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110 -ptx src/rmsnorm.cu -o build/rmsnorm.ptx
nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110 -cubin -Xptxas=-v src/rmsnorm.cu -o build/rmsnorm.cubin
cuobjdump --dump-sass build/rmsnorm.cubin > build/rmsnorm.sass.txt
nvdisasm -g build/rmsnorm.cubin > build/rmsnorm.lines.sass.txt
