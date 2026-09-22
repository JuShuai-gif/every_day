#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 原生包依赖缺失会真实失败；不自动安装、下载或替换上游模块。
source_dir=${AWQ_SOURCE:-"$here/../../../.tmp/quant_sources/awq-pinned/repo"}
export PYTHONDONTWRITEBYTECODE=1
exec python3 "$here/example.py" --source "$source_dir" "$@"
