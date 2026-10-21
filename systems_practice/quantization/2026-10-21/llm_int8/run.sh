#!/bin/sh
set -eu
cd "$(dirname "$0")"
# PYTHON可指定已有合适环境；不安装依赖。缓存全部位于被忽略的build。
mkdir -p build
export TORCHINDUCTOR_CACHE_DIR="$PWD/build/inductor"
export TRITON_CACHE_DIR="$PWD/build/triton"
exec "${PYTHON:-python3}" example.py "$@"
