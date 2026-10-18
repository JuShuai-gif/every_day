#!/bin/sh
set -eu
cd "$(dirname "$0")"
# 固定版本，只提取原生CPU例子真正导入的源码，不checkout模型/数据。
cache=../../../.tmp/quant_sources/spqr-20261018-reproduce
mkdir -p "$cache/source"
if [ ! -d "$cache/repo/.git" ]; then git init -q "$cache/repo"; fi
git -C "$cache/repo" fetch --depth=1 https://github.com/Vahe1994/SpQR.git 543d10e56f921e5eeb10d5f0aaaccd30b6662d0e
for file in spqr_engine.py quant_groups.py weight_permutation.py requirements.txt LICENSE README.md; do
  git -C "$cache/repo" show "543d10e56f921e5eeb10d5f0aaaccd30b6662d0e:$file" > "$cache/source/$file"
done
printf 'SPQR_SOURCE=%s sh run.sh\n' "$cache/source"
