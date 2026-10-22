#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 不安装依赖；SPQ小例需要现有NumPy，LAST只用标准库。
exec "${PYTHON:-python3}" example.py
