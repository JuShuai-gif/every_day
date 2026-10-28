# Thor SM110 工具记录

唯一目标：`sm_110` / `cc 11.0`。生成：`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 src/gemm.cu -o build/gemm_sm110`。定位：`ncu --set full --kernel-name regex:baseline|tiled --launch-skip 20 --launch-count 100 ./build/gemm_sm110`。源码关联：加入 `-lineinfo` 后在 Source 页定位 `baseline`、`tiled`，再用 `cuobjdump --dump-ptx` / `--dump-sass`。本机缺 nvcc/ncu/GPU，未伪造 PTX/SASS；ncu 时钟控制、权限和 JetPack 版本需在 Thor 记录。