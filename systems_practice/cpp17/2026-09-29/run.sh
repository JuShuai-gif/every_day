#!/bin/sh
set -eu
lesson_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-release}
# 编译失败立即退出，不把旧二进制的结果当成此次验证。
sh "$lesson_dir/build.sh" "$mode"
"$lesson_dir/.tmp/$mode/optional_config"
