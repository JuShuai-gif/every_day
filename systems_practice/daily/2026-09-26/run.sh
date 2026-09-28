#!/bin/sh
set -eu
# 在本课目录执行；构建/中间输出仅放忽略目录，不安装依赖。
cd "$(dirname "$0")"
mode=${1:-cpu}
case "$mode" in cpu) args='-DENABLE_CUDA=OFF -DSANITIZER=OFF'; bin=cpu;; sanitize) args='-DENABLE_CUDA=OFF -DSANITIZER=ON'; bin=cpu;; thor) args='-DENABLE_CUDA=ON -DSANITIZER=OFF'; bin=softmax;; *) exit 2;; esac
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release $args
cmake --build "build/$mode" -j 2
"build/$mode/$bin"
