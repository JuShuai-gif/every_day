#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-native}
# check/packing 只验证独立 C++ 后端，不能证明原生量化算法运行成功。
case "$mode" in
  check|packing) exec sh "$here/../../cpp/run.sh" check ;;
  native) ;;
  *) echo 'usage: run.sh native|check' >&2; exit 2 ;;
esac
sh "$here/../../cpp/run.sh" build
export QUANT_CPP="$here/../../cpp/build/cpp-${SANITIZE:-OFF}/quant_cpu"
mkdir -p "$here/build/tmp"
export TMPDIR="$here/build/tmp"
export PYTHONDONTWRITEBYTECODE=1
export HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1 HF_DATASETS_OFFLINE=1
source_dir=${AWQ_SOURCE:-"$here/../../../.tmp/quant_sources/awq-pinned/repo"}
exec "${PYTHON:-python3}" "$here/upstream_api.py" --source "$source_dir"
