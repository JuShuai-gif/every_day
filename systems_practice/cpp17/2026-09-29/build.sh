#!/bin/sh
set -eu
lesson_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-release}
case "$mode" in
  release) set -- -O2 ;;
  sanitize) set -- -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer ;;
  *) echo "usage: sh build.sh [release|sanitize]" >&2; exit 2 ;;
esac
# 构建产物仅放本课被忽略的目录；不安装任何依赖。
mkdir -p "$lesson_dir/.tmp/$mode"
"${CXX:-c++}" -std=c++17 -Wall -Wextra -Wpedantic -Werror "$@" \
  "$lesson_dir/src/main.cpp" -o "$lesson_dir/.tmp/$mode/optional_config"
