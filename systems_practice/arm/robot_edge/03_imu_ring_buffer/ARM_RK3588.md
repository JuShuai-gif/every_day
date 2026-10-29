# ARM / RK3588 实验：IMU 统计：先降算法复杂度，再看 ARM 指令

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次 invocation 重放 4096 条六轴输入、128 点窗口，输出每个有效输入的统计快照；默认时间跨度是合成数据，不按 1 kHz 墙钟采样。

顶层 p99 是整批4096条，不是单样本1ms deadline，也不能除4096得到单样本p99。真实 IMU 服务要测到达→校验→滤波→发布，以及采样抖动。

## 2. 真正相关的 ARM 优化

- baseline 的 vector 头部移除和窗口重算、stage1 的环形索引、optimized 的增量和/平方和，是三种不同成本来源。O(window×axes)→O(axes) 通常比手写向量化更值得先验证。
- AArch64 通用寄存器可处理本例 int64_t 和/平方和；固定输入上界证明不溢出。不要为少指令把平方临时值缩成 32 位。
- 当前没有显式 NEON。六轴长度短，环形取模、分支和快照写出可能盖过 SIMD 收益；用 EDGE_AUTO_VECTORIZE 对照后看编译结果，不要求每个版本都出现 V 寄存器。
- 窗口数据只由单线程拥有，不需要 atomics。若改成采集线程到处理线程的 ring，必须另立同步/关闭合同，不能把本例无锁数组直接当并发 SPSC 队列。

定位事件建议：cycles,instructions,cache-misses,branches,branch-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

验证 stage1 是否因取模更慢；优化后观察快照写出与完整摘要占比。保留慢阶段的实测，不把“环形”当结论。

## 3. 编译变体与可复现开关

本机控制实验（在本项目目录执行，每次生成独立记录）：

~~~bash
EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 30
EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 30
~~~

EDGE_ENABLE_NEON只控制项目显式intrinsic路径；EDGE_AUTO_VECTORIZE控制编译器循环/SLP向量化，两者都关闭也不保证依赖库完全不使用SIMD。使用compile_commands、backend输出与反汇编核实真正差异。

交叉构建与部署先设置实际工具链、sysroot和SSH地址：

~~~bash
export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
export SYSROOT=/absolute/path/to/rk3588-sysroot
RK_TUNE=generic bash build-rk3588.sh
BOARD=user@rk3588-host RK_TUNE=generic RK_MATRIX=1 bash run-rk3588.sh
~~~

默认ON/ON开关的generic产物位于build/rk3588-generic/imu_ring_buffer；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./imu_ring_buffer --test
bash scripts/run-matrix.sh ./imu_ring_buffer records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同二进制分别绑定单个 A55/A76；当前同簇 profile 不会增加计算线程。随后在同一核比较 generic/a55/a76 tune，区分核型和编译调度变化。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

窗口1..1024、批次≤32768，错误值/重复/倒序不推进窗口；间隙 reset 与过期淘汰计数要保留。真实流应跨批保持状态并证明分批等价，当前每调用reset。

~~~bash
./imu_ring_buffer --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

只接受逐快照 sum/square_sum/时间/事件计数完全一致的优化。若吞吐已满足而线程整合成本更大，保留单线程；若需降低尾延迟，先测常驻状态和输入队列，不先拆多线程。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：窗口/max_age/gap、rejected/reset/expired/evicted、快照一致性、预留容量、批次预算与单样本预算；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
