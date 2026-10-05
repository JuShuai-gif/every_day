#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
ncu --version
ncu --list-sections > build/ncu-sections.txt
ncu --query-metrics > build/ncu-metrics.txt
sh build.sh
# 用API范围只采预热后的一个kernel；不同变体使用独立report。
for v in 0 1; do
 ncu --profile-from-start off --kernel-name 'regex:codec_(baseline|optimized)' --launch-count 1 --set full -o "build/codec-$v" ./build/codec --profile "$v"
done
