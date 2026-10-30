# Thor SM110 实机分析步骤（本机均未执行）

## 兼容性先验与实机信息

2026-10-15实际核查 NVIDIA [CUDA13 release notes](https://docs.nvidia.com/cuda/archive/13.0.0/cuda-toolkit-release-notes/index.html)、[PTX target规则](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#target)、[Ampere tuning](https://docs.nvidia.com/cuda/ampere-tuning-guide/index.html)。PTX9.0引入sm_110命名，当前文档明确baseline与a/f特性分离。不能把能识别目标当成驱动、库和分析器已适配。

在Thor保存以下输出，按板上JetPack/Jetson Linux发行说明核对驱动、CUDA和ncu；当前没有设备，完整组合未验证。不要把PC驱动最低版本机械套到Jetson，不修改频率/功耗设置。

```sh
mkdir -p build
cat /etc/nv_tegra_release
uname -a
nvcc --version
nvcc --list-gpu-code
ncu --version
cat /proc/driver/nvidia/version
# 列出已安装版本，不安装任何东西
dpkg-query -W 'nvidia-jetpack' 'nvidia-l4t-core' 'cuda-toolkit-*' 'nsight-compute*'
sh build.sh thor
```

实际读到2026-10-15 [JetPack下载页](https://developer.nvidia.com/embedded/jetpack/downloads)列出JetPack7.2.1 / Jetson Linux39.2.1 / CUDA13.2.2 / TensorRT10.16.2；这是官方发布组合，不代表本机装有该版本。另读[ncu已知限制](https://docs.nvidia.com/nsight-compute/ReleaseNotes/topics/known-issues.html)，GB10b Thor上的clock-control不支持。实际驱动/ncu版本与该SDK组合仍待板端确认。

只接受列表含sm_110。代码运行时检查11.0；具体Thor板型也需确认，不能仅靠CC判产品。CUDA13与支持Thor的ncu是候选基础，板端实际版本/权限未验。

## 定位、筛选、采集

```sh
ncu --list-sections > build/sections.txt
ncu --query-metrics > build/metrics.txt
# 正确性先过，避免给错误kernel调优
./build/transpose check
# 过滤每个进程唯一的kernel；先跳过1次校验和10次warmup
ncu --kernel-name-base demangled --kernel-name 'regex:transpose_direct' --launch-skip 11 --launch-count 1 --section LaunchStats --section Occupancy --section SpeedOfLight --section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats --section SourceCounters --clock-control none --export build/direct ./build/transpose 0
ncu --kernel-name-base demangled --kernel-name 'regex:transpose_tile' --launch-skip 11 --launch-count 1 --section LaunchStats --section Occupancy --section SpeedOfLight --section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats --section SourceCounters --clock-control none --export build/tile0 ./build/transpose 1
ncu --kernel-name-base demangled --kernel-name 'regex:transpose_tile' --launch-skip 11 --launch-count 1 --section LaunchStats --section Occupancy --section SpeedOfLight --section MemoryWorkloadAnalysis --section SchedulerStats --section WarpStateStats --section SourceCounters --clock-control none --export build/tile1 ./build/transpose 2
ncu --import build/tile1.ncu-rep --page details
ncu-ui build/tile1.ncu-rep
```

先确认当前ncu有这些section，不存在则依实际列表替换并保存差异。`--clock-control none`避免在Jetson请求分析器不支持的锁频；记录实际频率/温度。没有计数器权限时保留ERR_NVGPUCTRPERM，按管理员政策开放；不要把空指标记为0。

从查询结果筛选shared load bank conflict/excessive wavefront、global load/store sectors与requests、DRAM bytes、registers/thread、shared/CTA及active warps；指标名依安装版本检查，不能照搬别架构raw metric。判断顺序：direct→tile0的store sectors/有效元素是否减少；tile0→tile1的shared excessive wavefront是否减少；再检查occupancy和scheduler eligible warps是否抵消收益。MemoryWorkloadAnalysis和SourceCounters给行级证据，stall的long/short scoreboard只说明依赖类别，不能直接等价“某条load花费固定周期”。

Profiler replay、cache flush及计数器采样都会扰动；上述报告用于归因，速度以无profiler的21批事件时间为准。重复地址是热缓存微基准；真实流水线冷缓存、并发带宽、CPU提交排队均待另验。

## 真实PTX/SASS生成和源码关联

```sh
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -ptx src/transpose.cu -o build/transpose.ptx
nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 -cubin src/transpose.cu -o build/transpose.cubin
cuobjdump --dump-sass build/transpose.cubin > build/transpose.sass
nvdisasm -g build/transpose.cubin > build/transpose-lines.sass
```

本期真实手写PTX是 `asm volatile("bar.sync 0;" ::: "memory")`，用于CTA发布，位于两个循环之间；不是反汇编结果。nvcc产物检查 `.target sm_110`，在ncu Source页加载本地.cu、PTX、SASS，定位load/shared load/store和barrier的源行/地址。PTX预期含ld.global/st.global、shared load/store及bar.sync（编译可能变换）；没有工具链故没有“实际SASS”片段。

潜在热点：direct的store地址跨度造成事务浪费；PAD0的shared列读取使不同字落同bank，消费者可能停顿；PAD1新增地址步长与共享分配也有代价。屏障等待可能来自到达不均衡或上游访存，不能把barrier自身当万能根因。寄存器、spill和实际机器指令必须看真实产物，不编造周期数。

## Thor与Ampere原理对照

| 项目 | Ampere理论对照 | Thor SM110本期 |
| --- | --- | --- |
| 全局→shared异步复制 | sm_80开始硬件加速；PTX7.0 `cp.async`，4/8/16B与对齐、wait/发布合同 | baseline指令需编译验证；本kernel不使用，只有搬运没有可重叠计算，且33列破坏简单16B对齐 |
| arrive/wait屏障 | Ampere强化硬件屏障/流水线 | 本期使用传统bar.sync，不声称其Thor新增 |
| int warp reduce | Ampere新增32位整数reduce支持 | 转置不需要归约，不强塞指令 |
| 目标特色 | 不能把A100/GA10x shared容量混用 | PTX9.0明确sm_110 baseline，a/f专属能力不在本任务执行范围 |

CUDA11/PTX7.0是Ampere相关机制的历史基础，仅用于解释；全部可执行命令为CUDA13+、sm_110。本次不利用Tensor Core，新一代矩阵指令不会自动加速无算术转置。下一次GPU课再轮换Hopper特性。
