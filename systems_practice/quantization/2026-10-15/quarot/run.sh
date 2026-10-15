#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 原生导入保留真实依赖，缺库时明确失败，不注入假模块或自动安装。
: "${QUAROT_SOURCE:?Set QUAROT_SOURCE to the pinned repository/source snapshot}"
PYTHONDONTWRITEBYTECODE=1 "${PYTHON:-python3}" example.py --source "$QUAROT_SOURCE" --output build/native
