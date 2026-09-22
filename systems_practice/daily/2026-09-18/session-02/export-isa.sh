#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for tool in nvcc cuobjdump cmake; do
  command -v "$tool" >/dev/null 2>&1 || { echo "$tool missing; no generated PTX/SASS"; exit 127; }
done
# 所有产物固定Thor SM110，不接受其他目标或专属后缀。
cmake -S "$root" -B "$root/build/gpu" -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110 -DCMAKE_BUILD_TYPE=Release
cmake --build "$root/build/gpu" -j 2
out=$(mktemp -d "$root/build/isa-sm110-XXXXXX")
nvcc --version > "$out/toolchain.txt"
cmake -LA -N "$root/build/gpu" > "$out/cmake.txt"
cmake -E sha256sum "$root/build/gpu/quant_gpu" "$root/src/quant_gemm.cu" "$root/src/quant.hpp" > "$out/sha256.txt"
cuobjdump --dump-ptx "$root/build/gpu/quant_gpu" > "$out/executable.ptx.txt"
cuobjdump --dump-sass "$root/build/gpu/quant_gpu" > "$out/executable.sass.txt"
printf 'nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/quant_gemm.cu\n' > "$out/commands.txt"
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx "$root/src/quant_gemm.cu" -o "$out/generated.ptx" > "$out/compile.txt" 2>&1
printf 'ISA evidence: %s\n' "$out"
