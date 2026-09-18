#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
variant=${1:-optimized}
level=${2:-basic}
case "$variant" in baseline|async|optimized) ;; *) echo 'invalid variant' >&2; exit 2 ;; esac
case "$level" in basic|detail) ;; *) echo 'usage: profile.sh [baseline|async|optimized] [basic|detail]' >&2; exit 2 ;; esac
# 先检查工具，缺失时不能生成貌似有效的分析报告。
command -v ncu >/dev/null 2>&1 || { echo 'ncu unavailable; no GPU profile collected' >&2; exit 127; }
binary="$root/build/gpu/ptx_pool"
[ -x "$binary" ] || { echo 'build GPU target first with run.sh gpu' >&2; exit 2; }
# 重建固定的 Thor SM110 目标，防止采集旧架构/旧源码的缓存程序。
cmake -S "$root" -B "$root/build/gpu" -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110 -DCMAKE_BUILD_TYPE=Release
cmake --build "$root/build/gpu" -j 2
# 每次使用新目录，保留旧报告；二进制报告位于被忽略的 build/。
report_dir=$(mktemp -d "$root/build/ncu-$variant-XXXXXX")
ncu --version > "$report_dir/version.txt"
ncu --list-sections > "$report_dir/sections.txt"
ncu --query-metrics > "$report_dir/metrics.txt"
cmake -E sha256sum "$binary" > "$report_dir/binary-sha256.txt"
set -- --set basic
if [ "$level" = detail ]; then
  set --
  for section in SpeedOfLight LaunchStats Occupancy MemoryWorkloadAnalysis SchedulerStats WarpStateStats SourceCounters; do
    if ! grep -w "$section" "$report_dir/sections.txt" >/dev/null; then
      echo "section $section unavailable; inspect $report_dir/sections.txt" >&2
      exit 2
    fi
    set -- "$@" --section "$section"
  done
fi
# 专用 --profile 入口预热20次，然后 start/stop 范围只包住一个选定 kernel。
# 宽名称过滤允许不同编译器的模板名格式；具体变体由程序参数决定。
ncu --profile-from-start off --kernel-name-base demangled --kernel-name 'regex:.*pool.*' \
  --launch-count 1 "$@" -o "$report_dir/report" "$binary" --profile "$variant" \
  > "$report_dir/collection.txt" 2>&1
[ -s "$report_dir/report.ncu-rep" ] || { echo 'no report produced; inspect collection.txt' >&2; exit 1; }
ncu --import "$report_dir/report.ncu-rep" --page details > "$report_dir/details.txt"
printf 'Report: %s\nOpen: ncu-ui "%s"\n' "$report_dir" "$report_dir/report.ncu-rep"
