#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库现成例子，不安装依赖或下载模型。
exec python3 example.py
