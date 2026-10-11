#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库数学观察，不下载作者模型。
exec python3 example.py
