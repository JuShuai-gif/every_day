#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库独立机制例子，不下载模型。
exec python3 example.py
