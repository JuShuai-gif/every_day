#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
case "$mode" in
cpu|san) sh build.sh "$mode"; "./build/$mode" ;;
gpu) sh build.sh gpu; ./build/gemm sweep; ./build/gemm bench ;;
*) echo 'usage: run.sh cpu|san|gpu' >&2; exit 2 ;;
esac
