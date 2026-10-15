#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh "${1:-cpu}"
if [ "${1:-cpu}" = thor ]; then
  ./build/transpose check
  # 每个进程只计一种实现，避免分析器混入其他kernel。
  ./build/transpose 0
  ./build/transpose 1
  ./build/transpose 2
else
  ./build/cpu_check
fi
