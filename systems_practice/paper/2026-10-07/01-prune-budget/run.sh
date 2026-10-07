#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅标准库小实验，无安装、模型或数据下载。
exec python3 example.py
