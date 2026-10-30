#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 先查询本机版本提供的section和metric，再看GPU源码热点。
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
for kernel in gemv_baseline gemv_warp; do
 ncu --kernel-name-base function --kernel-name "regex:$kernel" --launch-skip 11 --launch-count 1 --set full -o "build/$kernel" ./build/gemv profile
 ncu --import "build/$kernel.ncu-rep" --page source > "build/$kernel-source.txt"
done
