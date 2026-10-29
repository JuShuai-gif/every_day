#!/bin/sh
set -eu
r=$(CDPATH= cd -- "$(dirname "$0")" && pwd);sh "$r/build.sh";c++ -std=c++17 -O2 -S "$r/src/main.cpp" -o "$r/results/dispatch.s";rg -n 'fmla|ld1|addv' "$r/results/dispatch.s" || true
