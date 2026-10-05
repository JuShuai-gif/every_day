#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
nvcc --version
ptxas --version
sh build.sh
# SASS只从真实SM110二进制导出，不用示意片段代替。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/codec.cu -o build/codec.ptx
cuobjdump --dump-sass build/codec > build/codec.sass
cuobjdump --dump-resource-usage build/codec > build/resources.txt
