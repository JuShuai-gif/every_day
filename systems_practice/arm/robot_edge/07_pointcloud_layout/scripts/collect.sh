#!/usr/bin/env bash
set -euo pipefail
binary=$1
result=$2
cpu_set=${3:-}
budget=${4:-0}
[[ "$budget" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "invalid budget" >&2; exit 2; }
mkdir -p "$result"
command -v timeout >/dev/null || { echo "GNU timeout is required on the board" >&2; exit 2; }
[[ "$(uname -s)" == Linux && "$(uname -m)" == aarch64 ]] ||
  { echo "expected Linux/aarch64" >&2; exit 2; }
runner=()
if [[ -n "$cpu_set" ]]; then
  [[ "$cpu_set" =~ ^[0-9,-]+$ ]] || { echo "invalid CPU_SET" >&2; exit 2; }
  command -v taskset >/dev/null
  runner=(taskset -c "$cpu_set")
fi
snapshot() {
  date -u
  uname -a
  cat /etc/os-release
  lscpu || true
  lscpu -e || true
  cat /proc/cpuinfo
  for f in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor \
           /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq \
           /sys/devices/system/cpu/cpu*/regs/identification/midr_el1 \
           /sys/class/thermal/thermal_zone*/type /sys/class/thermal/thermal_zone*/temp; do
    if [[ -r "$f" ]]; then printf '%s=' "$f"; cat "$f"; fi
  done
  printf 'CPU_SET=%s\n' "${cpu_set:-scheduler_default}"
}
snapshot > "$result/environment-before.txt" 2>&1
file "$binary" > "$result/binary.txt"
ldd "$binary" >> "$result/binary.txt" 2>&1 || true
sha256sum "$binary" > "$result/binary-sha256.txt"
timeout 90 "${runner[@]}" "$binary" --test > "$result/tests.txt" 2>&1
timeout 600 "${runner[@]}" "$binary" --mode all --samples 120 --budget-us "$budget" --csv "$result/samples.csv" \
  > "$result/benchmark.txt" 2>&1
# PMU 包含进程初始化和预热；不能解释成单个 kernel 的精确计数。
if command -v perf >/dev/null; then
  perf --version > "$result/perf-version.txt"
  perf list > "$result/perf-events.txt" 2>&1 || true
  for mode in baseline stage1 optimized; do
    if timeout 300 "${runner[@]}" perf stat -x , -e cycles,instructions,cache-misses,branches,branch-misses \
      -o "$result/$mode-perf.csv" -- "$binary" --mode "$mode" --profile \
      --samples 100 --iterations 5 > "$result/$mode-perf-run.txt" 2>&1; then
      printf '%s perf_stat=PASS\n' "$mode" >> "$result/perf-status.txt"
    else
      printf '%s perf_stat=UNAVAILABLE_OR_FAILED\n' "$mode" >> "$result/perf-status.txt"
    fi
  done
  if timeout 300 "${runner[@]}" perf record --call-graph dwarf -o "$result/perf.data" -- \
      "$binary" --mode optimized --profile --samples 100 --iterations 5 \
      > "$result/perf-record.txt" 2>&1; then
    perf report --stdio -i "$result/perf.data" > "$result/hotspots.txt" 2>&1 || true
  fi
else
  printf 'perf=NOT_INSTALLED\n' > "$result/perf-status.txt"
fi
snapshot > "$result/environment-after.txt" 2>&1
printf 'board_run=PASS\n' > "$result/status.txt"
