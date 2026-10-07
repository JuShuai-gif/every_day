#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 不安装依赖；native入口要求已有ModelOpt/PyTorch与Thor。
case "${1:-independent}" in
 independent) exec python3 independent.py ;;
 native) export TORCH_CUDA_ARCH_LIST=11.0; exec "${PYTHON:-python3}" example.py ;;
 *) echo 'usage: run.sh independent|native' >&2; exit 2 ;;
esac
