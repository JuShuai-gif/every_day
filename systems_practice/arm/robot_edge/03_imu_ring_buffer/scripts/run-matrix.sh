#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

if [[ $# != 2 ]]; then
  echo "usage: bash run-matrix.sh BINARY EMPTY_OUTPUT_DIRECTORY" >&2
  exit 2
fi
if [[ "$(uname -s)" != Linux || "$(uname -m)" != aarch64 ]]; then
  echo "matrix requires Linux/aarch64; Mac results cannot represent RK3588" >&2
  exit 2
fi
for command in python3 taskset timeout sha256sum; do
  command -v "$command" >/dev/null || { echo "missing required command: $command" >&2; exit 2; }
done
binary=$1
output=$2
[[ -f "$binary" && -x "$binary" ]] || { echo "binary is not executable" >&2; exit 2; }
if [[ -d "$output" && -n "$(ls -A -- "$output")" ]]; then
  echo "output directory must be empty; existing evidence will not be overwritten" >&2
  exit 2
fi
mkdir -p -- "$output"
binary=$(cd -- "$(dirname -- "$binary")" && pwd)/$(basename -- "$binary")
output=$(cd -- "$output" && pwd)
scripts=$(cd -- "$(dirname -- "$0")" && pwd)
repeats=${MATRIX_REPEATS:-3}
samples=${MATRIX_SAMPLES:-120}
seconds=${MATRIX_SECONDS:-3}
budget=${BUDGET_US:-0}

# Validate before executing a workload; timeout scales with a requested long measurement.
trial_timeout=$(python3 - "$repeats" "$samples" "$seconds" "$budget" <<'PY'
import math
import sys
r, n, seconds, budget = sys.argv[1:]
if not r.isascii() or not n.isascii() or not r.isdecimal() or not n.isdecimal() or not 1 <= int(r) <= 100 or not 1 <= int(n) <= 1000000:
    raise SystemExit("MATRIX_REPEATS must be 1..100; MATRIX_SAMPLES must be 1..1000000")
s, b = float(seconds), float(budget)
if not math.isfinite(s) or not math.isfinite(b) or s < 0 or b < 0:
    raise SystemExit("MATRIX_SECONDS and BUDGET_US must be finite nonnegative numbers")
print(max(600, math.ceil(s * 3 + 180)))
PY
)
repeats=$((10#$repeats))
binary_hash=$(sha256sum "$binary")
binary_hash=${binary_hash%% *}
finished=0
interrupted=0
cleanup() {
  code=$?
  if [[ "$finished" == 0 ]]; then
    state=FAILED
    [[ "$interrupted" == 0 ]] || state=INTERRUPTED
    printf '{"status":"%s","exit_code":%s}\n' "$state" "$code" > "$output/status.json"
  fi
}
trap cleanup EXIT
trap 'interrupted=1; exit 130' INT
trap 'interrupted=1; exit 143' TERM

python3 - "$output/manifest.json" "$binary" "$binary_hash" "$repeats" "$samples" "$seconds" "$budget" <<'PY'
from datetime import datetime, timezone
import json
from pathlib import Path
import sys
target, binary, digest, repeats, samples, seconds, budget = sys.argv[1:]
Path(target).write_text(json.dumps({"schema_version": 1, "binary": binary,
    "binary_sha256": digest, "recorded_utc": datetime.now(timezone.utc).isoformat(),
    "repeats": int(repeats), "samples": int(samples), "seconds": float(seconds),
    "warmup": 5, "iterations": 1, "budget_us": float(budget),
    "scope": "whole workload, three stages, process affinity inherited by threads"}, indent=2) + "\n")
PY
sha256sum "$binary" "$scripts/board_probe.py" "$scripts/run-matrix.sh" \
  "$scripts/summarize-matrix.py" > "$output/artifact-sha256.txt"
python3 "$scripts/board_probe.py" --output "$output/probe-before.json"
uname -a > "$output/platform.txt"
cat /etc/os-release >> "$output/platform.txt"
python3 - "$output/probe-before.json" > "$output/profiles.tsv" <<'PY'
import json
import sys
with open(sys.argv[1]) as stream:
    probe = json.load(stream)
for name in ("single_a55", "single_a76", "cluster_a55", "cluster_a76"):
    if name in probe["profiles"]:
        print(name + "\t" + ",".join(map(str, probe["profiles"][name])))
PY

if ! timeout 120 "$binary" --test > "$output/correctness.txt" 2>&1; then
  echo "preflight correctness failed or timed out; see correctness.txt" >&2
  exit 1
fi
if ! grep -qx 'correctness=PASS' "$output/correctness.txt"; then
  echo "preflight did not report correctness=PASS" >&2
  exit 1
fi

while IFS=$'\t' read -r profile cpus; do
  [[ -n "$profile" && -n "$cpus" ]] || continue
  for ((repetition = 1; repetition <= repeats; repetition++)); do
    trial="$output/runs/$profile/repeat-$repetition"
    mkdir -p "$trial"
    code=0
    timeout 30 taskset -c "$cpus" python3 "$scripts/board_probe.py" \
      --output "$trial/environment-before.json" > "$trial/probe-before.log" 2>&1 || code=$?
    if [[ "$code" == 0 ]]; then
      python3 "$scripts/summarize-matrix.py" --check-topology "$trial/environment-before.json" \
        --initial-probe "$output/probe-before.json" --profile "$profile" --cpus "$cpus" \
        > "$trial/topology-before.log" 2>&1 || code=$?
    fi
    printf '%q ' timeout "$trial_timeout" taskset -c "$cpus" "$binary" --mode all \
      --samples "$samples" --seconds "$seconds" --warmup 5 --iterations 1 \
      --budget-us "$budget" --csv "$trial/samples.csv" > "$trial/command.txt"
    printf '\n' >> "$trial/command.txt"
    trial_hash=$(sha256sum "$binary")
    trial_hash=${trial_hash%% *}
    if [[ "$code" == 0 ]]; then
      timeout "$trial_timeout" taskset -c "$cpus" "$binary" --mode all \
        --samples "$samples" --seconds "$seconds" --warmup 5 --iterations 1 \
        --budget-us "$budget" --csv "$trial/samples.csv" > "$trial/stdout.log" 2>&1 || code=$?
    fi
    after_code=0
    timeout 30 taskset -c "$cpus" python3 "$scripts/board_probe.py" \
      --output "$trial/environment-after.json" > "$trial/probe-after.log" 2>&1 || after_code=$?
    if [[ "$after_code" == 0 ]]; then
      python3 "$scripts/summarize-matrix.py" --check-topology "$trial/environment-after.json" \
        --initial-probe "$output/probe-before.json" --profile "$profile" --cpus "$cpus" \
        > "$trial/topology-after.log" 2>&1 || after_code=$?
    fi
    trial_hash_after=$(sha256sum "$binary")
    trial_hash_after=${trial_hash_after%% *}
    state=FAILED
    if [[ "$code" == 0 && "$after_code" == 0 && "$trial_hash" == "$binary_hash" && "$trial_hash_after" == "$binary_hash" ]] &&
      grep -qx 'correctness=PASS' "$trial/stdout.log" && [[ -s "$trial/samples.csv" ]]; then
      state=COMPLETE
    fi
    printf '{"status":"%s","exit_code":%s,"post_probe_exit_code":%s,"binary_sha256":"%s","binary_sha256_after":"%s","cpus":"%s"}\n' \
      "$state" "$code" "$after_code" "$trial_hash" "$trial_hash_after" "$cpus" > "$trial/status.json"
  done

  for mode in baseline stage1 optimized; do
    destination="$output/perf/$profile/$mode"
    mkdir -p "$destination"
    perf_state=UNAVAILABLE
    successful_events=
    successful_attempt=0
    if command -v perf >/dev/null; then
      perf_state=FAILED_OR_UNAVAILABLE
      attempt=0
      for events in \
        cycles,instructions,context-switches,cpu-migrations,cache-references,cache-misses \
        cycles,instructions,context-switches,cpu-migrations \
        task-clock,context-switches,cpu-migrations; do
        attempt=$((attempt + 1))
        perf_hash_before=$(sha256sum "$binary")
        perf_hash_before=${perf_hash_before%% *}
        code=0
        timeout 30 taskset -c "$cpus" python3 "$scripts/board_probe.py" \
          --output "$destination/attempt-$attempt-before.json" \
          > "$destination/attempt-$attempt-before.log" 2>&1 || code=$?
        if [[ "$code" == 0 ]]; then
          python3 "$scripts/summarize-matrix.py" --check-topology "$destination/attempt-$attempt-before.json" \
            --initial-probe "$output/probe-before.json" --profile "$profile" --cpus "$cpus" \
            >> "$destination/attempt-$attempt-before.log" 2>&1 || code=$?
        fi
        if [[ "$code" == 0 ]]; then
          timeout 300 taskset -c "$cpus" perf stat -x , -e "$events" \
            -o "$destination/attempt-$attempt.csv" -- "$binary" --mode "$mode" --profile \
            --samples 30 --warmup 5 --iterations 1 > "$destination/attempt-$attempt.log" 2>&1 || code=$?
        fi
        after_code=0
        timeout 30 taskset -c "$cpus" python3 "$scripts/board_probe.py" \
          --output "$destination/attempt-$attempt-after.json" \
          > "$destination/attempt-$attempt-after.log" 2>&1 || after_code=$?
        if [[ "$after_code" == 0 ]]; then
          python3 "$scripts/summarize-matrix.py" --check-topology "$destination/attempt-$attempt-after.json" \
            --initial-probe "$output/probe-before.json" --profile "$profile" --cpus "$cpus" \
            >> "$destination/attempt-$attempt-after.log" 2>&1 || after_code=$?
        fi
        perf_hash_after=$(sha256sum "$binary")
        perf_hash_after=${perf_hash_after%% *}
        printf '{"exit_code":%s,"post_probe_exit_code":%s,"events":"%s","cpus":"%s","binary_sha256":"%s","binary_sha256_after":"%s"}\n' \
          "$code" "$after_code" "$events" "$cpus" "$perf_hash_before" "$perf_hash_after" \
          > "$destination/attempt-$attempt-status.json"
        if [[ "$code" == 0 && "$after_code" == 0 && "$perf_hash_before" == "$binary_hash" && "$perf_hash_after" == "$binary_hash" ]] &&
          [[ -s "$destination/attempt-$attempt.csv" ]] &&
          python3 "$scripts/summarize-matrix.py" --check-perf "$destination/attempt-$attempt.csv" --events "$events"; then
          perf_state=COMPLETE
          successful_events=$events
          successful_attempt=$attempt
          break
        fi
      done
    fi
    printf '{"status":"%s","events":"%s","successful_attempt":%s,"cpus":"%s"}\n' \
      "$perf_state" "$successful_events" "$successful_attempt" "$cpus" \
      > "$destination/status.json"
  done
done < "$output/profiles.tsv"

python3 "$scripts/board_probe.py" --output "$output/probe-after.json"
python3 "$scripts/summarize-matrix.py" "$output" --output "$output/summary.json"
state=$(python3 - "$output/summary.json" <<'PY'
import json
import sys
with open(sys.argv[1]) as stream:
    print(json.load(stream)["status"])
PY
)
printf '{"status":"%s","acceptance_status":"not_evaluated"}\n' "$state" > "$output/status.json"
finished=1
printf 'matrix_status=%s evidence=%s\n' "$state" "$output"
case "$state" in
  COMPLETE) exit 0 ;;
  PARTIAL|UNAVAILABLE) exit 2 ;;
  *) exit 1 ;;
esac
