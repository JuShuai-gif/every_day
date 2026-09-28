#!/bin/sh
set -eu
# 在本课目录执行；构建/中间输出仅放忽略目录，不安装依赖。
cd "$(dirname "$0")"
mode=${1:-release}
case "$mode" in release) san='' ;; sanitize) san=address,undefined ;; *) exit 2;; esac
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release -DSANITIZER="$san"
cmake --build "build/$mode" -j 2
"build/$mode/rollback"
