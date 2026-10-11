#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build/tmp build/torch-cache
export TMPDIR="$PWD/build/tmp"
export TORCH_HOME="$PWD/build/torch-cache"
# CPU 原生算法示例；不下载模型，不自动安装缺失依赖。
exec "${PYTHON:-python3}" upstream_api.py
