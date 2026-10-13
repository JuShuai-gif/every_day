#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅标准库，不下载模型或安装依赖。
exec "${PYTHON:-python3}" example.py
