#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库数学示例，无模型下载和依赖安装。
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
