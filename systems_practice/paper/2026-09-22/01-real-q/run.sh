#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# C++17 编译日志进入 stderr，stdout 只输出实验 JSON。
build="$here/build/cpp-${SANITIZE:-OFF}"
cmake -S "$here" -B "$build" -DCMAKE_BUILD_TYPE=Release -DSANITIZE="${SANITIZE:-OFF}" >&2
cmake --build "$build" --parallel 2 >&2
exec "$build/paper_example"
