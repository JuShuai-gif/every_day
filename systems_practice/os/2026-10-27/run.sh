#!/bin/sh
set -eu
r=$(CDPATH= cd -- "$(dirname "$0")" && pwd);sh "$r/build.sh";if command -v perf >/dev/null;then perf stat -e cycles,instructions "$r/build/a" >"$r/results/perf.txt" 2>&1 || true;else echo 'perf unavailable on macOS' >"$r/results/perf.txt";fi
