#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库小例子，不下载模型。
python3 example.py
