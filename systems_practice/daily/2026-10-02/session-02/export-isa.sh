#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build/isa
nvcc --version
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/transpose.cu -o build/isa/transpose.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin src/transpose.cu -o build/isa/transpose.cubin
cuobjdump --dump-sass build/isa/transpose.cubin > build/isa/transpose.sass
nvdisasm -g build/isa/transpose.cubin > build/isa/transpose-lines.sass
