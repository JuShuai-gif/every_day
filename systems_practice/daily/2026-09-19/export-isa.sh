#!/bin/sh
set -eu
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
command -v nvcc >/dev/null || { echo 'nvcc missing; no actual PTX/SASS generated' >&2; exit 127; }
command -v cuobjdump >/dev/null || { echo 'cuobjdump missing' >&2; exit 127; }
mkdir -p "$here/build/isa"
nvcc --version > "$here/build/isa/toolchain.txt"
# PTX与机器码来自相同源代码/优化级别，执行目标始终sm_110。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v "$here/src/transpose.cu" -o "$here/build/isa/transpose" 2> "$here/build/isa/ptxas.txt"
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx "$here/src/transpose.cu" -o "$here/build/isa/transpose.ptx"
cuobjdump --dump-sass "$here/build/isa/transpose" > "$here/build/isa/transpose.sass"
cuobjdump --dump-resource-usage "$here/build/isa/transpose" > "$here/build/isa/resources.txt"
