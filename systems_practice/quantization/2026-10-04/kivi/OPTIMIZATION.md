# Thor SM110：INT2缓存QK的串行点积与warp合作

目标固定Jetson Thor SM110。2026-10-04读取[NVIDIA CUDA13/Thor官方文章](https://developer.nvidia.com/blog/?p=105324)，确认JetPack7.0/CUDA13支持基线；[CUDA13.0.2发布记录](https://docs.nvidia.com/cuda/archive/13.0.2/pdf/CUDA_Toolkit_Release_Notes.pdf)列SM110 arm64-sbsa支持。它们不是当前实板驱动/ncu兼容验收。本机没有nvcc、ncu和Thor，三个命令实际失败；精确JetPack/L4T/driver/toolkit/ncu版本组合到设备再记录。

## 合同、优化与独立布局

[src/qk.hpp](src/qk.hpp)创建真实uint32数组：每个channel的16个token码放进一个word，word索引`(token/16)*D+channel`，LSB是最早token；scale/min索引`(token/32)*D+channel`，尾部安全零填。FP32 query、FP32 metadata、FP32累加，输出未除sqrt(D)的QK向量；CPU double是独立累加oracle。这与原Triton转置后的最后维打包不保证二进制互换，禁止直接喂原库缓存。

`qk_base`一线程计算一个token，D项串行累加；`qk_warp`一warp计算一个token，lane跨channel读连续code/metadata，分摊D项后五级shuffle求和，默认优化候选为warp。尾warp整warp统一退出，仍参与计算的32lane都执行相同mask的shuffle，D<32的lane贡献0。没有shared-memory或CTA barrier。

假设：warp版本改善沿channel的访存合并、缩短每lane的累加依赖；代价是每输出多用31个线程、5次shuffle与更多warp，D=1或很短时可退化。base相邻token可能重复加载同word并由cache/broadcast缓解，不能仅凭代码断言流量降低。相同输入/形状/容差`1e-4+1e-4*abs(ref)`，均先NaN污染输出、核验再预热20次，100个CUDA event区间取P50/P95。计时不含H2D/D2H/在线pack，**只有kernel**；本机没有这些实测数据。GPU harness覆盖(1,1)/(17,17)/(33,65)/(1024,128)，CPU覆盖36shape；空T不launch，Data模型与CPU用例验证零长度。

这是SIMT反量化浮点MAC，不是原生2bit Tensor Core，也不声称与KIVI原库性能等价。

## ncu定位、筛选、采集与解释

先在Thor运行`nvcc --version; ncu --version; nvidia-smi`，记录`/etc/nv_tegra_release`（若存在）。`profile.sh`先列sections与metrics保存build目录，再只采ProfilerStart/Stop窗口的一次base或warp；程序预热在窗口外。运行两个脚本参数即可同条件获取两个报告：

```sh
sh profile.sh base
sh profile.sh warp
ncu-ui build/qk-warp.ncu-rep
```

工作目录为本课目录；基础报告用`--set basic`。在`build/ncu-sections.txt`确认安装版本存在后，追加`--section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats --section LaunchStats --section Occupancy --section SourceCounters`进行诊断采集。若section不存在用该版本的名字，不照抄raw metric。`--query-metrics`先确认可用字段；无权限/不支持写缺失，不能记零。

| 要验证的问题 | 观察证据 | 可能推翻假设的情况 |
| --- | --- | --- |
| 合并是否改善 | memory workload中的global sectors/requests、L1/L2命中和DRAM吞吐 | base广播/cache已经消除重复读取 |
| 依赖链是否缩短 | scheduler eligible warps、issue与stall采样结合SourceCounters | shuffle和额外warp吞掉节省 |
| 是否资源受限 | registers/thread、active warps、occupancy及launch shape | 高occupancy不一定带来更低延迟 |

在GUI Source页选择qk_warp，关联源码行、PTX、SASS及采样；需`-lineinfo`且源文件路径可用。若CLI版本支持source页面也可导出；以`ncu --help`核实选项。profiler replay、cache控制会改变时间，所以收益以不附加ncu的`build/qk all`为准。[官方CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。

## PTX/SASS和热点证据边界

`export-isa.sh`固定`nvcc -std=c++17 -O3 -lineinfo -arch=sm_110`生成PTX，`cuobjdump --dump-sass`提取真实二进制机器码，另导出resource usage。工具版本写build/toolchain.txt；若成功归档文本时再记录binary SHA256、设备/编译参数。当前没有真实PTX/SASS产物，不填推测机器指令。

实际手写inline PTX为`bfe.u32`提取2位字段。后续可能热点：code/metadata global load的缓存未命中；解包→scale恢复→乘加的相关依赖；warp版本shuffle→add的五级依赖。编译器可能把bfe映射成移位与逻辑序列，FMA融合也需看真实SASS，不能以PTX计数推断机器周期。停顿采样落在消费者不证明消费者本身延迟最高。区分单条延迟、发射吞吐、执行频率与等待访存，本次不提供周期排名。

## 架构对照：Thor与Volta（只对照，不切执行目标）

[Volta tuning guide](https://docs.nvidia.com/cuda/volta-tuning-guide/index.html)说明独立线程调度，不能依赖隐式warp锁步；FP16 Tensor Core是该代的重要新增机制，需正确矩阵布局及专用操作。`shfl.sync`是在PTX6.0引入的同步shuffle，当前kernel使用其明确参与mask语义；这不是Thor独有。Volta软件历史工具链支持不等于CUDA13还可为其离线生成代码；本文没有其他目标构建命令。

Thor SM110使用CUDA13基线，本课仅用可移植SIMT整数解包、FP32与同步shuffle，未使用架构专属a/f指令，也未调用tcgen05。Thor支持何种低精度矩阵指令还需逐条按[PTX ISA target notes](https://docs.nvidia.com/cuda/parallel-thread-execution/)与对应dtype/布局/同步核实；不能把unsigned INT2缓存解码天然等同某个FP4矩阵指令。对照焦点从昨日Hopper切至Volta独立线程调度，但执行目标始终sm_110。
