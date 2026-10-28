#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"; ./build.sh; ./main; c++ -std=c++17 -O2 -S src/main.cpp -o results.s
