#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 缓存源码需固定commit并真实checkout；不自动下载/安装/修改上游实现。
if [ -z "${GPTQ_SOURCE:-}" ]; then
  echo 'UNVERIFIED: set GPTQ_SOURCE to verified checkout in systems_practice/.tmp/quant_sources' >&2
  exit 2
fi
export PYTHONDONTWRITEBYTECODE=1
export TORCH_CUDA_ARCH_LIST=11.0
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
exec python3 "$here/example.py" --source "$GPTQ_SOURCE" "$@"
