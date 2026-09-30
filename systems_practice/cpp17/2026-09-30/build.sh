#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build/tmp
clang++ --version
clang++ -std=c++17 -O2 -Wall -Wextra -Werror src/example.cpp -o build/example
clang++ -std=c++17 -O1 -g -Wall -Wextra -Werror -fsanitize=address,undefined -fno-omit-frame-pointer src/example.cpp -o build/sanitize
