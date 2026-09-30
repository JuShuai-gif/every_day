#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库现成例子，无模型下载。
export PYTHONDONTWRITEBYTECODE=1
python3 example.py
