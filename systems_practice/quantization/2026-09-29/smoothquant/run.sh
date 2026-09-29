#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 必须显式提供已核验的干净源仓库；不会自行安装或下载。
: "${SMOOTHQUANT_SOURCE:?Set SMOOTHQUANT_SOURCE to your verified clean checkout}"
PYTHONDONTWRITEBYTECODE=1 ${PYTHON:-python3} example.py --source "$SMOOTHQUANT_SOURCE"
