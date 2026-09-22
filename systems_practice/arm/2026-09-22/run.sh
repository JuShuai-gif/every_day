#!/bin/sh
set -eu
# 只读环境和编译宏，不安装依赖，不执行可选 ARM 指令。
lesson_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
exec python3 "$lesson_dir/inspect_target.py"
