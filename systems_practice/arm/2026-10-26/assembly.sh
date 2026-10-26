#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 保留原始全文件于缓存，归档相关两个函数的原样节选。
c++ -std=c++17 -O2 -fno-vectorize -fno-slp-vectorize -S src/main.cpp -o build/full.s
python3 - <<'PY'
from pathlib import Path
s=Path('build/full.s').read_text().splitlines()
out=['; Actual Apple Clang21 AArch64 assembly excerpts; not a standalone translation unit.']
for symbol in ['__Z6scalarPKfPfii','__Z11packed_reluPKfPfii']:
 start=next(i for i,x in enumerate(s) if x.startswith(symbol+':'))
 end=next(i for i in range(start,len(s)) if '.cfi_endproc' in s[i])+1
 out.extend(s[start:end]);out.append('')
Path('results/packed.s').write_text('\n'.join(out).rstrip()+'\n')
PY
