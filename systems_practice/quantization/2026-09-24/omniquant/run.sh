#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 默认仅运行 CPU 上游算法，不自动安装依赖、获取模型或构建 CUDA 扩展。
source_dir=${OMNIQUANT_SOURCE:-../../../.tmp/quant_sources/omniquant-pinned}
python=${PYTHON:-python3}
exec "$python" upstream_api.py --source "$source_dir" --out build/native
