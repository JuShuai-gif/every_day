#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build="$here/build/cpp-${SANITIZE:-OFF}"
# 构建输出走 stderr，便于保存 stdout 的真实 JSON。
cmake -S "$here" -B "$build" -DCMAKE_BUILD_TYPE=Release -DSANITIZE="${SANITIZE:-OFF}" >&2
cmake --build "$build" --parallel 2 >&2
if [ "${1:-check}" = build ]; then exit 0; fi
exec "$build/quant_cpu" --self-test
