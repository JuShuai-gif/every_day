#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh
./build/example
./build/sanitize verify
cat build/remarks.txt
case "$(clang++ -dumpmachine)" in
arm64*|aarch64*) sed -n '/_transform_auto:/,/End function/p' build/auto.s ;;
*) echo '非AArch64主机：不把本机汇编当ARM证据' ;;
esac
