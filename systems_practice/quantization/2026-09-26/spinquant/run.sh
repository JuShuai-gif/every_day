#!/bin/sh
set -eu
# 在本课目录执行；构建/中间输出仅放忽略目录，不安装依赖。
cd "$(dirname "$0")"
exec "${PYTHON:-python3}" upstream_api.py --source "${QUANT_SOURCE:-../../../.tmp/quant_sources/spinquant-pinned}" --out build/native
