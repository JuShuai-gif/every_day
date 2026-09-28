#!/usr/bin/env bash
set -euo pipefail
lesson=$(cd -- "$(dirname -- "$0")" && pwd)
mode=${1:-release}
case "$mode" in release|sanitize) ;; *) echo 'Use release or sanitize' >&2; exit 2;; esac
mkdir -p "$lesson/build" "$lesson/results"
build_dir=$(mktemp -d "$lesson/build/$mode.XXXXXX")
result_dir=$(mktemp -d "$lesson/results/$mode.XXXXXX")
# 每次运行独立保存日志，不覆盖旧证据；固定8字节输入，无模型依赖。
printf '%s' 'ABCDEFGH' > "$build_dir/input.txt"
{ date -u '+%Y-%m-%dT%H:%M:%SZ'; uname -srm; "${CXX:-c++}" --version; } > "$result_dir/environment.txt"
if bash "$lesson/build.sh" "$mode" "$build_dir" > "$result_dir/build.txt" 2>&1; then
    if "$build_dir/fd_observe" "$build_dir/input.txt" > "$result_dir/stdout.txt" 2> "$result_dir/stderr.txt"; then
        status=0
    else
        status=$?
    fi
else
    status=$?
fi
printf '%s\n' "$status" > "$result_dir/exit-code.txt"
cat "$result_dir/build.txt"
if [[ -f "$result_dir/stdout.txt" ]]; then cat "$result_dir/stdout.txt"; fi
if [[ -f "$result_dir/stderr.txt" ]]; then cat "$result_dir/stderr.txt" >&2; fi
printf 'RESULT_DIR=%s\n' "$result_dir"
exit "$status"
