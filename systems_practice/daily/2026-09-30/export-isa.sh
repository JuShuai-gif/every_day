#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
nvcc --version > build/nvcc-version.txt
ptxas --version > build/ptxas-version.txt
sh build.sh gpu
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/gemm.cu -o build/gemm.ptx
cuobjdump --dump-sass build/gemm > build/gemm.sass
cuobjdump --dump-resource-usage build/gemm > build/resources.txt
# .ptx/.sass均来自本次sm_110真实编译；缺nvcc时不创建伪造文本。
