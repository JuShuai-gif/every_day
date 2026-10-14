#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 指向固定commit的源码快照或checkout；不自动下载模型、安装包。
: "${OMNIQUANT_SOURCE:?set source snapshot containing quantize/int_linear.py}"
${PYTHON:-python3} example.py --source "$OMNIQUANT_SOURCE" --output build
