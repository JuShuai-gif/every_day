#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 在Thor执行；工具版本和平台元组必须随结果归档。
nvcc --version > build/nvcc-version.txt
ncu --version > build/ncu-version.txt
nvcc --list-gpu-code > build/gpu-targets.txt
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
CUDA_BUILD=1 sh build.sh
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/gemm.cu -o build/gemm-sm110.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin src/gemm.cu -o build/gemm-sm110.cubin
cuobjdump --dump-sass build/gemm-sm110.cubin > build/gemm-sm110.sass.txt
nvdisasm -g build/gemm-sm110.cubin > build/gemm-sm110.nvdisasm.txt
# case-16是M31,K33,N17 W4A4；过滤后的第11次launch为预热后的第一次计时。
for variant in baseline tiled; do
 ncu --kernel-name "regex:qgemm_${variant}" --launch-skip 10 --launch-count 1 \
  --clock-control none --section SpeedOfLight --section MemoryWorkloadAnalysis \
  --section LaunchStats --section SchedulerStats --section SourceCounters \
  -o "build/${variant}" ./build/gemm build/case-16.bin "$variant"
done
