#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh
export TMPDIR="$PWD/build/tmp"
./build/example
./build/sanitize
