#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 标准库独立机制示例，无下载或安装。
exec python3 example.py
