#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
sh build.sh "$mode"
exec "./build/$mode"
