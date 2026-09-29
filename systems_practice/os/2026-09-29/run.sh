#!/bin/sh
set -eu
cd "$(dirname "$0")"
sh build.sh
./build/observe
./build/observe-san
