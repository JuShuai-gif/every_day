#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库机制例，不下载模型或安装依赖。
PYTHONDONTWRITEBYTECODE=1 "${PYTHON:-python3}" example.py
