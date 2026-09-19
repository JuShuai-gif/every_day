# 2026-09-19 GPU 访存优化：Thor 特征转置的合并访问与 bank conflict

## 工业场景

双相机视觉编码器输出 FP32 `[B,T,C]=[2,197,128]`，下游逐通道模块需要 `[2,128,197]`。输入物理行距 131、输出行距 200，以模拟上游 workspace 的 padding；逻辑数学为 `out[b,c,t]=in[b,t,c]`。只搬运，不转换精度，要求逐值完全相等、padding 不变、不越界。本练习不支持原地转置。机器人帧预算中这一步不能靠“理论带宽”验收：测量 kernel P50/P95 和 H2D→kernel→D2H→等待的局部端到端时延，再由部署者分配预算。无实测 SLA、功耗或收益承诺。

## 概念回顾

转置的困难不是乘加，而是同一组线程在输入与输出中面对不同的连续方向。让一个线程处理一个元素，可以使读地址相邻，却会让写地址跨越整行；有效数据量没有增加，实际访存事务却可能变多。优化首先要区分逻辑形状与物理行距，再把线程编号映射到地址，不能只看数组下标是否相邻。双相机的批次偏移也要按物理容量计算，否则单张图正确的实现仍会污染下一张图。

共享内存提供一次块内重新排列的机会：线程先沿输入行合并读取，所有生产者到齐后，换一组坐标沿输出行写回。这两个阶段由块级屏障连接。尾块中没有有效元素的线程也不能提前退出，因为其他线程仍可能需要它参与同步；读写两侧分别检查转置后的边界，保证每次有效共享读取都有对应写入。这样的优化改变搬运路径，不改变数据内容与输出数量。

共享内存自身也有访问布局。对于本练习的三十二位标量模型，列读取跨越三十二个字时，不同线程可能落到同一个存储体；行距增加一个字可使地址分散。它只增加少量共享空间，却可能降低重复服务请求，代价是资源分配粒度可能影响驻留块数。因此必须用未填充版本隔离全局合并收益，再用填充版本隔离共享冲突，不能把两项变化混为一种证据。

验证与测量同样耦合：先用带物理填充的矩形和不足整块的输入检查唯一写者，再在相同输入上比较各版本。输出预先污染，防止漏写被旧结果掩盖。计时区间内不做分配，预热后重复采样；分析器重放与缓存控制会改变条件，报告中的停顿位置也未必是根因。没有目标设备时，主机只能证明索引契约，不能证明并发安全或性能。

## 知识图谱

`Shape/物理stride → lane地址 → 全局事务 → shared重排 → bank映射 → CTA barrier → 输出所有权`。

| 耦合点 | 本期代码连接 | 前提与不能混淆的概念 |
| --- | --- | --- |
| global合并 + shared bank布局 | `transpose_naive` → `transpose_tiled<0,8>` → `<1,8>` | 合并不是缓存命中；bank conflict不是global地址对齐 |
| 尾块guard + 同步 | 两个坐标系的guard包围搬运，无条件barrier | CPU顺序模拟不验证CUDA并发；warp同步不替代跨warp CTA同步 |
| logical bytes + physical stride | `Shape`、`oracle`、计时 | useful GB/s不是DRAM实际流量；局部E2E不是整个机器人响应 |

