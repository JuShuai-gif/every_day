#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库小实验，不下载模型，也不执行作者notebook的安装单元。
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
