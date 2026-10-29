#!/bin/sh
set -eu

# 在 Mac 上交叉编译 Linux/aarch64。用户须提供工具链和 sysroot，避免误用 macOS SDK。
# 例：CXX=aarch64-linux-gnu-g++ SYSROOT=/path/to/rk3588-sysroot sh build-rk3588.sh
: "${CXX:?set CXX to an aarch64 Linux C++ compiler}"
: "${SYSROOT:?set SYSROOT to the RK3588 Linux sysroot}"
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
build_dir="$root/build/rk3588"
cmake -S "$root" -B "$build_dir" -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER="$CXX" -DCMAKE_SYSROOT="$SYSROOT"
cmake --build "$build_dir" --parallel
