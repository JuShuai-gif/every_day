#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-native}
# check/packing 只验证独立 C++ 后端，不能证明原生量化算法运行成功。
case "$mode" in
  check|packing) exec sh "$here/../../cpp/run.sh" check ;;
  native) export QUANT_WITH_CPP=0 ;;
  native-cpp) export QUANT_WITH_CPP=1 ;;
  *) echo 'usage: run.sh native|native-cpp|check' >&2; exit 2 ;;
esac
# 算法/精度学习默认只依赖 Python/PyTorch；底层实验才构建 C++。
if [ "$QUANT_WITH_CPP" = 1 ]; then
  sh "$here/../../cpp/run.sh" build
  export QUANT_CPP="$here/../../cpp/build/cpp-${SANITIZE:-OFF}/quant_cpu"
fi
mkdir -p "$here/build/tmp"
export TMPDIR="$here/build/tmp"
export PYTHONDONTWRITEBYTECODE=1
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_DATASETS_OFFLINE=1
if [ -z "${GPTQ_SOURCE:-}" ]; then
  echo 'UNVERIFIED: set GPTQ_SOURCE to a verified pinned checkout' >&2
  exit 2
fi
export TORCH_CUDA_ARCH_LIST=11.0
exec "${PYTHON:-python3}" "$here/upstream_api.py" --source "$GPTQ_SOURCE"
