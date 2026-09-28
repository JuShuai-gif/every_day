#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
case "$mode" in
  release) sanitizer='' ;;
  sanitize) sanitizer='address,undefined' ;;
  tsan) sanitizer='thread' ;;
  *) echo 'usage: run.sh release|sanitize|tsan' >&2; exit 2 ;;
esac
# 所有缓存限定在当期忽略的 build 目录。
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release -DSANITIZER="$sanitizer"
cmake --build "build/$mode" -j 2
"build/$mode/edge_deployment"
