#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 只用 Python 标准库，现成机制例子，不下载语料或模型。
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
