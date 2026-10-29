#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
sh build.sh "$mode"
if [ "$mode" = thor ]; then
    ./build/rmsnorm
    ./build/rmsnorm 257 513 both
else
    ./build/cpu_check
fi
