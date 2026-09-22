#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
sanitizer=
operation=check
case "$mode" in
  cpu) operation=bench ;;
  check) ;;
  sanitize) sanitizer=address ;;
  tsan) sanitizer=thread ;;
  *) echo 'usage: run.sh cpu|check|sanitize|tsan' >&2; exit 2 ;;
esac
# 构建缓存在忽略目录，日志由调用者保存；不安装任何依赖。
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release -DSANITIZER="$sanitizer"
cmake --build "build/$mode" -j 2
"build/$mode/cache_counters" "$operation"
