#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 使用固定提交的原始模块；不安装、不下载模型；缺依赖明确失败。
: "${SPINQUANT_ROOT:?Set SPINQUANT_ROOT to the pinned source snapshot or checkout}"
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1
python3 example.py
