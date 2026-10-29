#!/usr/bin/env bash
set -euo pipefail
: "${BOARD:?set BOARD=user@rk3588-host or SSH config alias}"
[[ "$BOARD" =~ ^[A-Za-z0-9_][A-Za-z0-9_.@-]*$ ]] ||
  { echo "use an SSH alias or user@hostname" >&2; exit 2; }
cpu_set=${CPU_SET:-}
[[ -z "$cpu_set" || "$cpu_set" =~ ^[0-9,-]+$ ]] ||
  { echo "invalid CPU_SET" >&2; exit 2; }
neon=${EDGE_ENABLE_NEON:-ON}
auto_vectorize=${EDGE_AUTO_VECTORIZE:-ON}
case "$neon/$auto_vectorize" in
  ON/ON|ON/OFF|OFF/ON|OFF/OFF) ;;
  *) echo "EDGE_ENABLE_NEON and EDGE_AUTO_VECTORIZE must be ON or OFF" >&2; exit 2 ;;
esac
suffix=""
if [[ "$neon/$auto_vectorize" != ON/ON ]]; then
  suffix="-neon-$neon-auto-$auto_vectorize"
fi
tune=${RK_TUNE:-generic}
case "$tune" in
  generic|cortex-a55|cortex-a76) ;;
  *) echo "RK_TUNE must be generic, cortex-a55 or cortex-a76" >&2; exit 2 ;;
esac
matrix=${RK_MATRIX:-0}
[[ "$matrix" == 0 || "$matrix" == 1 ]] || { echo "RK_MATRIX must be 0 or 1" >&2; exit 2; }
repeats=${MATRIX_REPEATS:-3}
samples=${MATRIX_SAMPLES:-120}
seconds=${MATRIX_SECONDS:-3}
budget=${BUDGET_US:-0}
for value in "$repeats" "$samples" "$seconds"; do
  [[ "$value" =~ ^[0-9]+$ ]] || { echo "matrix counts/seconds must be unsigned integers" >&2; exit 2; }
done
[[ "$budget" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "invalid BUDGET_US" >&2; exit 2; }
root=$(cd -- "$(dirname -- "$0")" && pwd)
build="$root/build/rk3588-$tune$suffix"
binary="$build/lidar_filter"
[[ -f "$binary" ]] || { echo "run build-rk3588.sh with matching flags first: $build" >&2; exit 2; }
file "$binary" | grep -Eq 'ELF 64-bit.*(ARM aarch64|aarch64)' ||
  { echo "refusing non-AArch64 ELF binary" >&2; exit 2; }
mkdir -p "$root/records"
local_record=$(mktemp -d "$root/records/rk3588-$(date +%Y%m%d-%H%M%S)-XXXXXX")
remote=$(ssh "$BOARD" 'mktemp -d /tmp/robot-edge-XXXXXX')
[[ "$remote" =~ ^/tmp/robot-edge-[A-Za-z0-9]+$ ]] ||
  { echo "unexpected remote path" >&2; exit 2; }
printf 'board=%s\nremote=%s\ncpu_set=%s\nmatrix=%s\ntune=%s\nexplicit_neon=%s\nauto_vectorize=%s\n' \
  "$BOARD" "$remote" "$cpu_set" "$matrix" "$tune" "$neon" "$auto_vectorize" > "$local_record/deployment.txt"
scp "$binary" "$build/build-environment.txt" "$build/compile_commands.json" "$BOARD:$remote/"
scp -r "$root/scripts" "$BOARD:$remote/"
status=0
if [[ "$matrix" == 1 ]]; then
  # 参数已限制为数字；核号由板端探测器决定，不从主机推测。
  ssh "$BOARD" "MATRIX_REPEATS='$repeats' MATRIX_SAMPLES='$samples' MATRIX_SECONDS='$seconds' BUDGET_US='$budget' bash '$remote/scripts/run-matrix.sh' '$remote/lidar_filter' '$remote/results'" \
    > "$local_record/ssh.log" 2>&1 || status=$?
else
  ssh "$BOARD" "bash '$remote/scripts/collect.sh' '$remote/lidar_filter' '$remote/results' '$cpu_set' '$budget'" \
    > "$local_record/ssh.log" 2>&1 || status=$?
fi
# 即使板端失败也取回日志，不自动删远程证据。
scp -r "$BOARD:$remote/results" "$local_record/" || status=1
cp "$build/build-environment.txt" "$build/compile_commands.json" "$local_record/"
if [[ -f "$local_record/results/samples.csv" ]]; then
  python3 "$root/scripts/summarize.py" "$local_record/results/samples.csv" \
    --output "$local_record/summary.json" || status=1
fi
printf 'exit_status=%s record=%s remote_kept=%s\n' "$status" "$local_record" "$remote"
exit "$status"
