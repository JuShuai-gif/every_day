#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 禁止隐式下载模型/数据；仅执行 CPU 原生量化 API。缺依赖直接失败。
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_DATASETS_OFFLINE=1
export PYTHONDONTWRITEBYTECODE=1
exec "${PYTHON:-python3}" example.py
