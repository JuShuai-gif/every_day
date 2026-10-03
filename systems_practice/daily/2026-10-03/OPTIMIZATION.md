# Thor SM110：映射、ncu和ISA证据

## 基线与最终候选

同一FP32平方和、FP64 oracle及容限。`energy_cta`一行128线程、512B shared、7层共享树和8次CTA屏障；`energy_warp`一行32线程、一CTA四行，无shared数组和CTA屏障，5次XOR shuffle。后者是最终候选，收益未验证。每warp内部加法树是蝶形，所有lane最后持有和；只lane0写回。

资源减少与更多输出/CTA可能缓解短行屏障成本，但每行并行度降低、总CTA数减少、长累加链增长都可能退化。公平对比先同一输入冷热条件；无参数完整测试含多shape，命令参数0/1只选择394x129形状便于定位。

## 版本、定位、筛选与采集

以下全部在Thor板端执行，先核对可用项，不默认旧版支持SM110。未在Mac执行成功。

```sh
nvcc --version
ncu --version
ncu --list-sets
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
# 先独立基准，profiler下的时间不用于声称加速。
build/gpu/energy 0
build/gpu/energy 1
# 每个选定kernel先一次正确性、20次预热，所以跳过21次。
ncu --kernel-name-base function --kernel-name energy_cta --launch-skip 21 --launch-count 1 \
 --section LaunchStats --section Occupancy --section SpeedOfLight \
 --section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats \
 --section SourceCounters --import-source yes -o build/cta build/gpu/energy 0
ncu --kernel-name-base function --kernel-name energy_warp --launch-skip 21 --launch-count 1 \
 --section LaunchStats --section Occupancy --section SpeedOfLight \
 --section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats \
 --section SourceCounters --import-source yes -o build/warp build/gpu/energy 1
ncu --import build/warp.ncu-rep --page details
ncu --import build/warp.ncu-rep --page source > build/source.txt
ncu-ui build/warp.ncu-rep
```

若某section不在本机列表，仅去掉该不可用项并记录；不能把缺指标写成零。CLI的过滤/skip/page/import-source语义查自[官方手册](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)，读取日2026-10-03；本机未核实具体ncu release和权限。

| 采集结果 | 用来回答的问题 | 不能直接得出的结论 |
| --- | --- | --- |
| LaunchStats寄存器/shared/local、Occupancy限制因素 | 是否被资源限制；local是否来自spill | 寄存器少必然快 |
| SchedulerStats eligible/issued warp | 无法发射还是发射吞吐已满 | 理论occupancy就是实测利用率 |
| WarpStateStats barrier/long scoreboard | 基线屏障与load消费者等待占比 | 采样停顿的FMA是最慢指令 |
| MemoryWorkloadAnalysis sectors/request、L1/L2/DRAM | stride尾部是否额外事务；缓存冷热 | 逻辑读字节等于DRAM流量 |
| SpeedOfLight SM/Memory吞吐、kernel duration | 接近哪种资源上限 | 小kernel低利用率即访存瓶颈 |

读取源码视图定位`energy_cta` shared树与`energy_warp`跨步循环，点击CUDA/PTX/SASS对应，检查PC stall附近的生产者load和消费者FMA。ncu replay、cache control和采样会扰动条件；记录replay模式/时钟/功耗/温度，以未挂profiler的event和E2E为收益证据。性能计数器无权限时保留ERR_NVGPUCTRPERM，不修改管理员设置。

## 真实产物的生成入口

```sh
mkdir -p build/isa
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -Xptxas=-v src/energy.cu -o build/isa/energy 2> build/isa/ptxas.txt
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx src/energy.cu -o build/isa/energy.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --cubin src/energy.cu -o build/isa/energy.cubin
cuobjdump --dump-sass build/isa/energy > build/isa/energy.sass
nvdisasm -g build/isa/energy.cubin > build/isa/energy.lines.sass
```

当前无nvcc/cuobjdump，因此这些产物不存在。`gpu_support.hpp::shuffle_xor`中的 `shfl.sync.bfly.b32` 是真正手写inline PTX：delta=16/8/4/2/1，clamp31，全mask。它传递32位寄存器位模式，FP32加法由后续C++表达式生成。PTX是虚拟ISA；不能推定每段PTX固定映射某条SASS或固定周期。

待验潜在热点：全局load→FMA的地址/数据依赖，局部FMA链，共享树的store→barrier→load，以及蝶形shuffle→add依赖。需要真实编译及ncu确定发射、吞吐和等待归因，不提供虚构周期排名。

## 本次架构对照：Hopper，仅原理

| 特性 | 引入/条件 | Thor与本课选择 |
| --- | --- | --- |
| shfl.sync | PTX6.0引入，规范要求sm_30+；mask命名线程必须正确参与 | Thor沿用；不是Blackwell独有。本课使用，不依赖a后缀 |
| Hopper TMA / cp.async.bulk家族 | Hopper SM90层级，PTX8.0/CUDA12时代；具体tensor形式需descriptor、布局/对齐和mbarrier完成协议 | 本课不执行TMA；没有多次共享复用，不值得凭新指令改写 |
| Blackwell/Thor tcgen05 Tensor Memory及异步矩阵指令 | 已读PTX9.4的tcgen05.mma.sp Target ISA Notes：基型PTX8.6引入，Thor名称自PTX9.0；具体变体列出sm_110a/f支持条件 | 普通sm_110不能据此默认启用；本课严格不改后缀。平方和无矩阵复用，不采用该路径 |
| Hopper thread-block clusters/DSM | SM90，cluster驻留及分布shared同步要求，硬件规模需查询 | 不把H100 shared容量/cluster上限套到Thor；本课无跨CTA交换 |

[Hopper指南](https://docs.nvidia.com/cuda/hopper-tuning-guide/index.html)已读TMA、cluster与occupancy段；[PTX shfl.sync](https://docs.nvidia.com/cuda/parallel-thread-execution/#data-movement-and-conversion-instructions-shfl-sync)已读mask/源lane语义。CUDA13支持Thor的官方基线已核实；本机工具链、板端ncu版本、驱动组合仍待验。任何a/f特性均未启用，所有可执行命令只生成sm_110。
