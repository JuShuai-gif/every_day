#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 仅运行标准库机制例，不下载权重。
exec python3 example.py
