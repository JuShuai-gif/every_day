#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"; c++ -std=c++17 -O2 -Wall -Wextra src/main.cpp -pthread -o main
