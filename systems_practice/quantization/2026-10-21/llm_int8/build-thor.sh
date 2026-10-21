#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
nvcc --version > build/nvcc-version.txt
# 仅编译SM110，不选择a/f后缀或其他设备。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/mixed.cu -o build/mixed 2>build/ptxas.txt
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/mixed.cu -o build/mixed.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --cubin src/mixed.cu -o build/mixed.cubin
cuobjdump --list-elf build/mixed > build/elf.txt
cuobjdump --dump-sass build/mixed.cubin > build/mixed.sass.txt
nvdisasm --print-line-info build/mixed.cubin > build/mixed.lines.sass.txt
