#!/bin/sh
set -eu
cd "$(dirname "$0")"
variant=${1:-warp}
case "$variant" in base|warp) ;; *) exit 2 ;; esac
ncu --version
mkdir -p build
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
sh build.sh gpu
# 程序预热20次后只在ProfilerStart窗口采集一个指定kernel。
ncu --profile-from-start off --kernel-name "regex:qk_$variant" --launch-count 1 --set basic -f -o "build/qk-$variant" ./build/qk "$variant"
ncu --import "build/qk-$variant.ncu-rep" --page details > "build/qk-$variant-summary.txt"
