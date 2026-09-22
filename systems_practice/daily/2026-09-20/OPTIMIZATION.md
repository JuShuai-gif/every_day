# Thor SM110：归约优化、Nsight Compute 与指令验收

本文件中的性能解释均为待验证假设。没有nvcc/ncu/Thor，未生成真实PTX/SASS，不填写指令周期或速度提升百分比。

## 1. 从基线到完整候选

`row_reduce<1,128>` → 单条循环携带累加依赖可能限制就绪操作 → `row_reduce<4,128>`用4个独立值，再合并 → 675个CPU合同比较通过 → GPU精度和性能待验。`Acc=2/8`及四链256线程用于分辨ILP与资源台阶，不把多项变化同时归因于一个机制。候选未使用async copy或Tensor Core：行内输入只使用一次，搬入shared会增加一次搬运；FP32 sum也不需要低精度矩阵运算。

主机 `cudaFuncGetAttributes` 打印实际编译后的regs/shared/local；`cudaOccupancyMaxActiveBlocksPerMultiprocessor` 查询理论活跃块数。它不考虑网格是否够大，也不能替代ncu实际occupancy。优化是否成功要在正确性相同前提下用非profiler基准确定。

## 2. 板端版本与运行

从项目根目录执行，仅Thor11.0。先核实参考JetPack与安装版本，记录结果；不自动安装或改电源配置。

```bash
mkdir -p systems_practice/daily/2026-09-20/build/profile
cat /etc/nv_tegra_release
uname -a
nvcc --version
ptxas --version
ncu --version
nvidia-smi
sh systems_practice/daily/2026-09-20/run.sh gpu --sweep
compute-sanitizer --tool memcheck systems_practice/daily/2026-09-20/build/gpu/row_reduce --sweep
compute-sanitizer --tool racecheck systems_practice/daily/2026-09-20/build/gpu/row_reduce --sweep
compute-sanitizer --tool synccheck systems_practice/daily/2026-09-20/build/gpu/row_reduce --sweep
sh systems_practice/daily/2026-09-20/run.sh gpu --all
sh systems_practice/daily/2026-09-20/run.sh gpu --all --small
```

工具链基线CUDA13.0/PTX9.0、参考JetPack7.0配套L4T38.2.x；ncu2025.3+为待设备确认的采集组合。实际驱动包/ncu patch/MIG配置未知。官方发行说明指出Thor的ncu `--clock-control`不生效，因此脚本设none，不声称锁频；温控与功耗读数由板端另行留证。

## 3. ncu定位、筛选、采集和源码关联

1. `ncu --list-sections` / `ncu --query-metrics`先查询本机支持集；脚本保存到build/profile。若某section不存在，按列表选择等价section并记录差异，不能忽略失败后宣称有指标。
2. `sh systems_practice/daily/2026-09-20/profile.sh 0` 和 `.../profile.sh 2`：先正常运行验证和基准，再以demangled `regex:row_reduce.*`筛选实例。程序预热20次，仅在cudaProfilerStart/Stop内launch一次；`--profile-from-start off --launch-count 1`避免误采初始化或其他变体。
3. 输出 `build/profile/v0.ncu-rep` 与 `v2.ncu-rep`。`ncu --import ... --page details`导出文本；GUI `ncu-ui build/profile/v2.ncu-rep`打开，Source页选择CUDA/PTX/SASS并映射当前 `src`。使用带lineinfo的二进制，源码必须与报告构建一致。
4. 权限失败保存 `ERR_NVGPUCTRPERM` 或实际错误，让板端管理员按既有权限流程处理；不把空报告当成功。Profiler replay会重放并改变cache/执行条件；ncu用于解释，生产收益用正常100次采样结果。

| 问题 | section与可查询候选指标 | 证据如何影响选择 |
| --- | --- | --- |
| 算力还是内存受限 | SpeedOfLight；`sm__throughput.avg.pct_of_peak_sustained_elapsed`、`dram__throughput.avg.pct_of_peak_sustained_elapsed` | 对照L2/DRAM和网格大小，不能只看一项百分比 |
| 是否意外增加访存 | MemoryWorkloadAnalysis；global load sector/request、local load/store、L2 hit | ILP不应减少数学输入量；local增加可能是spill。cols=4097行stride还会影响对齐 |
| 寄存器/块资源 | LaunchStats、Occupancy；`launch__registers_per_thread`与限制因子 | 资源台阶变化才支持“更多累加器减少驻留块”的归因 |
| 调度是否改善 | SchedulerStats、WarpStateStats；eligible/issued/active warps、long/short scoreboard | active高而eligible低需要看依赖，不能继续盲增occupancy |
| 热点在哪 | SourceCounters；源码/SASS相关stall与执行计数 | 对齐partial的load/add、shuffle消费者、barrier和首warp阶段 |

