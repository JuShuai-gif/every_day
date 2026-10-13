#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 使用已有环境；不安装包、不下载模型。PYTHON可指向已配置解释器。
exec "${PYTHON:-python3}" example.py
