#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sh "$root/build.sh"
"$root/build/example"
"$root/build/sanitize"
