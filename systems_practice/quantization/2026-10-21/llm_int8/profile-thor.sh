#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
./build/mixed
# 无profiler计时独立保存；profile模式只有一个固定shape/阈值mask。
./build/mixed --profile > build/benchmark.txt
ncu --version > build/ncu-version.txt
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
ncu --set basic --launch-count 2 --force-overwrite -o build/discover ./build/mixed --profile
# 每个kernel先有1次检查和5次warmup，所以跳过6次匹配launch。
for name in mixed_baseline mixed_tiled; do
  ncu --kernel-name-base demangled --kernel-name "regex:$name" --launch-skip 6 --launch-count 1 \
    --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats \
    --section Occupancy --section SchedulerStats --section WarpStateStats \
    --force-overwrite -o "build/$name" ./build/mixed --profile
done
