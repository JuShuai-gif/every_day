#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
sh build.sh "$mode"
if [ "$mode" = thor ]; then
  for n in 1 3 4 5 31 32 33 257 4097 65539; do ./build/thor "$n"; done
else
  "./build/$mode"
fi
