#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 不安装依赖；使用预先准备的torch2.8.0 CPU环境，导出仅在忽略的build/。
exec "${PYTHON:-python3}" "$root/example.py"
