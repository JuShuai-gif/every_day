#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 默认原生示例；独立数学例必须显式选择，避免把替代实验标成原生运行。
case "${1:-native}" in
 native) exec "${PYTHON:-python3}" native.py ;;
 independent) exec "${PYTHON:-python3}" independent.py ;;
 *) echo 'expected native or independent' >&2; exit 2 ;;
esac
