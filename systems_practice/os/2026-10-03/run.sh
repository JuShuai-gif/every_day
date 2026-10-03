#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh
build/example
build/sanitize
