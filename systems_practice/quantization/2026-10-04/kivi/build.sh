#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
case "${1:-cpu}" in
 cpu) clang++ -std=c++17 -O2 -Wall -Wextra -Werror -pedantic src/cpu.cpp -o build/cpu; ./build/cpu ;;
 sanitize) clang++ -std=c++17 -O1 -g -fsanitize=address,undefined src/cpu.cpp -o build/cpu-sanitize; ./build/cpu-sanitize ;;
 gpu) nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 src/qk.cu -o build/qk ;;
 *) exit 2 ;;
esac
