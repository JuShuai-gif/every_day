#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅标准库小张量，无模型下载。
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
