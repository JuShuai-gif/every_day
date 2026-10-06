#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh "${1:-release}"
exec "../../daily/2026-10-06/build/${1:-release}"
