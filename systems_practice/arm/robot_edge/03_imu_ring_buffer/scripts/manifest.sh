#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
uname -a
printf 'recorded_utc=%s\n' "$(date -u +%FT%TZ)"
printf 'git_head='
git -C "$root" rev-parse HEAD 2>/dev/null || true
printf 'source_hashes_sha256:\n'
for directory in src include cmake scripts tests; do
  if [[ -d "$root/$directory" ]]; then
    find "$root/$directory" -type f ! -path '*/__pycache__/*' -exec shasum -a 256 {} \;
  fi
done
shasum -a 256 "$root/CMakeLists.txt" "$root/run-mac.sh" "$root/build-rk3588.sh" "$root/run-rk3588.sh"
