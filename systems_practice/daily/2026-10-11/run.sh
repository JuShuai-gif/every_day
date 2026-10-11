#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
mkdir -p build
case "$mode" in
cpu) c++ -std=c++17 -O2 -Wall -Wextra -Werror src/cpu_check.cpp -o build/cpu_check; exec build/cpu_check ;;
sanitize) c++ -std=c++17 -O1 -g -fsanitize=address,undefined src/cpu_check.cpp -o build/check_sanitize; exec build/check_sanitize ;;
thor)
  # CMake 和运行时双重锁定 Thor，不能在其他 GPU 上替代验收。
  nvcc --version
  nvcc --list-gpu-code | grep sm_110
  cmake -S . -B build/thor -DTHOR=ON -DCMAKE_BUILD_TYPE=Release
  cmake --build build/thor -j2
  build/thor/trt
  for b in 1 4 8; do for w in 1 3 4 5 31 32 33 4097; do build/thor/kernels "$b" "$w"; done; done ;;
*) echo 'usage: run.sh cpu|sanitize|thor' >&2; exit 2 ;;
esac
