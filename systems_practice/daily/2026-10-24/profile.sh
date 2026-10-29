#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh thor
mkdir -p build/profile
nvcc --version > build/profile/nvcc.txt
ncu --version > build/profile/ncu.txt
ncu --list-sections > build/profile/sections.txt
ncu --query-metrics > build/profile/metrics.txt
# 先正确性一次、20次warmup，然后从被选kernel的第22次开始采一个launch。
for variant in base warp; do
  ncu --target-processes all --kernel-name-base function \
    --kernel-name "regex:rms_${variant}" --launch-skip 21 --launch-count 1 \
    --clock-control none --section LaunchStats --section Occupancy \
    --section SpeedOfLight --section MemoryWorkloadAnalysis \
    --section SchedulerStats --section WarpStateStats --section SourceCounters \
    --export "build/profile/$variant" --force-overwrite \
    ./build/rmsnorm 257 513 "$variant"
done
nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110 --ptx src/rmsnorm.cu -o build/profile/rmsnorm.ptx
nvcc -std=c++17 -O3 -lineinfo --fmad=false -arch=sm_110 --cubin -Xptxas=-v src/rmsnorm.cu -o build/profile/rmsnorm.cubin 2> build/profile/ptxas.txt
cuobjdump --dump-sass build/profile/rmsnorm.cubin > build/profile/rmsnorm.sass.txt
nvdisasm -g build/profile/rmsnorm.cubin > build/profile/rmsnorm.lines.sass.txt
