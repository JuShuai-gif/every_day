#!/bin/sh
set -eu

# 使用仓库根目录的 .clang-format，统一每日练习中的 C/C++/CUDA 源码风格。
formatter=$(command -v clang-format || true)
# Xcode Command Line Tools 在 macOS 上可能只通过 xcrun 暴露 clang-format。
if [ -z "$formatter" ] && command -v xcrun >/dev/null 2>&1; then
  formatter=$(xcrun --find clang-format 2>/dev/null || true)
fi
if [ -z "$formatter" ]; then
  echo "clang-format is required; install LLVM/clang-format before formatting." >&2
  exit 127
fi

find systems_practice -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.cxx' -o -name '*.cu' -o -name '*.h' -o -name '*.hpp' \) -print0 |
  xargs -0 -r "$formatter" -i -style=file
