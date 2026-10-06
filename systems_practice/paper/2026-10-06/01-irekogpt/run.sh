#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库独立机制示例，不安装依赖或下载模型。
exec python3 example.py
