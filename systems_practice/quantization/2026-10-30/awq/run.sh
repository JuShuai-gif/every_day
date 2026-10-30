#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 默认只运行无依赖的独立数学实验；native明确需要原仓库环境。
case "${1:-independent}" in
 independent) exec python3 independent.py ;;
 native) : "${AWQ_ROOT:?point to pinned llm-awq checkout}"; exec python3 native_example.py ;;
 *) exit 2 ;;
esac
