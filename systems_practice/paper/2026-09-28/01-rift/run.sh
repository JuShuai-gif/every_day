#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库小机制例子，无模型和数据下载。
exec python3 example.py
