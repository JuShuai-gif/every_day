#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
mkdir -p build
case "$mode" in
cpu) c++ -std=c++17 -O2 -Wall -Wextra -Werror src/cpu_check.cpp -o build/cpu ;;
sanitize) c++ -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu_check.cpp -o build/sanitize ;;
thor)
  # 在已配置TensorRT 10.13.x/CUDA13的Thor执行；不自动安装依赖。
  nvcc --version
  nvcc --list-gpu-code | grep -w sm_110
  nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/trt_graph.cpp src/kernels.cu -lnvinfer -o build/thor ;;
*) echo 'usage: build.sh cpu|sanitize|thor' >&2; exit 2 ;;
esac
