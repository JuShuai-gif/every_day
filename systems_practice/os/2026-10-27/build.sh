#!/bin/sh
set -eu
r=$(CDPATH= cd -- "$(dirname "$0")" && pwd);mkdir -p "$r/build";c++ -std=c++17 -Wall -Wextra -Werror -O2 "$r/src/main.cpp" -o "$r/build/a";"$r/build/a";c++ -std=c++17 -O1 -g -fsanitize=address,undefined "$r/src/main.cpp" -o "$r/build/s";"$r/build/s"
