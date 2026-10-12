#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 独立小例子只需Python标准库，不下载权重。
exec "${PYTHON:-python3}" example.py
