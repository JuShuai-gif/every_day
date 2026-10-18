#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 构建和运行的失败均向调用方返回。
sh build.sh "${1:-release}"
exec "./build/${1:-release}"
