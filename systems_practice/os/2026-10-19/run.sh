#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${MODE:-release}
# 先构建再运行；日志由调用者保存，避免覆盖历史验证。
sh build.sh "$mode"
exec "build/$mode/practice" "$@"
