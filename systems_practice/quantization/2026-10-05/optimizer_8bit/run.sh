#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 原生示例默认执行；独立数学例子必须显式选择，不能冒充原生成功。
case "${1:-native}" in
 native) python3 native.py ;;
 independent) python3 independent.py ;;
 gpu) sh build.sh; ./build/codec ;;
 *) echo 'usage: run.sh native|independent|gpu' >&2; exit 2 ;;
esac
