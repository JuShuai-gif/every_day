# ARM / RK3588 实验：相机流水线：访存、NEON 与队列背压

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

8 张 640×480 灰度帧、stride=672、ROI=633×475，队列容量 3；每次 invocation 包含线程启动、8 帧处理、完整消费者、排空和 join。

顶层 p99 是 8 帧批次，不能除以 8 当单帧 p99。last_batch 的队列+处理统计只代表最后一批，且包含入队等待；真实曝光→结果发布预算要另接设备时间戳。

## 2. 真正相关的 ARM 优化

- baseline 列式访问使相邻输出跨行取数；stage1 只复用容量；optimized 按行融合 2×2 下采样与归一化，先检查访存和中间图像减少的收益。
- 本轮显式 NEON 主循环每次读取两行各 16 个输入像素，产生 8 个输出；奇数边缘和不足 8 个输出走标量。比较完整逐像素结果，不能只看 SIMD 指令数量。
- EDGE_ENABLE_NEON=OFF 保留融合实现并关闭显式 NEON；EDGE_AUTO_VECTORIZE=OFF 另关编译器自动向量化。四组合用于比较两种向量化方式；融合收益还要在固定开关下比较算法阶段，不能混为一项。
- 队列使用 mutex/condition_variable；它们承担跨线程可见性和唤醒，不用 volatile 或空汇编屏障替代。当前没有实现 lock-free 队列或手写 memory_order。

定位事件建议：cycles,instructions,cache-misses,context-switches,cpu-migrations。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

把 preprocess、完整输出 hash、分配和条件变量热点分开。若 hash/线程创建主导，总体收益不应全归 NEON；若等待主导，检查生产/消费速率和队列容量。

## 3. 编译变体与可复现开关

本机控制实验（在本项目目录执行，每次生成独立记录）：

~~~bash
EDGE_ENABLE_NEON=OFF EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 30
EDGE_ENABLE_NEON=ON EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 30
~~~

EDGE_ENABLE_NEON只控制项目显式intrinsic路径；EDGE_AUTO_VECTORIZE控制编译器循环/SLP向量化，两者都关闭也不保证依赖库完全不使用SIMD。使用compile_commands、backend输出与反汇编核实真正差异。

交叉构建与部署先设置实际工具链、sysroot和SSH地址：

~~~bash
export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
export SYSROOT=/absolute/path/to/rk3588-sysroot
RK_TUNE=generic bash build-rk3588.sh
BOARD=user@rk3588-host RK_TUNE=generic RK_MATRIX=1 bash run-rk3588.sh
~~~

默认ON/ON开关的generic产物位于build/rk3588-generic/camera_resize；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./camera_resize --test
bash scripts/run-matrix.sh ./camera_resize records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

两线程绑定单核时必须时间片轮转；同簇 profile 允许并行，但进程绑核不是把采集放 A55、处理放 A76。先完成同一二进制的四种亲和性比较，再考虑逐线程分工实验。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

队列满阻塞且不丢帧，队列峰值必须 ≤3。实际相机不能无限暂停，应明确帧池、DMA 所有权、丢旧帧/丢新帧策略；队列加大可能只把拥塞变成尾延迟。

~~~bash
./camera_resize --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

仅当逐像素一致、队列关闭/异常退出通过、单帧或批次预算达标且结果可重复时保留 NEON；若尾部比例/图像尺寸使收益消失，融合标量版是有效回退。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：帧尺寸/ROI/stride、NEON/backend、队列峰值、最后批次帧延迟、batch p99 与真实帧 deadline 分别记录；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
