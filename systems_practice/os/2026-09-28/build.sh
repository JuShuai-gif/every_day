#!/usr/bin/env bash
set -euo pipefail
lesson=$(cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-release}
build_dir=${2:?Provide an output directory under this lesson/build}
case "$build_dir" in "$lesson"/build/*) ;; *) echo 'Output must be under lesson/build' >&2; exit 2;; esac
flags=(-std=c++17 -Wall -Wextra -Wpedantic -Werror)
case "$mode" in
  release) flags+=(-O2) ;;
  sanitize) flags+=(-O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined) ;;
  *) echo 'Use release or sanitize' >&2; exit 2 ;;
esac
# 只使用已安装工具链，不安装依赖；构建产物保留在忽略目录。
mkdir -p "$build_dir"
"${CXX:-c++}" "${flags[@]}" "$lesson/src/fd_observe.cpp" -o "$build_dir/fd_observe"
