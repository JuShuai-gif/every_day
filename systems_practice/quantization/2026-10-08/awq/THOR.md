# Thor SM110：W4A16解码GEMV的采集与ISA证据计划

## 工具链边界

所有可执行命令只生成`sm_110`，无a/f后缀。NVIDIA[计算能力表](https://developer.nvidia.com/cuda/gpus)确认Thor T5000/T4000=11.0；[JetPack](https://developer.nvidia.com/embedded/jetpack)确认Thor SBSA/统一CUDA13路径。[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/)target章节确认sm_110从PTX9.0提供。不要用早期工具链的sm_101名字替代本课目标。当前Mac没有工具链；CUDA13具体patch、ncu版本、驱动/L4T组合未验。

目标机先保存`cat /etc/nv_tegra_release`、`uname -a`、`nvcc --version`、`ptxas --version`、`ncu --version`及程序设备属性；命令不存在也记失败。`thor.sh`先检查nvcc公开目标，再编译，禁止悄悄降目标。输出与日志保存在build，不提交二进制。

## 先证明结果，再定位kernel

`thor.sh`测试两个kernel的相同输入；浮点累加顺序变了，按相同容差对double oracle，不按位要求GPU两版相同。程序无参数跑63组M/N/K合同（含零输出）再基准；带任意参数只跑M1/N128/K1025用于ncu，避免过滤到小shape。预热10次，21样本，每样本100launch，CUDA event除100给批均值；不含分配/H2D/D2H，不是请求P95。运行时设备能力不是11.0则拒绝。

先在未附加profiler条件保留上述性能，再运行profile.sh。`--kernel-name-base function`用函数名，`regex:gemv_warp`/`regex:gemv_baseline`只选一版；`--launch-skip 11`跳过该匹配kernel的一次正确性launch和十次预热，采第一批第一次launch。检查ncu输出的grid与M/N/K是否吻合，不能只按report文件名推测shape。

## ncu问题→证据→取舍

脚本先`--list-sections`/`--query-metrics`保存安装版本实际支持项；`--set full`用于首次探索。下一次按本机列出的section名选择SpeedOfLight、MemoryWorkloadAnalysis、LaunchStats、Occupancy、SchedulerStats、WarpStateStats、SourceCounters（缺项按版本查询处理，不照抄不支持metric）。

| 问题 | 查证据 | 怎样判断 |
| --- | --- | --- |
| 跨输出stride是否浪费事务 | Memory Workload的请求/sector、L1/L2命中及DRAM字节 | 同输入warp候选sector效率改善才支持合并访问假设；byte重复加载可被cache合并，不能按源码load次数推DRAM |
| 串行链是否关键 | Scheduler/Warp State及源码stall分布 | FMA消费者等待与依赖相关，但long scoreboard更可能需追上游load；采样不是单指令周期 |
| warp版增加资源是否抵消 | LaunchStats寄存器、shared、实际/理论occupancy、eligible warps | 多warp并不自动隐藏延迟；小K或N不足时launch/调度开销可占主导 |
| 是否接近吞吐/带宽上限 | SpeedOfLight加执行时间 | 低利用率不单独证明算术太少，还要检查grid/launch/latency |

权限不足或不支持计数器时保留原错误，不当作metric=0。replay/cache控制可能改变cache状态；报告用于解释，收益由独立benchmark判定。目标GUI可用`ncu-ui build/gemv_warp.ncu-rep`打开，或`ncu --import ... --page source`导出文本。

## PTX/SASS与潜在热点

`thor.sh`带`-lineinfo -Xptxas=-v`生成SM110二进制、`--ptx`输出和`cuobjdump --dump-sass`。工具可用时再对照PTX `.target sm_110`，保留版本、参数、函数名和适量指令文本。源码`weight()`中真实手写inline PTX为`bfe.u32`，提取指定nibble，unsigned零扩展后减8；该指令从PTX2.0/sm20起支持，是沿用指令，不是Thor独有。

潜在链：global load→bfe→整数减8/转换→scale乘→FP32 FMA；warp版另有shuffle归约链。scale加载可重用/缓存，编译器也可能合并指令，必须看真实SASS才能分析。PTX是虚拟ISA，BFE可能降成不同SASS序列；这里**没有伪造生成SASS、固定周期数或最慢指令排名**。ncu源码视图用函数/源码行定位，再检查SASS地址对应的访存消费者与生产者，不能把采样停顿最多的那条指令直接当根因。

## 本次理论对照：Turing SM75

昨天Ada，本次轮换Turing。Turing新增低位整数Tensor Core路径，[官方tuning guide](https://docs.nvidia.com/cuda/turing-tuning-guide/)说明INT4使用8×8×32片段、INT32累加。PTX文档给出sub-byte WMMA从PTX6.3、sm75起支持，要求全warp按一致参数调用、正确fragment布局/对齐，四位两操作数都为s4或u4。历史工具链对应CUDA10时代的PTX6.3；本课仅作原理对照，**没有Turing构建或执行命令**。

Thor普通sm_110具有其基线特征集合，a/f专用能力不由“Blackwell”名称自动授权。本例A是FP16、W是按group解码的INT4；它既不满足Turing W4A4整数WMMA的两操作数合同，也未采用任何tcgen05或架构专属指令。要改成Tensor Core需重新设计输入类型、分组缩放、tile与误差合同，不能将当前标量FMA吞吐称原生INT4性能。Turing的矩阵指令信息也不能推出Thor的具体支持/速度；目标编译、反汇编和实测仍是门槛。

Thor代际特色的具体例子是第五代Tensor Core的`tcgen05.mma`族及Tensor Memory操作，与Turing的warp fragment接口不同。2026-10-08核对[PTX tcgen05.mma的Target ISA Notes](https://docs.nvidia.com/cuda/parallel-thread-execution/#tcgen05-mma)：该族从PTX8.6开始，Thor相关支持列的是架构/家族专用目标；`kind::i8`还有限定。普通`sm_110`并不因此获得这些专用接口。本课只作指令差异解释，固定普通`sm_110`命令不加入tcgen05候选，不使用专用后缀规避约束。ISA版本、数据类型、形状、内存描述符和目标特征必须同时满足，不能仅凭设备属于Blackwell就替换当前kernel。