候选指标是查询关键词，存在性以所装ncu/Thor返回为准；脚本使用section而非硬编码全部底层指标，缺项必须说明。命令手册：[Nsight Compute CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。

## 4. 真实inline PTX与最终机器码

`warp_sum`内的 `shfl.sync.bfly.b32`是实际可编译候选代码，不是从编译器输出复制。operand为FP32寄存器的32-bit位模式；delta取16/8/4/2/1，clamp31，mask覆盖全warp。第一阶段所有线程参加；第二阶段整个首warp参加，未承载部分和的lane补零。PTX在[ISA9.0的shfl.sync](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-shfl-sync)定义，真实汇编待验证。

```bash
sh systems_practice/daily/2026-09-20/export-isa.sh
# 脚本等价核心命令，所有目标固定sm_110：
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v \
  systems_practice/daily/2026-09-20/src/row_reduce.cu \
  -o systems_practice/daily/2026-09-20/build/isa/row_reduce
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx \
  systems_practice/daily/2026-09-20/src/row_reduce.cu \
  -o systems_practice/daily/2026-09-20/build/isa/row_reduce.ptx
cuobjdump --dump-sass systems_practice/daily/2026-09-20/build/isa/row_reduce \
  > systems_practice/daily/2026-09-20/build/isa/row_reduce.sass
cuobjdump --dump-resource-usage systems_practice/daily/2026-09-20/build/isa/row_reduce
```

PTX虚拟寄存器不等于SASS物理寄存器；ptxas可展开/重排和标量化。保存nvcc/ptxas版本、编译参数、目标及二进制hash，再从报告选择每个模板实例；源码行标记只是关联线索，优化后的多条机器指令可能映射同一行。报告/二进制在忽略的build内，实测后只选少量真实文本归档。

潜在热点顺序：

- `partial`的全局load之后，add消费者可能因数据未就绪出现long scoreboard；需辨别缓存miss、访存次数与地址合并。消费者被采样到并不证明add本身慢。
- 单链加法有循环携带依赖；多链可能提供更多可发射指令，但尾部predication和最终combine也增加控制/依赖。不能从PTX数量直接推出设备周期。
- warp shuffle之后的加法依赖跨lane结果；shared写→barrier→shared读是跨warp阶段。barrier停顿可能源于到达时间不均，而非指令固定成本。
- 寄存器spill产生local memory访问，logical local仍由设备内存层级服务。用资源日志与ncu事务共同判断，不把源码数组自动视为shared或寄存器。

## 5. 固定Thor，对照Ampere的特色指令

| 机制 | Ampere A100（仅原理对照） | Thor SM110（唯一执行目标） | 本kernel选择 |
| --- | --- | --- | --- |
| warp整数redux | SM80引入原生32-bit有/无符号add/min/max、无符号逻辑归约；PTX7.0，sm80以上；CUDA11代起 | 不是Thor独有；基线支持条件仍按PTX指令项核实 | 本题FP32，不能用整数redux偷换类型；采用shuffle+浮点add |
| shuffle sync | 早于Ampere，PTX6.0；有效参与mask与32-bit寄存器交换 | 同样要求参与者和来源lane合法，不是Blackwell专属 | 真实inline PTX，无a/f特性 |
| occupancy/ILP | SM80可驻留资源有特定上限，不能泛化成所有Ampere产品 | 用实际device prop、func attributes、occupancy API查本机，不照抄A100上限 | 五实例同输入、同容限测量 |

依据：[Ampere Tuning Guide的warp归约与occupancy](https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html)，[PTX redux支持条件](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#parallel-synchronization-and-communication-instructions-redux-sync)。整数归约不是低位Tensor Core矩阵乘。此比较不生成任何非SM110执行命令，不切换专属后缀，也不宣称Thor上所有Blackwell产品指令均相同。
