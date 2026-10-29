#!/bin/sh
set -eu
sh "$(CDPATH= cd -- "$(dirname "$0")" && pwd)/build.sh"
