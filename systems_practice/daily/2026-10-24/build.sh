#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 所有CUDA执行固定普通sm_110，不启用架构专属后缀。
case "${1:-cpu}" in
cpu) "${CXX:-clang++}" -std=c++17 -O2 -Wall -Wextra -Werror src/cpu_check.cpp -o build/cpu_check ;;
sanitize) "${CXX:-clang++}" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu_check.cpp -o build/cpu_check ;;
thor) nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110 -Xptxas=-v src/rmsnorm.cu -o build/rmsnorm ;;
*) exit 2;;
esac
