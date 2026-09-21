#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-native}
# 上游 TemporaryDirectory 也必须留在本期目录。
mkdir -p build/tmp
export TMPDIR="$PWD/build/tmp"
export PYTHONDONTWRITEBYTECODE=1
case "$mode" in
  native) exec python3 example.py ;;
  packing) exec python3 packing.py ;;
  *) echo 'usage: run.sh native|packing' >&2; exit 2 ;;
esac
