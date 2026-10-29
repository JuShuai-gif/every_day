#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 复用已归档完整SDK程序；本期不修改历史源码。
exec sh ../../arm/2026-10-22/run-thor.sh
