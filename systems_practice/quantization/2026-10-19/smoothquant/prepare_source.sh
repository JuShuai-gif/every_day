#!/bin/sh
set -eu
cd "$(dirname "$0")"
practice=$(cd ../../.. && pwd)
dest="$practice/.tmp/quant_sources/smoothquant-manual"
# 只在新的缓存目录准备固定版本；不覆盖用户或既有checkout。
if test -e "$dest"; then echo "destination exists; reuse it only after checking commit/status" >&2; exit 2; fi
export GIT_LFS_SKIP_SMUDGE=1 GIT_TERMINAL_PROMPT=0
git clone --depth=1 --filter=blob:none --no-checkout https://github.com/mit-han-lab/smoothquant.git "$dest"
git -C "$dest" fetch --depth=1 origin c61476d728e42ae0d8a35e7e78494edcac3237b5
git -C "$dest" checkout c61476d728e42ae0d8a35e7e78494edcac3237b5 -- smoothquant/smooth.py smoothquant/fake_quant.py setup.py LICENSE README.md
git -C "$dest" rev-parse FETCH_HEAD
