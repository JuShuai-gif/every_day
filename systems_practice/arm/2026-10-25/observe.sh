#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 编译器输出先留build，提取目标函数至文本结果；不是手写假想汇编。
"${CXX:-clang++}" -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S src/main.cpp -o build/main.s
python3 - <<'PY'
from pathlib import Path
s=Path('build/main.s').read_text();start=s.index('__Z7packed4PKfPfi:');end=s.index('.cfi_endproc',start)+len('.cfi_endproc')
Path('results/packed4.s').write_text(s[start:end]+'\n')
print(s[start:end])
PY
