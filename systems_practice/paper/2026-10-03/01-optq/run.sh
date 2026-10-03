#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库机制例，不安装模型依赖。
PYTHONDONTWRITEBYTECODE=1 python3 example.py
