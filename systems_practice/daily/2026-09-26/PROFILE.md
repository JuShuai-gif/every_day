# Thor SM110：softmax 验收与指令定位

目标始终 `sm_110`。9月28日补课时本机无nvcc、ncu、NVIDIA设备；`results/thor.txt` 是真实失败。优化候选已交付，收益未知。
[官方JetPack下载页](https://developer.nvidia.com/embedded/jetpack/downloads) 读取2026-09-28：Thor/T5000，JetPack7.2.1、L4T39.2.1、CUDA13.2.2、TRT10.16.2。网页组合不是实机验收；板端先保存 `/etc/nv_tegra_release`、`nvcc --version`、驱动与 `ncu --version`，确认 `nvcc --list-gpu-code` 包含 sm_110。不得改为其他执行架构或专属后缀。

## 公平对照

`src/softmax.cu` 的 `softmax_serial` 与 `softmax_warp`：同一有限FP32输入、形状、数学语义和容限。192个GPU比较；默认最终候选warp，基线保留。优化假设：串行归约依赖长、跨行线程访存、输出重算指数；候选合并读取，缓存指数，warp归约。代价：短行浪费lane、寄存器压力、shuffle成本。缺硬件无法确认假设是否主导。

固定[1024,127]，20预热、100样本，两版本轮换先后顺序。kernel事件区间不含传输；request主机区间含H2D、kernel、D2H、同步，缓冲区已分配，输入为pageable，不能称零拷贝或完整机器人E2E。两者P50/P95由程序打印。不启用fast-math，不能用不同精度取巧。设备先执行：

```sh
bash run.sh thor
compute-sanitizer --tool memcheck build/thor/softmax
compute-sanitizer --tool racecheck build/thor/softmax
```

## ncu 定位、筛选、采集与关联

从本课目录、Thor设备执行。报告仅写忽略的build目录：

```sh
ncu --version
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
ncu --set basic --kernel-name-base function --kernel-name 'regex:softmax_.*' --launch-count 2 build/thor/softmax
# 前96个同名launch是正确性，随后20次预热各调用两次（kernel和request）。
# skip136 后采固定[1024,127]第一个测量kernel，baseline/candidate各自筛选。
ncu --kernel-name-base function --kernel-name 'regex:softmax_warp' --launch-skip 136 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -o build/warp build/thor/softmax
ncu --kernel-name-base function --kernel-name 'regex:softmax_serial' --launch-skip 136 --launch-count 1 --section SpeedOfLight --section MemoryWorkloadAnalysis --section LaunchStats --section Occupancy --section SchedulerStats --section WarpStateStats -o build/serial build/thor/softmax
ncu --import build/warp.ncu-rep --page details > build/warp-details.txt
ncu-ui build/warp.ncu-rep
```

先核对版本输出中的section名；某项不存在就从 `--list-sections` 选择等价项并记录更改，不能虚构采集成功。过滤后的skip语义也先通过小次采集确认，查看实际参数是[1024,127]。GUI进入Source，选择 `softmax_warp`，切到CUDA/PTX/SASS视图并关联 `-lineinfo` 的源码行；对闭源引擎内核不承诺有源码行。权限问题检查管理员给的性能计数器授权，不自动修改系统权限。

| 假设 | 应观察的证据 | 可支持的改动 |
|---|---|---|
| 基线跨行读取不合并 | MemoryWorkloadAnalysis的load sectors/request、DRAM吞吐；结合地址 | warp读取连续列 |
| 寄存器导致并发下降 | LaunchStats寄存器、Occupancy限制、spill/local访问 | 降低单线程缓存数量或按列数分派 |
| 长依赖限制发射 | SchedulerStats eligible/issued warps、WarpStateStats scoreboard/math stall | 更多独立行/累加，不能单凭某stall直接归因 |
| exp或除法主导 | Source页热点指令与执行次数，结合设备时长 | 数学等价复用；近似指令需另设精度合同 |

Profiler可能replay并改变cache状态，收益以未附加profiler的基准为准。GPU频率、功耗模式、温度另记，无板卡不填数。

## 真实 inline PTX 与生成命令

候选中的 `asm volatile("mov.u32 %0, %%laneid;" : "=r"(lane));` 是真实手写PTX，读取lane编号。不是编译器生成结果。下面命令生成本机实际工具链的虚拟ISA和机器ISA：

```sh
nvcc --version > build/nvcc-version.txt
nvcc -std=c++17 -arch=sm_110 -lineinfo -ptx src/softmax.cu -o build/softmax-sm110.ptx
nvcc -std=c++17 -arch=sm_110 -lineinfo -Xptxas=-v src/softmax.cu -o build/softmax-sm110 2> build/ptxas.txt
cuobjdump --dump-sass build/softmax-sm110 > build/softmax-sm110.sass.txt
cuobjdump --dump-resource-usage build/softmax-sm110 > build/resources.txt
```

PTX检查`.target sm_110`和函数边界；SASS用地址范围对齐Source页。源码热点段：global加载→max的shuffle串联→exp→sum shuffle串联→除法/写回。编译器可能将exp展开为特殊函数与范围处理，必须读真实产物才命名最终机器指令；不能伪造SASS或每条指令周期。本次没有PTX生成文件/SASS，只有上述真实inline PTX。

## 架构对照：Turing 与固定 Thor

本次轮换对照Turing SM75，仅讲原理，不提供该目标编译命令。[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#warp-level-matrix-instructions-ldmatrix) 的经典`ldmatrix`是Turing起的shared矩阵片段加载（PTX6.5、SM75条件）；矩阵协作要求整warp和规定布局。本课softmax并非矩阵乘，硬塞Tensor Core不解决指数归约。Thor虽有更新低精度矩阵能力，也不代表这个kernel应使用它；此处只使用普通SM110可用的线程束交换与FP32运算。新的低位ldmatrix变体具有额外ISA/架构条件，不能从旧变体支持推断全部支持。
