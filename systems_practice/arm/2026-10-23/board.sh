#!/bin/sh
set -eu
cd "$(dirname "$0")"
[ "$(uname -s)" = Linux ] || { echo 'Linux Thor board required' >&2; exit 2; }
[ "$(uname -m)" = aarch64 ] || { echo 'aarch64 required' >&2; exit 2; }
# 只读采集：不改功耗模式、风扇、频率，也不假定CPU编号。
mkdir -p build
stamp=$(date +%Y%m%dT%H%M%S)
out="build/board-$stamp"
mkdir "$out"
{ uname -a; cat /etc/nv_tegra_release; lscpu; c++ --version; nvpmodel -q; } > "$out/environment.txt" 2>&1
sh build.sh release
tegrastats --interval 1000 > "$out/tegrastats.txt" 2>&1 &
telemetry=$!
trap 'kill "$telemetry" 2>/dev/null || true; wait "$telemetry" 2>/dev/null || true' EXIT INT TERM
# 记录实际暴露的policy与thermal zone，缺失即记录，不把缺值当零。
for d in /sys/devices/system/cpu/cpufreq/policy*; do
 [ -d "$d" ] || continue
 for f in affected_cpus scaling_governor scaling_cur_freq; do
  printf '%s: ' "$d/$f"; cat "$d/$f" || true
 done
done > "$out/cpufreq.txt"
./build/app-release 60 65539 > "$out/cpu-requests.txt"
printf 'CPU workload only; logs: %s\n' "$out"
