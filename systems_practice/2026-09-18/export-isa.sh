#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# 固定 Thor SM110；拒绝其他架构及未经核实的 a/f 后缀。
arch=${1:-sm_110}
case "$arch" in sm_110) ;; *) echo 'Thor-only: export-isa.sh [sm_110]' >&2; exit 2 ;; esac
for tool in nvcc ptxas cuobjdump cmake; do
  command -v "$tool" >/dev/null 2>&1 || { echo "$tool unavailable; no compiled PTX/SASS generated" >&2; exit 127; }
done
binary="$root/build/gpu/ptx_pool"
[ -x "$binary" ] || { echo 'build GPU target first' >&2; exit 2; }
# 防止导出旧架构缓存：这里重新按固定 SM110 配置并构建，失败就不导出。
cmake -S "$root" -B "$root/build/gpu" -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=110 -DCMAKE_BUILD_TYPE=Release
cmake --build "$root/build/gpu" -j 2
isa_dir=$(mktemp -d "$root/build/isa-sm110-XXXXXX")
nvcc --version > "$isa_dir/toolchain.txt"
ptxas --version >> "$isa_dir/toolchain.txt"
printf 'Requested standalone PTX target: %s\nExecutable uses its own CMake architectures; inspect CMakeCache below.\n' "$arch" >> "$isa_dir/toolchain.txt"
cmake -LA -N "$root/build/gpu" > "$isa_dir/cmake-cache.txt"
cmake -E sha256sum "$binary" "$root/src/ptx_pool.cu" "$root/src/direct_pool.hpp" \
  "$root/src/pooling.hpp" "$root/src/pool_direct.ptx" > "$isa_dir/sha256.txt"
# 已测二进制的反汇编是证据主体；禁止用手写文本冒充该输出。
cuobjdump --dump-ptx "$binary" > "$isa_dir/executable.ptx.txt"
cuobjdump --dump-sass "$binary" > "$isa_dir/executable.sass.txt"
# 另存可读的编译器 PTX；显式记录参数，不假定与 CMake 所有选项相同。
printf 'nvcc -std=c++17 -O3 -lineinfo -arch=%s --ptx src/ptx_pool.cu\n' "$arch" > "$isa_dir/commands.txt"
nvcc -std=c++17 -O3 -lineinfo -arch="$arch" --ptx "$root/src/ptx_pool.cu" \
  -o "$isa_dir/generated.ptx" > "$isa_dir/nvcc.txt" 2>&1
# 手写等价算法单独汇编，不能混同为 nvcc 生成或运行过的 kernel。
ptxas -arch="$arch" "$root/src/pool_direct.ptx" -o "$isa_dir/handwritten.cubin" \
  > "$isa_dir/ptxas.txt" 2>&1
cuobjdump --dump-sass "$isa_dir/handwritten.cubin" > "$isa_dir/handwritten.sass.txt"
printf 'PTX/SASS evidence: %s\n' "$isa_dir"
