#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 默认使用真实固定commit的少量源码快照；不联网、不安装、不下载权重。
practice=$(cd ../../.. && pwd)
source_dir=${SMOOTHQUANT_SOURCE:-$practice/.tmp/quant_sources/smoothquant-1cymig_n/source}
test -f "$source_dir/smoothquant/smooth.py"
export PYTHONPATH="$source_dir${PYTHONPATH:+:$PYTHONPATH}"
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
