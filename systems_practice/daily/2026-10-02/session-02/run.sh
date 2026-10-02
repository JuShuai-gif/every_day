#!/bin/sh
set -eu
cd "$(dirname "$0")"
case "${1:-cpu}" in
cpu) cmake -S . -B build/cpu -DCMAKE_BUILD_TYPE=Release; cmake --build build/cpu; build/cpu/cpu ;;
sanitize) mkdir -p build; "${CXX:-clang++}" -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu.cpp -o build/sanitize; build/sanitize ;;
gpu) cmake -S . -B build/gpu -DCMAKE_BUILD_TYPE=Release -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110; cmake --build build/gpu; build/gpu/transpose ;;
*) echo 'cpu | sanitize | gpu' >&2; exit 2;;
esac
