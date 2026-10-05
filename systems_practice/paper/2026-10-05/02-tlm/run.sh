#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅运行标准库小实验，不下载权重。
python3 example.py
