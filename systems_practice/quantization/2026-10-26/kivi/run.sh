#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅使用已获取的固定源码与已安装依赖；不执行安装或模型下载。
source_dir=${KIVI_SOURCE:-../../../.tmp/quant_sources/kivi-4qwpqaj4/source}
exec "${PYTHON:-python3}" example.py --source "$source_dir"
