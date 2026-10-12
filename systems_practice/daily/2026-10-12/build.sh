#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 默认只构建CPU合同；RKNN链接使用板端现有SDK，不安装依赖。
if [ "${1:-cpu}" = rknn ]; then
  : "${RKNN_INCLUDE:?set RKNN_INCLUDE}" "${RKNN_LIB:?set RKNN_LIB}"
  "${CXX:-c++}" -std=c++17 -O2 -Wall -Wextra -Werror -I"$RKNN_INCLUDE" src/rknn.cpp -L"$RKNN_LIB" -Wl,-rpath,"$RKNN_LIB" -lrknnrt -o build/rknn_input
else
  "${CXX:-c++}" -std=c++17 -O2 -Wall -Wextra -Werror src/main.cpp -o build/check
fi
