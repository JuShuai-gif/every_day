# 2026-10-21 ARM 第26课：从A64热点到PMU证据

## 本节要学会解释的ARM问题

承接第25课能力分派：NEON转换明显更快，怎样判断减少的是指令开销还是访存等待？5–10分钟速览：先看同一内核的真实A64主体，再看Linux PMUv3事件映射，最后用固定核、同计量域的统计验证假设。完整正文保留采样与迁移边界。本课对应第三层“证据驱动优化”，工作对象为连续1048576个FP32到INT8的转换，不是完整推理部署。

## 数据或状态如何变化

| 阶段 | 对象/单位 | 可以说明什么 |
| --- | --- | --- |
| C++/NEON | 每轮8个数，逻辑读32B写8B | 固定数学工作量 |
| A64汇编 | FCVTAS 4S、SQXTN 4H/8B | 编译器选择的指令路径 |
| PMU硬件事件 | cycles、retired instructions | 已选CPU、权限和计量域内的计数 |
| perf缩放 | raw×time_enabled/time_running | 复用时的估计，非完整直接计数 |
| 业务验收 | 单请求端到端P95 | 还需排队、设备、传输和温控数据 |

同是AArch64并不保证PMU raw编码相同。Linux PMUv3驱动把通用instructions映射INST_RETIRED、cache-misses映射L1D_CACHE_REFILL；后者不是所有平台通用的LLC miss，也不是DRAM字节数。PMCEID约束事件支持。Apple CPU在Linux另有专用PMU驱动，不能把macOS当前运行等同Linux PMUv3采样。

## 实现与ARM机制逐项对应

[probe](src/main.cpp)复用[主课quantize.hpp](../../daily/2026-10-21/src/quantize.hpp)，相同输入、相同scale与期望输出，只在进程启动时选择scalar/neon。每次8轮预热后执行1000次转换；计时在输出检查前结束，包含函数调用/循环与compiler barrier，不包含生成数组、参考计算和校验。

实际[汇编](results/native-arm64.s)中NEON主体的关键顺序：

```asm
ldp q3, q4, [x9, #-16]
fmul.4s v3, v3, v0[0]
fcmeq.4s v5, v3, v3
and.16b v3, v5, v3
fmin.4s v3, v3, v1
fmax.4s v3, v3, v2
fcvtas.4s v3, v3
sqxtn.4h v3, v3
```

第二个向量计算后用SQXTN2合并到8×16bit，再SQXTN成8×8bit，STR D写8B。Q寄存器128位、D寄存器64位，FCVTAS的4S是四个32位lane，SQXTN不是低字节直接截取。NaN自比较产生零掩码，避免后续转换歧义。依赖顺序是load→乘法→范围处理→转换→窄化→store；指令数量不能直接推出每轮周期，后端可交错多个操作。标量函数关闭loop vectorization，NEON尾部仍可自动向量化，不能把尾部FRINTA路径漏掉。

逻辑流量5N=5MiB/调用；1000调用共5000MiB逻辑读写。重复热数据可能被cache服务，因此不能用这个数字声称实测DRAM带宽。假设H1为指令开销减少：要同时观察总instructions及cycles随版本下降；H2为内存等待主导：需要已核验的cache/refill事件、工作集扫描和采样证据。IPC上升或下降单独都不能证明根因。

## 现成对照与观察步骤

```sh
sh systems_practice/arm/2026-10-21/run.sh scalar
sh systems_practice/arm/2026-10-21/run.sh neon
MODE=sanitize sh systems_practice/arm/2026-10-21/run.sh neon
# 仅Linux AArch64目标，先从lscpu/sysfs选同一个实际核：
CPU=选定的核号 sh systems_practice/arm/2026-10-21/profile-linux.sh
```

[profile-linux.sh](profile-linux.sh)先收集内核、拓扑、perf版本和事件清单，再以用户态cycles/instructions成组计数，保存复用比例；若group排不进计数器而显示not counted，改少量分开测并记录条件变化，不能把空值当0。record采样定位热点，report/annotate关联符号与源行。perf stat计量整进程（含初始化/预热/校验），程序hot_loop_ms只计转换；两者边界不等，不能混合相除计算循环IPC。

