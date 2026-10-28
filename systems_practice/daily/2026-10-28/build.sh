#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"; mkdir -p build
c++ -std=c++17 -O2 -Wall -Wextra src/cpu_check.cpp -o build/cpu_check
if [[ "${1:-cpu}" == thor ]]; then
  : "固定 Thor，不改成 sm_110a";
  nvcc -std=c++17 -O3 -arch=sm_110 src/gemm.cu -o build/gemm_sm110
else echo "cpu build complete; use ./build.sh thor for nvcc"; fi
