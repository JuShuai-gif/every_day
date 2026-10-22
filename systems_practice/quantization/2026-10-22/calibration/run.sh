#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 原生例子明确要求已准备好的torch；不自动安装，也不联网加载模型。
exec "${PYTHON:-python3}" example.py
