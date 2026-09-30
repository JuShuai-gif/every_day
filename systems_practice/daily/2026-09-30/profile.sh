#!/bin/sh
set -eu
cd "$(dirname "$0")"
v=${1:-async2}
case "$v" in sync|async2) ;; *) exit 2 ;; esac
mkdir -p build
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
sh build.sh gpu
# profiler-start区间只有预热之后的1次目标launch；避免硬编码skip数量。
ncu --profile-from-start off --kernel-name-base function --kernel-name "regex:gemm_${v}" --launch-count 1 --set full -o "build/${v}" ./build/gemm profile "$v"
ncu --import "build/${v}.ncu-rep" --page source > "build/${v}-source.txt"
