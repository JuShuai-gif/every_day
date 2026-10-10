#!/bin/sh
set -eu
cd "$(dirname "$0")"
c++ -std=c++17 -O3 -Wall -Wextra main.cpp -o /tmp/arm17-prefetch
/tmp/arm17-prefetch