在真实Cortex-A76/A55、Neoverse-V3AE上分别确认PMU名称、cpu mask、用户态权限、具体事件及频率，再绑定同一类核。先用通用cycles/instructions，后续cache事件只从该板perf list和对应TRM选；本课不提供跨核通用raw编码。没有权限时保留错误，不自动修改sysctl。

## 工作场景排障与优化取舍

1. **计数为0/不支持**：先看not supported/not counted、权限和运行比例→对照PMCEID支持与实际PMU cpu mask→换成该核支持的事件或缩小group；绝不能把权限失败解释为零cache miss。
2. **同程序IPC漂移**：可能迁核、PMU复用、DVFS或工作集变化→固定核、记录time_running/enabled与频率，重复同工作量→先控制采样条件；固定核可能牺牲调度弹性和功耗表现。
3. **热点落在消费者指令**：采样可能有skid且等待来自更早load→结合依赖、访存事件与源代码→不要仅因FCVTAS附近样本多就宣布它延迟最高；可退回较少事件的重复采集。

Linux目标可用`perf record -g`和`perf annotate`定位符号，编译必须保留-g与frame pointer；本课脚本使用-O3 -g构建，但调用栈完整性还受编译器影响，必要时用DWARF unwind。不得将采样运行耗时当无profiler基准。

## 来源、真实结果与下一节

2026-10-21实际读[Linux v6.12 arm_pmuv3.c](https://github.com/torvalds/linux/blob/v6.12/drivers/perf/arm_pmuv3.c)的 `armv8_pmuv3_perf_map`、cache map、`armv8pmu_set_event_filter`（exclude_user/kernel、TH支持检查）及 `armv8pmu_user_event_idx`。GPL-2.0-only；本例为独立观察程序，没有复制驱动。实际读[ncnn量化主体](https://github.com/Tencent/ncnn/blob/master/src/layer/arm/quantize_arm.cpp)与helper，详情见主课来源；[ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)核对FCVTAS对应。

搜索得到[Arm官方PMU案例](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/p2-perf-pmu-feature-armv8-cpus)的复用说明；仅搜索返回内容已读，不声称完整正文。Arm Learning Path direct fetch因不支持text/markdown失败。Google/知乎直访失败见主课来源记录；Linux具体源码作为一手替代。

本地资料实际只读 `ARM-MMU/MMUAdvanced/MMU-Chapter 26 Debugging Tools, Tracing & Instrumentation.pdf` 物理第1页文本，SHA256 `08f5044cf5d890eca5d746d85887aeed505000d58aebd2c0919f5203764bb0b5`。该页声明RTOS/QNX调试范围，仅作选题提纲，不作为Linux PMU事件依据；未查看后续页、未渲染、许可未确认。没有复制PDF。

[scalar](results/scalar.txt)与[neon](results/neon.txt)1000调用hot-loop单次观测719.671ms/104.467ms；不是P50，更不是单请求P95。公平分布测量见主课11批结果。[ASan/UBSan](results/sanitize.txt)通过，错误参数返回1见[rejected](results/rejected.txt)。真实A64已观察；本机没有perf、没有Linux目标或板卡，PMU、Cortex/Neoverse性能、功耗和端到端未验证。本日期目录不生成JSON。

下一节27：CPU–加速器流水线，继续区分主机已提交与设备已完成。

## 迁移验收与面试追问

验收清单：核对CPU型号/拓扑与工具版本；正确性跑过主课1404组；记录事件名字、计量域和复用比例；保存原始stat/record与符号；在无profiler情况下复测；端到端无收益时不以微基准替代上线结论。Mac Mach-O产物不能直接部署Linux ELF，须目标构建。

追问：①通用cache-misses在该驱动映射何处？②PMCEID解决什么？③复用后计数为何是估计？④为何固定核仍需记录频率？⑤采样热点为何可能指向消费者？⑥如何把内核收益与请求P95关联？
