#!/bin/sh
set -eu
r=$(CDPATH= cd -- "$(dirname "$0")" && pwd);case ${1:-cpu} in cpu)sh "$r/build.sh" cpu;"$r/build/cpu";;sanitize)sh "$r/build.sh" sanitize;ASAN_OPTIONS=detect_leaks=0 "$r/build/sanitize";;convert)python3 "$r/convert.py" --onnx-only;;rknn)sh "$r/build.sh" rknn;"$r/build/rknn" "${2:?model.rknn}";;*)exit 2;;esac
