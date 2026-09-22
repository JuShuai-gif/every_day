#!/bin/sh
set -eu
# 固定到当期目录，所有缓存和构建产物留在被忽略的 build 下。
cd "$(dirname "$0")"
mode=${1:-cpu}
case "$mode" in
  cpu) sanitizer=none; build_type=Release ;;
  sanitize) sanitizer=address; build_type=Debug ;;
  tsan) sanitizer=thread; build_type=Debug ;;
  *) echo 'usage: run.sh cpu|sanitize|tsan' >&2; exit 2 ;;
esac
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE="$build_type" -DSANITIZER="$sanitizer"
cmake --build "build/$mode" --parallel 2
ctest --test-dir "build/$mode" --output-on-failure
if [ "$mode" = cpu ]; then
  "build/$mode/pool_check" bench
fi
