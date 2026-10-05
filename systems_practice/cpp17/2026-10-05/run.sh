#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
if [ "$#" -gt 0 ]; then shift; fi
# 执行对应构建产物，不安装任何依赖。
sh build.sh "$mode"
"./build/$mode" "$@"
