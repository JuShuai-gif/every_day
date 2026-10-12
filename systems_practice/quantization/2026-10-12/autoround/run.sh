#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 不自动安装。PYTHONPATH可指向固定commit的完整已准备checkout。
export PYTHONDONTWRITEBYTECODE=1
"${PYTHON:-python3}" - <<'PY'
import sys, importlib.util
if sys.version_info < (3,11):
    raise SystemExit('AutoRound 0.17.0 source requires Python >=3.11; found '+sys.version)
missing=[m for m in ['torch','auto_round'] if importlib.util.find_spec(m) is None]
if missing:
    raise SystemExit('missing dependencies: '+','.join(missing))
PY
exec "${PYTHON:-python3}" native_example.py
