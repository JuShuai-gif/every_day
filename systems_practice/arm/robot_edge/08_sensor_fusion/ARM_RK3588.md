# ARM / RK3588 实验：传感器融合：ARM 同步语义与锁粒度

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

两个生产线程传输8192 IMU和2048 wheel记录，主线程对齐/插值/融合；每路队列64条，optimized临时块16条。

p99是整个回放批次含线程创建/join，吞吐单位wheel输出；不可解释为单IMU到达→发布。真实低速到达下16条batch可能增加等待，必须另测逐消息延迟。

## 2. 真正相关的 ARM 优化

- 此例主要是队列、锁、唤醒和数据交接，不是矩阵推理；没有理由先塞NEON。baseline deque→stage1固定环减少分配，optimized批量push/pop减少锁交接频率。
- mutex与condition_variable建立同步和可见性，必须保护closed/head/size/payload。空汇编memory clobber只是编译器基准屏障，不是ARM线程同步。
- 当前没有手写memory_order。若未来改SPSC atomic索引，应证明payload发布的release与消费的acquire及关闭/排空规则；仅把索引改relaxed或volatile不成立。
- 当前也没有专门的false-sharing对照。不能看到多线程就宣布缓存行伪共享；先取得锁等待、迁移或缓存一致性证据，再设计独立填充/分片实验。

定位事件建议：task-clock,context-switches,cpu-migrations,cycles,instructions。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

查pthread/条件变量/线程创建/分配热点。stage1仍逐条锁，收益不等于少锁；optimized才改变批量交接。wait次数不等于等待时长，摘要不纳入调度计数。

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

默认ON/ON开关的generic产物位于build/rk3588-generic/sensor_fusion；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./sensor_fusion --test
bash scripts/run-matrix.sh ./sensor_fusion records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

四profile有实义：单核是三线程轮转，同簇允许并行；进程taskset使子线程继承同一集合，不代表分别指定生产/消费核。先同簇，跨簇/逐线程分工另设实验。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

queue_peak≤64且不丢样，临时块/输入/输出还占内存。测试close/空流/长尾排空/异常和TSan；持续服务需常驻线程、取消/重连和统一传感器时钟。

~~~bash
./sensor_fusion --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

正确性/无挂起/TSan可用时无报告是前提；比较p99、context-switches及队列等待。若线程启动主导，先做常驻线程实验；批量伤害消息期限时退回逐条。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：生产/消费线程允许CPU、queue_peak/waits、unmatched、TSan状态、batch16与逐条消息期限、thread-start占比；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
