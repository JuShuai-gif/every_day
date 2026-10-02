#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 不安装依赖；不访问模型Hub。导出的小二进制只留在忽略的build目录。
python3 example.py
