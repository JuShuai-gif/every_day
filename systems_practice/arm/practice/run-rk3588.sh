#!/bin/sh
set -eu

# 例：BOARD=user@192.168.1.10 REMOTE_DIR=/tmp/arm-practice sh run-rk3588.sh
: "${BOARD:?set BOARD to user@rk3588-host}"
REMOTE_DIR=${REMOTE_DIR:-/tmp/arm-practice}
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
local_results="$root/records/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$local_results"

scp "$root"/build/rk3588/example_* "$BOARD:$REMOTE_DIR/"
ssh "$BOARD" "mkdir -p '$REMOTE_DIR/results'; uname -a > '$REMOTE_DIR/results/environment.txt'; \
  (cat /etc/os-release || true) >> '$REMOTE_DIR/results/environment.txt'; \
  (lscpu || true) >> '$REMOTE_DIR/results/environment.txt'; \
  (cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq || true) >> '$REMOTE_DIR/results/environment.txt'; \
  (g++ --version || true) >> '$REMOTE_DIR/results/environment.txt'; \
  for b in '$REMOTE_DIR'/example_*; do name=\$(basename \"\$b\"); \"\$b\" --mode both > '$REMOTE_DIR/results/'\"\$name\".txt; \
    if command -v perf >/dev/null 2>&1; then perf stat -o '$REMOTE_DIR/results/'\"\$name\".perf \"\$b\" --mode optimized; fi; done"
scp -r "$BOARD:$REMOTE_DIR/results" "$local_results/"
printf 'RK3588 records saved in %s\n' "$local_results"
