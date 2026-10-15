#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh "${1:-release}"
./build/example
