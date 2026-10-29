# ARM / RK3588 实验：遥测出口：ARM 编码与虚拟批处理的边界

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次invocation重放8192事件，24字节/帧；固定1536字节待发送缓冲，64帧或500µs虚拟最老等待触发flush。

批次p99是8192事件编码/消费时间；500µs是虚拟dwell，二者不能混用。实际业务应定义事件产生→入队→真正发出/应答的每事件期限。

## 2. 真正相关的 ARM 优化

- Allocated→Fixed消除逐帧容器，Fixed→Batched摊薄内存Sink调用。要分别确认分配、CRC16和摘要开销，不把batching等同CPU向量化。
- CRC16使用0xa001右移多项式，与[Arm ACLE的CRC-32/CRC-32C指令](https://arm-software.github.io/acle/main/acle.html#crc32-intrinsics)不等价。没有显式NEON内核，自动向量化对串行CRC依赖链不一定有效。
- 逐字节编码避免直接拷贝有padding的struct，也明确有符号读数和小端wire格式；跨Mac/Linux迁移首先验证全部字节一致。
- 当前Sink是内存函数，每7次返回不可写、每次最多173字节；没有网络syscall。batch减少调用只能说明此CPU模型，不能宣称减少真实send调用或提高TCP吞吐。

定位事件建议：cycles,instructions,branches,branch-misses,cache-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

观察CRC/分配/drain/字节hash各自占比；对照flushes/write_calls/blocked但不要把模型调用当strace计数。真实socket接入后才新增syscall和off-CPU分析。

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

默认ON/ON开关的generic产物位于build/rk3588-generic/telemetry_batch；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./telemetry_batch --test
bash scripts/run-matrix.sh ./telemetry_batch records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同ELF单A55/A76比较编码容量；同簇profile不自动增加编码线程。真实网关还要分离网络IRQ、接收线程和发送事件循环，不能从本模型推断这些负载。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

capture仅在测试保存全流，正式Sink不累计输出；输入录制向量仍随规模增长。持续背压需要可写等待、超时/落盘/丢弃政策，本例不保证长期失联可恢复。

~~~bash
./telemetry_batch --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

三阶段必须无丢失/重复且顺序一致。只有CPU收益和真实驻留预算共同满足时采用batch；稀疏事件场景可回退逐帧或较小批次，不能只看吞吐。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：事件速率/24字节协议、虚拟dwell、flush/调用/blocked、完整流一致性、真实网络指标明确NOT_MEASURED；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
