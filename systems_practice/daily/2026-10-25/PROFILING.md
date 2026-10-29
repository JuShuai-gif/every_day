# Thor SM110：从待测假设到指令证据

执行目标始终普通sm_110。理论比较接上次Ada，本次Turing SM75，下次Ampere。所有命令在本课目录运行。

## 定位、筛选和采集

1. `sh build.sh thor`使用-O3/-lineinfo/--fmad=false，不用-G。先`./build/rmsnorm`验100组合，再`./build/rmsnorm 257 513 both`取未附加profiler的事件时间。
2. `ncu --version`、`ncu --list-sections`、`ncu --query-metrics`核实当前设备可用项。`profile.sh`中的section是查询后应确认的常见名称；不支持就删掉该section并在记录写明缺项，不能将缺指标记零。
3. 每个独立进程只跑一个版本；`--kernel-name-base function --kernel-name regex:rms_warp --launch-skip 21 --launch-count 1`跳过1次正确性launch和20次预热，采第一个计时launch。base用对应名称。两版同257×513，避免全程序100用例混入报告。
4. `sh profile.sh`导出忽略的build/*.ncu-rep；`ncu --import build/rms-warp.ncu-rep --page raw --csv`看指标；`ncu-ui build/rms-warp.ncu-rep`打开Source页，选择rms_warp，切换CUDA/PTX/SASS相关行。缺本地源文件时添加源码搜索目录，不能把另一编译的地址套在当前binary上。
5. SpeedOfLight看计算/带宽占用；MemoryWorkloadAnalysis查global sectors、合并与local加载，验证“少读一遍”是否真的少了L2/DRAM事务；LaunchStats/Occupancy查registers/thread、shared和驻留限制；SchedulerStats/WarpStateStats查eligible warps与stall；SourceCounters将问题定位到具体load、shuffle或消费者。指标先查存在，再用`--query-metrics-mode suffix --metrics 指标基名`查询完整后缀，不照搬其他架构raw metric。

Profiler replay与cache控制会改变缓存热度；报告用来解释，不拿采集时间宣称提速。Thor用`--clock-control none`保留系统时钟策略并记录频率，不能宣称锁频；权限不足保留ERR_NVGPUCTRPERM并由设备管理员处理，不自动改系统配置。NVIDIA [CLI指南](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)的Quickstart/过滤、section、report部分已核查。

## PTX/SASS与潜在热点

`sh export-isa.sh`保存实际工具版本、PTX、cubin和带行信息的SASS；归档时只选文本与参数，不提交cubin/ncu-rep。当前nvcc缺失，**没有真实生成PTX/SASS**。

源码 `exchange` 中真实手写 `shfl.sync.bfly.b32`，distance依次16/8/4/2/1，clamp31、mask全32位，交换后执行FP32加法。PTX6.0引入同步shuffle，目标至少SM30；Thor用CUDA13普通sm_110编译这一通用语义。虚拟指令不保证一对一映射机器指令。[PTX规范](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#data-movement-and-conversion-instructions-shfl-sync)核查了语法、xor选择与参与者约束。

| 源码阶段 | 目标采集时要找的指令类别 | 支持哪种假设 |
| --- | --- | --- |
| 平方累加 | global load、FP32乘加或分离乘加 | long scoreboard需回看生产load、缓存和执行次数，不能仅怪停顿的消费者 |
| 基线shared树 | shared load/store与barrier | barrier等待是否支配短行；也可能是到达不均匀 |
| 候选蝶形 | shuffle→add串行依赖 | 五级结果依赖，吞吐高仍可能依赖等待 |
| 归一化 | rsqrt和依赖乘法 | 看执行频次与活跃warp，不能虚构单指令周期 |
| 保存values | 寄存器/潜在local spill | spill会用内存抵消少读输入的收益 |

本表是观察计划，不是反汇编清单。没有周期估计或“最慢指令排行”。

## 架构对照：Thor与Turing

Turing为SM75，CUDA10开始提供对应Tensor Core API，新增整数矩阵能力，INT8/INT4输入与INT32累加，子字节fragment有特定tile与布局约束；独立线程调度来自Volta，不能称Turing独创。Thor SM110属于Blackwell系列，普通目标由CUDA13支持；本课只用FP32 SIMT、同步shuffle，未启用低位矩阵指令及任何a/f专属特性。[Turing指南](https://docs.nvidia.com/cuda/turing-tuning-guide/index.html)已核查线程调度、共享内存与Tensor Core章节。

两代都要求参与线程与同步合同正确；不能拿Turing寄存器容量、occupancy上限或FMA周期直接解释Thor。矩阵指令不适合直接替换这一行平方和：强行构造GEMM会增加布局/无用计算，且可能改变误差合同。NF4也不是INT4，不存在把nibble直接传给整数Tensor Core就等价的捷径。Thor实板dtype支持、扩展编译、ncu版本与机器指令仍待验；本课没有任何Turing执行或构建命令。
