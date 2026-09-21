#!/usr/bin/env bash
set -euo pipefail
# 只用现有 Python 标准库；从任意目录运行，并保留实际输出。
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
mkdir -p results
python3 -B example.py | tee results/output.json
