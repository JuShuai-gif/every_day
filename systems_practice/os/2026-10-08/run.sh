#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 先构建再运行，构建失败不会使用旧二进制。
sh build.sh
exec "./build/${MODE:-release}"
