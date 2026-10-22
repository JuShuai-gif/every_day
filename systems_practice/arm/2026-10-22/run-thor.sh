#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p build
# 唯一CUDA执行目标；这里只验证拷贝/事件所有权，没有自写GPU计算kernel。
nvcc --version
nvcc -std=c++17 -O2 -lineinfo -arch=sm_110 src/transfer.cu -o build/transfer
exec build/transfer
