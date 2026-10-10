#!/bin/sh
set -eu
cd "$(dirname "$0")"
c++ -std=c++17 -O2 -Wall -Wextra main.cpp -o /tmp/os12-schedule
/tmp/os12-schedule
