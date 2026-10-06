#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 复用主课实现：ARM14聚焦扩宽与可选扩展，不复制第二个作业。
sh ../../daily/2026-10-06/build.sh "${1:-release}"
