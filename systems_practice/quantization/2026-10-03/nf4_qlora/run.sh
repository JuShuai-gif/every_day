#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 原生API需要已安装的匹配依赖；禁止本脚本自动安装。
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 PYTHONDONTWRITEBYTECODE=1
if [ "$#" -eq 0 ]; then
  set -- --device cpu
fi
exec python3 example.py "$@"
