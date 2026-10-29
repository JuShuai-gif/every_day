#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 先构建，再执行本课完整检查。
sh build.sh
exec "./build/${MODE:-release}" "$@"
