#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
clang++ --version
# 同一源码/优化等级；只切换向量化，保留编译器诊断与实际A64汇编。
clang++ -std=c++17 -O3 -Wall -Wextra -Werror -fno-vectorize -fno-slp-vectorize -DNAME=transform_scalar -c src/kernel.cpp -o build/scalar.o
clang++ -std=c++17 -O3 -Wall -Wextra -Werror -Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -c src/kernel.cpp -o build/auto.o 2> build/remarks.txt
clang++ -std=c++17 -O3 -S src/kernel.cpp -o build/auto.s
clang++ -std=c++17 -O3 src/example.cpp build/scalar.o build/auto.o -o build/example
clang++ -std=c++17 -O1 -g -fsanitize=address,undefined -DNAME=transform_scalar -c src/kernel.cpp -o build/san_scalar.o
clang++ -std=c++17 -O1 -g -fsanitize=address,undefined -c src/kernel.cpp -o build/san_auto.o
clang++ -std=c++17 -O1 -g -fsanitize=address,undefined src/example.cpp build/san_scalar.o build/san_auto.o -o build/sanitize
