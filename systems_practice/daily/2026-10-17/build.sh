#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
export TMPDIR="$PWD/build"
# Mac只编译索引参考；设备目标固定Thor。
if [ "${1:-cpu}" = gpu ]; then
  nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/energy.cu -o build/energy
else
  c++ -std=c++17 -O2 -Wall -Wextra -Werror src/cpu_check.cpp -o build/cpu_check
fi
