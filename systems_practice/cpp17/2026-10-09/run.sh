#!/bin/sh
set -eu
cd "$(dirname "$0")"
c++ -std=c++17 -O2 -Wall -Wextra main.cpp -o /tmp/cpp17-hash
/tmp/cpp17-hash
