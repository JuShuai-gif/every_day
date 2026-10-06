#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 不安装依赖；原生与独立演示明确分开。
case "${1:-native}" in
 native) exec python3 example.py --device cpu ;;
 independent) exec python3 independent.py ;;
 thor) export TORCH_CUDA_ARCH_LIST=11.0; exec python3 example.py --device cuda ;;
 *) echo 'native|independent|thor' >&2; exit 2 ;;
esac
