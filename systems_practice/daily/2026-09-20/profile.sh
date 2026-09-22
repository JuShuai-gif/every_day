#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
v=${1:-2}
case "$v" in 0|1|2|3|4) ;; *) echo 'variant 0..4 required' >&2; exit 2 ;; esac
command -v ncu >/dev/null || { echo 'ncu missing; Thor profiling unverified' >&2; exit 127; }
mkdir -p "$here/build/profile"
ncu --version > "$here/build/profile/version.txt"
ncu --list-sections > "$here/build/profile/sections.txt"
ncu --query-metrics > "$here/build/profile/metrics.txt"
# 正常运行先验证，再限定profiler API区间只采集一次目标kernel。
sh "$here/run.sh" gpu --variant "$v"
ncu --clock-control none --profile-from-start off --kernel-name-base demangled \
  --kernel-name 'regex:row_reduce.*' --launch-count 1 \
  --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats \
  --section Occupancy --section SchedulerStats --section WarpStateStats --section SourceCounters \
  --force-overwrite --export "$here/build/profile/v$v" \
  "$here/build/gpu/row_reduce" --profile --variant "$v"
ncu --import "$here/build/profile/v$v.ncu-rep" --page details > "$here/build/profile/v$v-details.txt"
