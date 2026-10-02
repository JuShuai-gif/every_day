#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build/reports
command -v ncu >/dev/null 2>&1 || { echo "ncu missing; Thor profiling not performed" >&2; exit 127; }
ncu --version
# 先列出本机可用section/metric，不能假定跨版本指标名称不变。
ncu --list-sections > build/reports/sections.txt
ncu --query-metrics > build/reports/metrics.txt
for mode in 0 1 2; do
 ncu --target-processes all --kernel-name-base demangled --kernel-name 'regex:transpose_.*' --launch-skip 11 --launch-count 1 --set full --force-overwrite -o "build/reports/mode-$mode" build/gpu/transpose "$mode"
done
