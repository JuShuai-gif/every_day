#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")" && pwd)
python3 -B "$root/tests/test_perf_contract.py"
for project in "$root"/[0-9][0-9]_*/; do
  printf '\nproject=%s\n' "$(basename "$project")"
  bash "$project/run-mac.sh" "$@"
done
