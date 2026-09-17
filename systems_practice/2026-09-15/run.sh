#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
if [[ "${1:-}" != "--worker" ]]; then
    mkdir -p results
    run_dir=$(mktemp -d "$PWD/results/run-XXXXXXXX")
    bash "$PWD/run.sh" --worker "$@" 2>&1 | tee "$run_dir/output.log"
    exit 0
fi
shift
trap 'rc=$?; echo "run_exit_code=$rc"; trap - EXIT; exit "$rc"' EXIT
export TMPDIR="$PWD/build/tmp"
mkdir -p "$TMPDIR"
echo "timestamp=$(TZ=Asia/Shanghai date '+%F %T %Z')"
uname -a
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel 2
./build/cpu_check
if [[ -x ./build/cuda_preprocess ]]; then
    ./build/cuda_preprocess "${1:-256}"
else
    echo "UNVERIFIED: CUDA binary unavailable; no GPU measurements."
fi
