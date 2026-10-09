# 2026-10-09 CUDA Kernel：Thor SM110 行 Softmax 的稳定归约与 warp 所有权

## 工业场景

机器人视觉编码器的 attention score 形状为 `[1024,127]` FP32：小 batch、每行一个 query，控制循环要求低延迟。输入和输出各约 508 KiB；本课只优化 GPU kernel，不把 CPU 预处理、PCIe/共享内存传输或后处理计入 kernel 时间。

## 概念回顾

Softmax 的第一机制是数值稳定：每行先求 `m=max(x)`，再算 `exp(x-m)/sum(exp(x-m))`。若直接指数化，视觉 token 的较大 logit 会溢出；若把行的 `m` 或 `sum` 混入另一行，归一化虽然可能看起来接近 1，却改变注意力分布。第二个紧耦合机制是归约所有权。本课基线以一线程独占一行，语义最直观却没有并行；最终候选让一个 32-lane warp 独占一行，每个 lane 用 8 个寄存器槽覆盖最多 256 列，以 `__shfl_xor_sync` 做两次 warp 内规约。这样没有 shared memory 和 `__syncthreads()`，也不存在跨 warp 的可见性契约。它只适用于 `cols<=256`，而且每个 block 的 4 个 warp 分别处理四行；把它硬套给长序列会使每 lane 的寄存器和循环增长，降低驻留 CTA 数。

实际读过 PyTorch v2.8.0 的 `SoftMax.cu`：`SoftMaxForwardEpilogue` 保留减 max 后的指数/除和；`SoftMaxForward_getBlockSize` 与 `ilpReduce` 根据维度、warp 与向量对齐取舍；`WriteFpropResultsVectorized` 有错位前缀与尾部路径。本练习是受其启发的独立简化版，省略 dispatch、mask、backward 和 vectorized-alignment 分支。仓库为 [PyTorch](https://github.com/pytorch/pytorch)，tag `v2.8.0`，BSD-3-Clause，详细记录见 [source.json](source.json)。

## 知识图谱

`row layout contiguous` → `lane+32*k 合并读取` → `寄存器局部 max/sum` → `warp shuffle` → `稳定 epilogue`。前置条件是同一 warp 的 active mask 全为 32 lane、行宽不超过 256 且输入有限；不能把 warp shuffle 当作 CTA barrier，也不能把 host wall time 当作 kernel 时间。

## 编码练习

20–30 分钟：补全/审阅 `softmax_warp`，在 `cols={31,32,33,127,255,256}` 上与 FP32 reference 比较，并在 Thor 上新增 CUDA events 的 20 次预热、100 次采样。验收：最大绝对误差不大于 `2e-5`、每行和距 1 不大于 `2e-5`；报告 baseline/warp 的 kernel P50/P95 与含 H2D+D2H 的端到端 P50/P95，不能混用。

## 文件说明

- `src/softmax.cu`：基线和最终 warp 候选，均固定为 SM110 构建目标。
- `src/cpu_check.cpp`：稳定 reference、平移不变性和 shape 边界检查。
- `run.sh`：本机 CPU、ASan/UBSan 与 Thor 三种明确模式。

## 编译与运行

Mac：`./run.sh cpu`，`./run.sh sanitize`。Thor Linux（匹配 CUDA/JetPack/L4T/驱动并由 `nvcc` 支持 `sm_110`）：`./run.sh thor`。编译命令由 CMake 固定 `CUDA_ARCHITECTURES=110`；不使用 `sm_110a`。若 `nvcc -arch=sm_110` 不被接受，记录版本与错误，升级匹配 Thor 的工具链后再测。

## 正确性验证

CPU reference 覆盖 8 个列数（含 warp/8 槽边界）、7 行、逐行平移不变性和 2 个非法 shape。GPU 正确性、编译及执行未验证：本机没有 NVIDIA GPU、`nvcc` 或 Thor；CPU 通过不等同 GPU 验收。

## 性能分析

先用 `ncu --set full --kernel-name regex:softmax_(baseline|warp) ./build/thor/softmax` 定位，再采集 `--metrics sm__warps_active.avg.pct_of_peak_sustained_active,smsp__sass_thread_inst_executed_op_shuffle_pred_on.sum,smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct`。源码关联：baseline 的串行循环应显示较少 shuffle；warp 候选应将 `__shfl_xor_sync` 映射到 shuffle 类指令。真实 SASS 仅能从 Thor 产物导出：`cuobjdump --dump-sass ./build/thor/softmax`，PTX：`cuobjdump --dump-ptx ./build/thor/softmax`。本机没有产物，绝不伪造 SASS、周期或收益。对照：Ampere 也有 warp shuffle；SM110 是唯一执行目标，架构差异不能代替 Thor 实测。

## 实际运行结果

Mac 已实际编译并运行 Release、ASan/UBSan：8 个稳定 softmax shape/平移不变性及 2 个非法 shape 均通过，原始输出见 [cpu.txt](results/cpu.txt) 和 [sanitize.txt](results/sanitize.txt)。Thor GPU、ncu、PTX/SASS和性能数据均未验证；没有任何 GPU 加速比声明。

## 工程注意事项

输入必须连续且 `cols<=256`；较长行应转 block reduction 或库实现。CUDA API 必须检查返回值；生产版需要 RAII device buffer/stream，并在异常路径释放。调度前还要确认 batch 行数足以填满 SM；这与每行内的 warp 归约是不同层次的问题。

## 工业故障与面试追问

- 日志出现 NaN：常由未减去行最大值触发；最小诊断是保存该行 max/sum；修复稳定 epilogue。
- `cols=257` 输出遗漏：8 槽候选越出设计边界；诊断 shape assert；改走 block kernel。
- profile 显示很快但控制循环慢：只测了 CUDA event；诊断分别记录 H2D/kernel/D2H；采用 pinned buffer 或融合前先确认数据边界。
- 错误 warp mask：分支后仍用全 mask 可能读无效 lane；诊断 compute-sanitizer；确保控制流/active mask 一致。

追问：1) 为什么 max 与 sum 是两次归约？2) warp shuffle 提供什么同步/可见性？3) 何时 shared-memory block reduction 更合适？4) `__expf` 的精度取舍？5) 为什么 vector load 需要对齐前缀？6) 如何区分 kernel 与端到端计时？

## 自测问题

若 shape 从 `[1024,127]` 改为 `[1024,513]`，请设计不改变稳定语义的 kernel 路径选择和正确性/性能验收，说明为什么不能仅把寄存器数组从 8 扩为 17。
