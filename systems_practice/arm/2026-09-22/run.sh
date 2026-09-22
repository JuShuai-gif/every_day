#!/bin/sh
set -eu
# Shell 只负责构建和启动，环境与编译期特性由 C++ 程序直接报告。
lesson_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cmake -S "$lesson_dir" -B "$lesson_dir/build/cpp" \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build "$lesson_dir/build/cpp" --parallel 2
exec "$lesson_dir/build/cpp/inspect_target"
