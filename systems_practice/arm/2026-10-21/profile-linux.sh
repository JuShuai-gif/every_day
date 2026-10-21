#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 只在选定Linux ARM64 CPU上收集；不会修改权限或安装工具。
[ "$(uname -s)" = Linux ] && [ "$(uname -m)" = aarch64 ] || { echo 'Linux aarch64 required' >&2; exit 2; }
: "${CPU:?Set CPU to an allowed core from lscpu/sysfs}"
mkdir -p build
uname -a > build/kernel.txt
lscpu > build/lscpu.txt
perf --version > build/perf-version.txt
perf list > build/perf-list.txt
CXX="${CXX:-g++}" sh build.sh
for mode in scalar neon; do
  taskset -c "$CPU" perf stat -r 5 -e '{cycles:u,instructions:u}' -o "build/$mode.stat.txt" -- ./build/release "$mode"
  taskset -c "$CPU" perf record -e cycles:u -g --call-graph dwarf -o "build/$mode.data" -- ./build/release "$mode"
  perf report --stdio -i "build/$mode.data" > "build/$mode.report.txt"
  perf annotate --stdio -i "build/$mode.data" > "build/$mode.annotate.txt"
done
