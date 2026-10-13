#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# CPU参考与Thor构建明确分开。
case "${1:-cpu}" in
 cpu) "${CXX:-c++}" -std=c++17 -O2 -Wall -Wextra -Werror src/cpu.cpp -o build/cpu ;;
 sanitize) "${CXX:-c++}" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu.cpp -o build/cpu-sanitize ;;
 thor) nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/gemm.cu -o build/gemm ;;
 *) echo 'cpu|sanitize|thor' >&2; exit 2 ;;
esac
