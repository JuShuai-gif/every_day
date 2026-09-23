#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
case "$mode" in
  release) extra='-DSANITIZE=OFF'; arg=--bench ;;
  sanitize) extra='-DSANITIZE=ON'; arg=--check ;;
  base) extra='-DBASE_ARM=ON'; arg=--check ;;
  *) echo 'usage: run.sh [release|sanitize|base]' >&2; exit 2 ;;
esac
# 构建物隔离在忽略目录；运行日志由调用方保存。
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release "$extra"
cmake --build "build/$mode" -j 2
"build/$mode/q8_dot" "$arg"
