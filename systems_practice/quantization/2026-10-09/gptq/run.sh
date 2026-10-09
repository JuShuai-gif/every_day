#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
: "${GPTQ_SOURCE:?set GPTQ_SOURCE to a checked-out fixed GPTQ source tree}"
# 不自动安装 torch/transformers，也不下载模型；目标只能是 Thor SM110。
export PYTHONDONTWRITEBYTECODE=1
export TORCH_CUDA_ARCH_LIST=11.0
exec "${PYTHON:-python3}" "$here/upstream_api.py" --source "$GPTQ_SOURCE"
