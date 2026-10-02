#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 只运行标准库小例子，不下载权重或依赖。
exec "${PYTHON:-python3}" "$root/example.py"
