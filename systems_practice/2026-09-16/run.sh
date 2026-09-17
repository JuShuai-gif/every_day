#!/usr/bin/env bash
set -euo pipefail
practice_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
mode="${1:-cpu}"
case "$mode" in cpu|sanitize|gpu) ;; *) echo 'usage: bash run.sh [cpu|sanitize|gpu]' >&2; exit 2;; esac
mkdir -p "$practice_dir/results" "$practice_dir/.tmp"
export TMPDIR="$practice_dir/.tmp"
export TMP="$TMPDIR" TEMP="$TMPDIR"
export CUDA_CACHE_PATH="$practice_dir/.cache/cuda"
export XDG_CACHE_HOME="$practice_dir/.cache"
export CLANG_MODULE_CACHE_PATH="$practice_dir/.cache/clang"
export CCACHE_DIR="$practice_dir/.cache/ccache"
export PYTHONDONTWRITEBYTECODE=1
run_dir="$(mktemp -d "$practice_dir/results/${mode}-XXXXXXXX")"
mkdir -p "$run_dir/build"
(
  trap 'result=$?; echo "EXIT_STATUS=$result"' EXIT
  date -u '+UTC %Y-%m-%d %H:%M:%S'
  uname -sm
  cmake --version
  cmake_args=(-S "$practice_dir" -B "$run_dir/build" -DCMAKE_BUILD_TYPE=Release)
  if [[ "$mode" == gpu ]]; then
    cmake_args+=(-DENABLE_TENSORRT=ON)
    [[ -z "${TENSORRT_ROOT:-}" ]] || cmake_args+=("-DTENSORRT_ROOT=$TENSORRT_ROOT")
    [[ -z "${CUDAToolkit_ROOT:-}" ]] || cmake_args+=("-DCUDAToolkit_ROOT=$CUDAToolkit_ROOT")
  elif [[ "$mode" == sanitize ]]; then
    cmake_args+=(-DENABLE_SANITIZERS=ON)
  fi
  cmake "${cmake_args[@]}"
  cmake --build "$run_dir/build" --parallel 2
  ctest --test-dir "$run_dir/build" --output-on-failure
  "$run_dir/build/cpu_check"
  if [[ "$mode" == gpu ]]; then
    "$run_dir/build/trt_dynamic" "$run_dir/model.plan"
  fi
) 2>&1 | tee "$run_dir/output.log"
echo "Evidence: $run_dir/output.log"
