#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
format=${1:-W4A4}; method=${2:-outlier}; kernel=${3:-tiled}
# 程序只在cudaProfilerStart/Stop之间采一个kernel，无需猜launch序号。
command -v ncu >/dev/null 2>&1 || { echo 'ncu missing; no Thor measurements'; exit 127; }
cmake -S "$root" -B "$root/build/gpu" -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110 -DCMAKE_BUILD_TYPE=Release
cmake --build "$root/build/gpu" -j 2
report=$(mktemp -d "$root/build/ncu-XXXXXX")
ncu --version > "$report/version.txt"
ncu --list-sections > "$report/sections.txt"
ncu --query-metrics > "$report/metrics.txt"
cmake -E sha256sum "$root/build/gpu/quant_gpu" > "$report/binary-sha256.txt"
set --
for section in SpeedOfLight LaunchStats Occupancy MemoryWorkloadAnalysis SchedulerStats WarpStateStats SourceCounters; do
  grep -w "$section" "$report/sections.txt" >/dev/null || { echo "missing section $section"; exit 2; }
  set -- "$@" --section "$section"
done
ncu --profile-from-start off --kernel-name-base demangled \
  --kernel-name 'regex:.*(quant_baseline|quant_tiled|fp32_gemm).*' --launch-count 1 \
  "$@" -o "$report/report" "$root/build/gpu/quant_gpu" --profile "$format" "$method" "$kernel" \
  > "$report/collection.txt" 2>&1
[ -s "$report/report.ncu-rep" ] || { echo "no report; inspect $report"; exit 1; }
ncu --import "$report/report.ncu-rep" --page details > "$report/details.txt"
printf 'Open: ncu-ui "%s/report.ncu-rep"\n' "$report"
