#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
compiler=${CXX:-c++}
"$compiler" --version
uname -sm
# 严格 C++17；Sanitizer 不负责判断合法分配中的错误逻辑地址。
"$compiler" -std=c++17 -Wall -Wextra -Wpedantic -Werror -O2 stride_counterexample.cpp -o build/release
./build/release
"$compiler" -std=c++17 -Wall -Wextra -Wpedantic -Werror -O1 -g -fno-omit-frame-pointer -fsanitize=address,undefined stride_counterexample.cpp -o build/sanitized
./build/sanitized
