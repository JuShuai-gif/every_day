#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 调用者提供已核实commit的本地源码；绝不自动安装依赖/下载模型。
: "${KIVI_REPO:?set KIVI_REPO to the pinned local checkout}"
exec python3 native_example.py --repo "$KIVI_REPO" --device "${DEVICE:-cpu}"
