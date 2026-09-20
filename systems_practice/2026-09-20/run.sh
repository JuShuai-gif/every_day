#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-cpu}
if [ "$#" -gt 0 ]; then shift; fi
case "$mode" in
  cpu) extra="-DENABLE_CUDA=OFF -DSANITIZE=OFF"; exe=cpu_check ;;
  sanitize) extra="-DENABLE_CUDA=OFF -DSANITIZE=ON"; exe=cpu_check ;;
  gpu) extra="-DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110 -DSANITIZE=OFF"; exe=row_reduce ;;
  *) echo "usage: $0 cpu|sanitize|gpu [GPU arguments]" >&2; exit 2 ;;
esac
# 缓存固定在被忽略的build内；无自动安装或模型下载。
cmake -S "$here" -B "$here/build/$mode" -DCMAKE_BUILD_TYPE=Release $extra
cmake --build "$here/build/$mode" -j 2
exec "$here/build/$mode/$exe" "$@"
