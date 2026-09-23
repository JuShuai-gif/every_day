#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 默认纯PyTorch算法/模型路径，不编译C++或CUDA扩展，不下载模型。
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" upstream_api.py
