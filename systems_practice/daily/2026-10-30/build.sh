#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# CPU仅校验合同；Thor代码必须由支持SM110的CUDA13+工具链构建。
case "${1:-cpu}" in
cpu) "${CXX:-clang++}" -std=c++17 -O2 -Wall -Wextra -pedantic src/cpu_check.cpp -o build/cpu_check ;;
sanitize) "${CXX:-clang++}" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu_check.cpp -o build/cpu_check ;;
thor) nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/transpose.cu -o build/transpose ;;
*) exit 2 ;;
esac
