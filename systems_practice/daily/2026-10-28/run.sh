#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"; ./build.sh cpu; ./build/cpu_check
if [[ "${1:-cpu}" == thor ]]; then ./build.sh thor; ./build/gemm_sm110; fi