源码先读后实现：仓库 [NVIDIA-developer-blog/code-samples](https://github.com/NVIDIA-developer-blog/code-samples)，读取日期 **2026-09-19**、分支 master；具体 [series/cuda-cpp/transpose/transpose.cu](https://github.com/NVIDIA-developer-blog/code-samples/blob/master/series/cuda-cpp/transpose/transpose.cu) 的 `transposeNaive`、`transposeCoalesced`、`transposeNoBankConflicts`。已通过网页工具实际读取实现，不是仅看首页。原场景是方阵转置带宽示例；本期**机制改编**保留32×32 tile、分阶段重排、padding，改为批次/矩形/尾块/独立stride、RAII与持续错误检查，省去其copy带宽对照。不是原项目原样代码或Thor性能复现。归属/许可见 [NOTICE](NOTICE)。最初 cuda-samples 路径请求返回404/cache miss，本机curl DNS失败见 [原始日志](results/source-fetch.txt)。

## 编码练习

**唯一编码任务，25分钟：把填充tile的每块线程行数从8改为4，并给出可复核的选择。**

1. 5分钟：沿`transpose_tiled`推导一个尾块元素的写者和读者。
2. 10分钟：在你的本期副本中将最终分支切至`<1,4>`（完整候选 variant 3 已备好），同步修改block尺寸；不能改tile、Shape或计时边界。
3. 5分钟：运行CPU契约检查；Thor上运行四版本sweep与sanitizer。
4. 5分钟：对比variant 2/3的P50/P95、寄存器、active warps、shared事务。缺Thor时交付索引证据和待验表，不推断赢家。

已交付默认最终候选 **variant 2 `<1,8>`**，收益未验证。variant 0是正确性基线，1隔离合并访问，3是线程数取舍对照。教学CPU检查已覆盖4行配置，不需要新增第二项作业。

## 文件说明

- [src/transpose.cu](src/transpose.cu)：四个Thor候选、真实inline PTX、RAII、正确性及计时。
- [src/layout.hpp](src/layout.hpp)、[src/cpu_check.cpp](src/cpu_check.cpp)：独立oracle、物理stride和唯一写者检查。
- [run.sh](run.sh)、[CMakeLists.txt](CMakeLists.txt)：C++17，CPU/CUDA构建分开。
- [OPTIMIZATION.md](OPTIMIZATION.md)、[profile.sh](profile.sh)、[export-isa.sh](export-isa.sh)：ncu、ISA与Hopper对照。
- [每日AWQ栏目](quantization/awq/README.md)：已读固定版本源码的原生裁剪/打包示例；本地克隆失败、执行待验，不增加作业。
- [验证记录](results/verification.json)：明确源码、CPU、GPU和工具状态。

## 编译与运行

在EveryDay根目录运行，无需安装任何依赖即可使用本机已有CMake/C++17：

```bash
sh systems_practice/2026-09-19/run.sh cpu
sh systems_practice/2026-09-19/run.sh sanitize
```

目标仅Jetson Thor CC11.0：官方 [JetPack 7.0归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0) 列出Jetson Linux38.2/38.2.1、Ubuntu24.04、CUDA13.0.0组合；这是已核实的参考组合，不代表当前设备驱动已检查。[PTX9.0](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#ptx-module-directives-target)引入`sm_110`命名。现场记录`nvcc --version`、`cat /etc/nv_tegra_release`、`nvidia-smi`和程序打印的driver/runtime，禁止把一个组件版本视为全部兼容。

```bash
sh systems_practice/2026-09-19/run.sh gpu --all
systems_practice/2026-09-19/build/gpu/transpose --sweep
compute-sanitizer --tool memcheck systems_practice/2026-09-19/build/gpu/transpose --sweep
compute-sanitizer --tool racecheck systems_practice/2026-09-19/build/gpu/transpose --sweep
compute-sanitizer --tool synccheck systems_practice/2026-09-19/build/gpu/transpose --sweep
sh systems_practice/2026-09-19/profile.sh 2
sh systems_practice/2026-09-19/export-isa.sh
```

所有CUDA构建固定`sm_110`，程序拒绝非11.0设备。其他架构仅对照，不提供其他目标构建命令。

## 正确性验证

CPU Release/ASan/UBSan实际验证196个Shape×3种tile配置：B=1/2，行列跨1、31/32/33、65/67等，紧凑和+3stride，独立oracle、输出覆盖、唯一写者和padding保护；4种非法Shape必须抛异常。GPU sweep预设同样196个Shape×4版本，输出有效位置每次先填NaN，padding填sentinel，禁止复用旧结果；逐值完全相同。CPU模拟共享重排只证明索引，不证明barrier安全或PTX可编译。主机结果不替代GPU sanitizer。

## 性能分析

具体步骤见 [OPTIMIZATION.md](OPTIMIZATION.md)。GPU event围住单个kernel，20次预热、100次采样；局部E2E同样20+100，CPU墙钟覆盖pageable H2D、launch、kernel、D2H与等待，不含分配、输入生成或整机流水线。CPU仅正确性辅助，无CPU性能对照；NPU不参与。useful字节为`2×B×T×C×4`，不是硬件事务流量。小输入可能受启动/缓存主导，必须保留无收益结果。

## 实际运行结果

| 验证/指标 | 结果与证据 |
| --- | --- |
| Mac Release | 196×3配置及4个非法输入通过；[cpu.txt](results/cpu.txt) |
| Mac ASan/UBSan | 同样通过；[sanitize.txt](results/sanitize.txt) |
| bank地址模型 | pad0最大重复32，pad1最大重复1；纯数学模型，不是Thor计数器 |
| CUDA编译/执行/精度 | 未验证；配置失败`Failed to find nvcc`；[gpu.txt](results/gpu.txt) |
| ncu / 实际PTX与SASS | 未生成，缺ncu/nvcc；[profile.txt](results/profile.txt)、[isa.txt](results/isa.txt) |
| GPU kernel/E2E P50/P95、GB/s、功耗 | 全部未测，不填写预测收益 |

## 工程注意事项

默认路径不是原地转置，输入输出不得别名；stride按元素计。shared多128字节不等于occupancy必定下降，需看实际资源分配。CPU不使用计时来推断GPU快慢。具体兼容性和编译指令见优化说明；所有后缀专属特性都不进入本期可执行代码。清理阶段CUDA错误会报告，但不从析构抛异常。频率、温度、功率模式、后台负载需要随Thor数据一起记录。

## 工业故障与面试追问

以下是本代码约束推导的排障案例，尚无Thor现场复现，不是实测事故：

| 触发→现象 | 根因 | 最小诊断→修复/取舍 |
| --- | --- | --- |
| T=197→最后几行错/未写 | floor grid或两侧沿用同一guard | NaN输出+sweep→ceil grid与独立边界 |
| batch2且stride有padding→第二相机错误 | 用logical宽度算batch偏移 | sentinel与B=2 oracle→按物理容量偏移 |
| tile版本仍慢→shared事务增加 | 列读取bank重复，或启动开销已占主导 | ncu比较1/2及未profile时间→padding或保留基线 |
| 尾块超时/竞态→结果偶发变化 | guard内return绕过CTA barrier | synccheck/racecheck→barrier无条件，限制只包搬运 |

面试追问（基础→实现→边界→权衡）：

1. 连续lane地址为何仍可能多一次事务？行首对齐如何参与？
2. 为什么合并global访问不能证明shared无冲突？
3. 输出有效的shared读取如何找到对应输入生产者？
4. 为什么不能用`__syncwarp()`直接替代这里的CTA barrier？
5. 8行改4行对线程工作量、驻留块数和延迟隐藏各有什么影响？
6. profiler下更快、独立基准更慢时，应先核对哪些计时和缓存条件？

## 自测问题

若上游把FP32改成FP16，仍照搬`tile[32][33]`并把block行数从8改成4，能否仅凭“多一列避免冲突”和CPU测试通过就批准上线？请给出需要重新建立的地址模型、同步契约及Thor验收证据，暂不写结论。
