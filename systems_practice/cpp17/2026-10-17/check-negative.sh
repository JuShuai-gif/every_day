#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
export TMPDIR="$PWD/build"
# 两TU普通外部定义造成受控链接失败，不运行ODR违规程序。
printf 'int conflict = 1; int f(){return conflict;}\n' > build/bad_a.cpp
printf 'int conflict = 1; int main(){return conflict;}\n' > build/bad_b.cpp
if c++ -std=c++17 build/bad_a.cpp build/bad_b.cpp -o build/bad > build/link-error.txt 2>&1; then
  echo 'ERROR: expected duplicate symbol rejection' >&2
  exit 1
fi
cat build/link-error.txt
grep -E 'duplicate symbol|multiple definition' build/link-error.txt >/dev/null
