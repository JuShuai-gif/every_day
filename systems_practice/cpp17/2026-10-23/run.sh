#!/bin/sh
set -eu
cd "$(dirname "$0")"
mode=${1:-release}
if [ "$#" -gt 0 ]; then shift; fi
sh build.sh "$mode"
exec "./build/app-$mode" "$@"
