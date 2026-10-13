#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
sh build.sh "$mode"
case "$mode" in
 cpu) exec build/cpu ;;
 sanitize) exec build/cpu-sanitize ;;
 thor) exec build/gemm ;;
esac
