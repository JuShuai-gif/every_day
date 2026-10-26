#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 只生成sm_110产物，不使用其他目标或专属后缀。
nvcc --version > build/nvcc-version.txt
ptxas --version > build/ptxas-version.txt
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/kernels.cu -o build/kernels-sm110.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin src/kernels.cu -o build/kernels-sm110.cubin
cuobjdump --dump-sass build/kernels-sm110.cubin > build/kernels-sm110.sass
nvdisasm -g build/kernels-sm110.cubin > build/kernels-sm110-lines.sass
