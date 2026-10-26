#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh thor
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
# 先核实当前版本存在这些section；权限和架构支持失败不得当作零事件。
ncu --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats \
  --kernel-name-base function --kernel-name 'regex:affine_fused4' --launch-skip 21 --launch-count 1 \
  --export build/fused --force-overwrite ./build/thor 65539 1
ncu --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats \
  --kernel-name-base function --kernel-name 'regex:(scale_baseline|bias_baseline)' --launch-skip 40 --launch-count 2 \
  --export build/baseline --force-overwrite ./build/thor 65539 0
ncu --import build/fused.ncu-rep --page source > build/fused-source.txt
