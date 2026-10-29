#!/bin/sh
set -eu
r=$(CDPATH= cd -- "$(dirname "$0")" && pwd);mkdir -p "$r/build";case ${1:-cpu} in cpu)c++ -std=c++17 -Wall -Wextra -Werror -O2 "$r/src/cpu_check.cpp" -o "$r/build/cpu";;sanitize)c++ -std=c++17 -O1 -g -fsanitize=address,undefined "$r/src/cpu_check.cpp" -o "$r/build/sanitize";;rknn): "${RKNN_INCLUDE:?}";: "${RKNN_LIB:?}";c++ -std=c++17 -Wall -Wextra -I"$RKNN_INCLUDE" "$r/src/rknn_runtime.cpp" -L"$RKNN_LIB" -lrknnrt -o "$r/build/rknn";;*)exit 2;;esac
