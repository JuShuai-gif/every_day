# 2026-10-28 PTX / CUTLASS：Thor SM110 分块 GEMM 的同步合同

## 工业场景
机器人视觉小批量矩阵乘（M=257,N=193,K=129）需要在 Thor 上同时处理非整 tile 与稳定的 FP32 累加。今天只推进一个主练习：比较逐元素 baseline 与 shared-memory tiled candidate；Mac 只能验证 CPU oracle，不能代替 CUDA 设备验收。

## 概念回顾
分块 GEMM 的第一机制是把 A、B 的连续片段搬入 shared memory，让一个 CTA 内的线程复用同一片数据。每个线程仍负责一个 C 元素，尾块必须用边界谓词写零，否则最后一个 16×16 tile 会读越界。第二个紧耦合机制是同步与生命周期：线程把 tile 写入 shared memory 后要在消费前执行 `__syncthreads()`，消费完成后还要同步，才能让下一轮覆盖同一槽位。这个同步只约束 CTA 内线程，并不等价于 kernel 完成、stream 顺序或 host 可见性。CUTLASS 的 collective mainloop 把这些阶段封装为 producer/consumer 迭代器和 MMA 原子；本例是独立改编，保留“加载—栅栏—计算—栅栏”的正确性合同，省略复杂的 CuTe layout、Tensor Core MMA 和 epilogue。`sm_110` 是唯一执行目标，不能用 CPU、Metal 或其他 GPU 结果推断 Thor 收益。FP32 baseline 与 tiled candidate 必须使用相同输入、累加顺序边界和输出比较；公平对照只改变数据复用方式。运行时应分开 H2D、kernel、D2H 与端到端时间，ncu 采集时固定 shape、warm-up、时钟策略并记录实际频率。不同架构只用于原理对照：Hopper 的 TMA/异步拷贝路径、Ampere 的 cp.async 条件与 Thor 的 cc 11.0 兼容性不能混写成已验证指令。

## 知识图谱
- 全局内存合并访问 → shared tile 复用 → `__syncthreads()` → FP32 FMA。
- 编译链：C++17 host → `nvcc -arch=sm_110` → PTX → SASS；缺 nvcc 时只保留候选，不伪造反汇编。
- 前置：二维 row-major、边界谓词、CUDA 错误检查；不能混淆 CTA 栅栏、stream 顺序和 host 同步。

## 编码练习
20–30 分钟：在 `src/gemm.cu` 为 tiled kernel 增加一个 `K` 非 16 对齐的输入，保持零填充、与 baseline 对照并报告最大绝对误差。自测（不附答案）：为什么把第二个 `__syncthreads()` 删除后，小 K 的结果可能偶发错误？

## 文件说明
`src/gemm.cu` 含 baseline/tiled 两个 Thor kernel；`src/cpu_check.cpp` 是独立 oracle；`GPU_GUIDE.md`（见下节）命令保持 sm_110；`source.json` 记录 CUTLASS 实际阅读范围；`verification.json` 记录边界。

## 编译与运行
```sh
sh systems_practice/daily/2026-10-28/run.sh
sh systems_practice/daily/2026-10-28/run.sh thor
```
Thor 环境还应执行 `nvcc -std=c++17 -O3 -arch=sm_110`。若生成 cubin：`cuobjdump --dump-sass build/gemm_sm110`；ncu：`ncu --set full --target-processes all --kernel-name regex:baseline|tiled ./build/gemm_sm110`。本机缺 nvcc 时命令失败必须保留原始摘要。

## 正确性验证
CPU Release 通过 `max_abs=0`；CUDA 目标验收要求两 kernel 与 host oracle 在随机、全零、负值、M/N/K 非整 tile 上误差≤1e-4，并检查 `cudaGetLastError` 与同步返回值。Mac 未验证 CUDA 编译、Thor 运行、PTX/SASS 和 ncu。

## 性能分析
公平报告四个域：H2D、kernel、D2H、E2E；固定 warm-up 20、采样 100、同一 stream 与 shape。ncu 关注 `sm__pipe_fma_cycles_active`、shared load/store、branch efficiency、occupancy 和 barrier stall，并用 `--page raw --section SpeedOfLight_RooflineChart` 筛选；`cuobjdump --dump-sass` 只在真实 cubin 后分析指令依赖。Hopper TMA 仅作对照，不能宣称 Thor 使用 TMA。

## 实际运行结果
Mac CPU：`cpu_gemm_pass max_abs=0 tail_shape=3x5x7`。原 Mac 运行时无 NVIDIA 工具链/设备；后续 Thor 数值复核见文末，ncu 和性能仍待验。

## 工程注意事项
shared tile 只解决 CTA 内复用，不自动解决跨 kernel 生命周期；边界写零必须与布局一致；不要用 `sm_110a`。CUDA 版本、JetPack/驱动、ncu 版本和实际频率写入结果后再比较。

## 工业故障与面试追问
1. 尾块偶发 NaN：检查谓词和零填充，代价是分支；2. tiled 比 baseline 慢：检查小矩阵 launch、shared bank、occupancy 与同步停顿；3. ncu 计数器为空：检查权限/版本/clock-control；4. SASS 与源码不对应：固定 cubin、lineinfo 和编译选项。追问：栅栏的作用域？cp.async 与普通 load 的完成条件？如何公平隔离 H2D？为什么不能把 PTX 当 SASS？不同 SM 架构怎样做能力矩阵？

## 自测问题
在 `K=129` 且输入含 NaN 时，如何设计 oracle、边界谓词和 ncu 采样，才能区分数据错误、同步错误与性能回退？


## 固定栏目入口
量化：[FP8 scaling](../../quantization/2026-10-28/fp8_scaling/README.md)；ARM：[布局合同](../../arm/2026-10-28/README.md)；OS：[长期运行与故障恢复](../../os/2026-10-28/README.md)；C++17：[原子与发布可见性](../../cpp17/2026-10-28/README.md)；论文：[两篇论文](../../paper/2026-10-28/README.md)。这些是现成附加材料，不增加第二个主编码任务。


## 2026-10-29 Thor 实机复核

Thor 实机复核：修正基线二维网格、初始化输入并增加独立参考；两种 shape × 两 kernel 共 4 项通过；[完整记录](../../validation/2026-10-29-thor/fixed-retests.txt)。
