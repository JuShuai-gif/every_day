#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库独立机制实验；不下载模型或安装作者依赖。
exec "${PYTHON:-python3}" example.py
