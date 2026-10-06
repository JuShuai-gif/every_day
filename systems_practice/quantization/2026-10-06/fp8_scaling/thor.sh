#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# Thor唯一执行目标；工具链、驱动和性能计数器需板端实测。
nvcc --version
nvcc --list-gpu-code | grep -w sm_110
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 codec.cu -o build/codec
case "${1:-run}" in
 run) ./build/codec scalar; ./build/codec vector ;;
 isa)
  nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx codec.cu -o build/codec.ptx
  cuobjdump --dump-sass build/codec > build/codec.sass
  ;;
 profile)
  ncu --version
  ncu --list-sections > build/sections.txt
  ncu --query-metrics > build/metrics.txt
  # 前7小形状 + 1大形状校验 + 20预热 = 28匹配launch。
  ncu --kernel-name 'regex:vector_encode' --launch-skip 28 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -o build/vector ./build/codec vector
  ncu --kernel-name 'regex:scalar_encode' --launch-skip 28 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -o build/scalar ./build/codec scalar
  ;;
 *) echo 'run|isa|profile' >&2; exit 2 ;;
esac
