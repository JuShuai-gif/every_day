#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
case "${1:-cpu}" in
cpu) clang++ -std=c++17 -O2 -Wall -Wextra -Werror src/cpu_check.cpp -o build/cpu ;;
san) clang++ -std=c++17 -O1 -g -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu_check.cpp -o build/san ;;
gpu)
  # 固定Thor基础目标，不启用架构专属后缀。
  nvcc --version
  nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/gemm.cu -o build/gemm ;;
*) echo 'usage: build.sh cpu|san|gpu' >&2; exit 2 ;;
esac
