# Thor SM110：转置优化与证据链

## 版本和公平对照

| variant | 实现 | 假设 | 新成本 |
| --- | --- | --- | --- |
| 0 | `transpose_naive` | 连续global读、跨行写导致事务浪费 | 不用shared或barrier |
| 1 | `transpose_tiled<0,8>` | shared重排让读写方向分别连续 | 4096 B shared、一次CTA barrier、列读可能冲突 |
| 2（默认最终候选） | `transpose_tiled<1,8>` | padded shared行距解除本标量模型的列冲突 | 4224 B shared，增加128 B |
| 3 | `transpose_tiled<1,4>` | 更少线程、每线程更多元素 | 相同shared，更长每线程指令序列 |

所有版本同Shape/输入/FP32语义/精度/计时边界/20+100次数。0→1比较global事务；1→2隔离shared布局；2→3比较调度取舍。编译优化级别均Release。没有GPU数据，以上均为假设；不可从CPU bank模型的32→1推导32倍提速。

## ncu：定位、筛选、采集、关联

在Thor本机先用README的独立基准确认正确性与时延，再运行：

```bash
ncu --version
ncu --list-sections
ncu --query-metrics > systems_practice/daily/2026-09-19/build/metrics.txt
rg 'sectors|bank_conflicts|wavefronts|eligible|long_scoreboard|short_scoreboard' systems_practice/daily/2026-09-19/build/metrics.txt
sh systems_practice/daily/2026-09-19/profile.sh 0
sh systems_practice/daily/2026-09-19/profile.sh 1
sh systems_practice/daily/2026-09-19/profile.sh 2
sh systems_practice/daily/2026-09-19/profile.sh 3
ncu-ui systems_practice/daily/2026-09-19/build/profile/v2.ncu-rep
```

脚本保存版本、实际可用section/metric清单。若某section在安装版本不存在，先查清单，编辑该次本地采集选项并记录缺失，不假称已经采到。kernel过滤表达式匹配naive/tiled的demangled名称；`--profile-from-start off`与程序profiler API区间确保20次预热在外，仅目标launch在内，`--launch-count 1`进一步限定。sweep与profile不能同时开启。不要拿`--all`配一个易变的launch-skip数字。

| 待验证假设 | 证据/section | 什么结果才支持改动 |
| --- | --- | --- |
| global写未合并 | MemoryWorkloadAnalysis内store sectors、请求数、L1/L2/DRAM流量 | 0→1同有效字节事务降低；并核对实际time，不要求DRAM满载 |
| shared冲突 | shared load wavefronts、bank conflicts、ideal/actual工作量 | 1→2多余服务量减少；最终以未附加ncu的P50/P95复核 |
| 资源限制 | LaunchStats、Occupancy：register/thread、shared/block、active blocks/warps | pad或线程数改动是否跨分配阈值，不能只看occupancy百分比 |
| 依赖等待 | SchedulerStats、WarpStateStats、SourceCounters | eligible warps与scoreboard/barrier采样关联到具体指令和生产者 |
| 小kernel启动主导 | SpeedOfLight + GPU event + 局部E2E | 带宽低但事务改善不降低时间时，考虑融合/消除转换而非堆新指令 |

具体metric拼写以现场查询为准。默认replay/cache控制可能使小张量缓存状态不同，采集报告用于诊断，收益来自独立基准。查看Source页时添加本目录源码搜索路径，选同一kernel，关联CUDA行→PTX→SASS地址；保持生成报告时的源码与二进制不变。权限错误、unsupported GPU或计数器缺失须保存原始信息。

已核实[Nsight Compute发布说明](https://docs.nvidia.com/nsight-compute/ReleaseNotes/index.html)：2025.3增加CUDA13.0支持；当前支持表包含GB10b，已知问题说明Thor的`--clock-control`无效。这不证明任意旧ncu/驱动组合可用。记录现场ncu、JetPack/L4T、CUDA driver/runtime与权限；本Mac无ncu，尚无版本组合实测。

## PTX / SASS与潜在热点

[src/transpose.cu](src/transpose.cu)中`load_global`含真实手写`ld.global.f32` inline PTX，两个实现使用相同load语义。它是源码，不是已编译结果。执行[export-isa.sh](export-isa.sh)后才会得到实际`transpose.ptx`、`transpose.sass`、ptxas资源统计和工具链版本；本机尝试因缺nvcc失败，未生成SASS。

| 源码阶段 | 需要在真实ISA中定位的操作类别 | 可能根因，不是已测结论 |
| --- | --- | --- |
| 计算batch/stride偏移 | 整数乘加、地址扩展与谓词 | 小kernel地址指令占比；不要把整数运算删除到错误的紧凑布局 |
| `load_global` | global load→shared store或global store依赖 | L1/L2未命中或load返回等待；consumer停顿不等于consumer本身慢 |
| shared转置读 | shared load及随后global store | pad0 bank重复服务造成依赖等待；pad1仍有真实读延迟 |
| 无条件barrier | CTA同步操作及其前序load/store | 不同warp到达不齐；同步指令采样不能单独证明同步可删 |

PTX是虚拟ISA，SASS由ptxas决定，禁止预先指定某条SASS一定出现或标注周期数。`-lineinfo`保留源码关联而不启用`-G`调试优化禁用；编译参数、source hash、设备状态应和结果一同留存。吞吐、单条延迟、执行次数与依赖stall要分开解读。

## 架构对照：固定Thor，对照Hopper H100

今天相较上一期转向 **Hopper TMA/bulk copy** 对照；执行目标仍只有`sm_110`。

| 对照项 | Hopper H100 SM90 | Thor SM110 | 本kernel选择 |
| --- | --- | --- | --- |
| shared重排+标量load/store | 沿用机制，不是Hopper独有 | 沿用机制，不是Thor新指令 | 实际使用，避免引入无重叠收益的复杂协议 |
| TMA与`cp.async.bulk`基本形式 | Hopper强化异步张量搬运；PTX8.0，基本bulk要求SM90+ | PTX9.0固定SM110，可采用满足条件的基本形式 | 未使用；单tile即读即写，无计算流水隐藏空间 |
| bulk的目标、大小、完成机制 | 原始global→shared::cluster与mbarrier；16B对齐/大小约束须满足 | 仍须满足地址、mbarrier生命周期和完成协议 | 输入stride131×4=524B不能直接当成每行16B对齐 |
| multicast专属优化建议 | 文档建议SM90a目标 | 文档建议SM110f/a等目标 | 本期禁止切后缀，因此不采用，不将“能写指令”等同于快 |

一手依据：[Hopper tuning guide的TMA章节](https://docs.nvidia.com/cuda/archive/13.0.0/hopper-tuning-guide/index.html#tensor-memory-accelerator)、[PTX9.0 bulk copy](https://docs.nvidia.com/cuda/archive/13.0.0/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-cp-async-bulk)。基本bulk的PTX8.0工具链基线为CUDA12.0；本期Thor的最低工程基线另为CUDA13.0/PTX9.0。这里不把H100的资源上限、带宽或tensor-map扩展泛化到Thor，也不默认基础SM110支持所有a/f指令。FP32搬运不利用Tensor Core；无TMA与当前tile性能比较数据。
