#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-cpu}
sh build.sh "$mode"
if [ "$mode" = gpu ]; then
  # 同样覆盖短行、warp尾部及长依赖；默认两版公平对照。
  for n in 1 31 32 33 127 128 129 4097 65536; do ./build/energy 5 "$n"; done
  ./build/energy 4096 4097
else
  ./build/cpu_check
fi
