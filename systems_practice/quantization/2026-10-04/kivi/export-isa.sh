#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
nvcc --version > build/toolchain.txt
sh build.sh gpu
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/qk.cu -o build/qk.ptx
cuobjdump --dump-sass build/qk > build/qk.sass
cuobjdump --dump-resource-usage build/qk > build/resources.txt
# 只有实际生成后才把文本摘录与工具版本加入results。
