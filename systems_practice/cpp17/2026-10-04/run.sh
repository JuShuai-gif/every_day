#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
sh build.sh "$mode"
# 构建失败即停止；验证退出码不能被tee隐藏。
"./build/check-$mode"
