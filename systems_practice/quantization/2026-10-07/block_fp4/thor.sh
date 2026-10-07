#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 每个CUDA产物固定sm_110，绝不回退或添加a后缀。
case "${1:-build}" in
 build) nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v decode.cu -o build/decode ;;
 run) exec ./build/decode ;;
 isa)
  nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx decode.cu -o build/decode.ptx
  cuobjdump --dump-sass --print-line-info build/decode > build/decode.sass ;;
 query) ncu --version; ncu --list-sections; ncu --query-metrics ;;
 profile)
  # 每个匹配kernel：1次检查＋10次预热后，只采集第1次测量launch。
  ncu --kernel-name-base function --kernel-name 'regex:decode_pairs' --launch-skip 11 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -f -o build/pairs ./build/decode profile
  ncu --kernel-name-base function --kernel-name 'regex:decode_baseline' --launch-skip 11 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -f -o build/baseline ./build/decode profile ;;
 *) echo 'usage: thor.sh build|run|isa|query|profile' >&2; exit 2 ;;
esac
