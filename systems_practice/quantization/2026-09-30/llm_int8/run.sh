#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 使用已准备的环境；不安装依赖、不下载模型。Mac未支持不自动替换后端。
export PYTHONDONTWRITEBYTECODE=1
export TORCH_CUDA_ARCH_LIST=11.0
python3 example.py --device "${1:-cpu}"
