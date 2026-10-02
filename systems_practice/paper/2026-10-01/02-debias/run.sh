#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 标准库独立机制实验，无模型/数据下载。
exec "${PYTHON:-python3}" "$root/example.py"
