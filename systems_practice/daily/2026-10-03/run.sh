#!/bin/sh
set -eu
cd "$(dirname "$0")"
# CPU只验证合同；gpu分支始终构建sm_110。
case "${1:-cpu}" in
cpu) cmake -S . -B build/cpu -DCMAKE_BUILD_TYPE=Release; cmake --build build/cpu; build/cpu/cpu ;;
sanitize) mkdir -p build; c++ -std=c++17 -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer src/cpu.cpp -o build/sanitize; build/sanitize ;;
gpu) cmake -S . -B build/gpu -DENABLE_CUDA=ON -DCMAKE_BUILD_TYPE=Release; cmake --build build/gpu; build/gpu/energy ;;
*) echo 'usage: run.sh cpu|sanitize|gpu' >&2; exit 2 ;;
esac
