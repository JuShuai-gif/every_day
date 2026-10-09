#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
case "$mode" in
  cpu) flags='-DENABLE_CUDA=OFF -DSANITIZER=OFF'; binary=cpu_check ;;
  sanitize) flags='-DENABLE_CUDA=OFF -DSANITIZER=ON'; binary=cpu_check ;;
  thor) flags='-DENABLE_CUDA=ON -DSANITIZER=OFF'; binary=softmax ;;
  *) echo 'usage: run.sh cpu|sanitize|thor' >&2; exit 2 ;;
esac
cmake -S . -B "build/$mode" -DCMAKE_BUILD_TYPE=Release $flags
cmake --build "build/$mode" -j 2
"build/$mode/$binary"
