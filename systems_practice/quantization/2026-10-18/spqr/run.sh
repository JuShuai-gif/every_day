#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 必须指向固定commit的已获取源码目录；不安装、不下载模型。
source_dir=${SPQR_SOURCE:-../../../.tmp/quant_sources/spqr-rwib2na4/source}
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py --source "$source_dir" --output build
