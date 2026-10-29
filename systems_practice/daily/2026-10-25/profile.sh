#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 在Thor执行；先发现当前版本支持的section与指标。
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
sh build.sh thor
for mode in base warp; do
    ncu --kernel-name-base function --kernel-name "regex:rms_${mode}" \
        --launch-skip 21 --launch-count 1 --clock-control none \
        --section SpeedOfLight --section MemoryWorkloadAnalysis \
        --section LaunchStats --section Occupancy --section SchedulerStats \
        --section WarpStateStats --section SourceCounters \
        -o "build/rms-${mode}" ./build/rmsnorm 257 513 "$mode"
done
# 将报告复制到装有UI的主机，执行ncu-ui build/rms-warp.ncu-rep。
