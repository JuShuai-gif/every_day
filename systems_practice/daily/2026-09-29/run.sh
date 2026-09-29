#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 构建目录被忽略；日志由调用方保存到results的新文件。
mode=${1:-cpu}
case "$mode" in
  cpu) cmake -S . -B build/cpu -DCMAKE_BUILD_TYPE=Release; cmake --build build/cpu; ./build/cpu/cpu_check ;;
  sanitize) cmake -S . -B build/sanitize -DCMAKE_BUILD_TYPE=Debug -DSANITIZE=ON; cmake --build build/sanitize; ./build/sanitize/cpu_check ;;
  board) cmake -S . -B build/board -DCMAKE_BUILD_TYPE=Release -DBUILD_RKNN=ON; cmake --build build/board; ./build/board/rknn_output build/tiny.rknn ;;
  *) echo 'usage: run.sh cpu|sanitize|board' >&2; exit 2 ;;
esac
