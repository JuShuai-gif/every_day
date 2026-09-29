#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库CPU机制实验，不下载模型、不调用CUDA。
PYTHONDONTWRITEBYTECODE=1 ${PYTHON:-python3} example.py
