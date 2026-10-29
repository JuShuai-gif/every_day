# ARM / RK3588 实验：工业日志：ARM 格式化与真实 write 系统调用

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次invocation把4096事件编码为CSV，实际写临时普通文件；包括truncate/seek、格式化、完整hash、write和用户缓冲flush。

p99是4096事件批次，不是每条日志的持久化时间。当前无定时flush，连续低频服务的驻留上限未定义；不能用批次结束flush假装日志及时落盘。

## 2. 真正相关的 ARM 优化

- baseline每事件ostringstream+write，stage1保持格式化但用64KiB缓冲，optimized用to_chars写128字节scratch。分开测syscall和整数格式化，不把全部收益归缓存。
- 这里确实调用write/ftruncate/lseek，和05内存Sink不同。用strace计数定位；strace扰动延迟，因此正式p95/p99不用追踪下的数据。
- 当前没有显式NEON，格式化是整数除法/分支和短变长行。自动向量化开关只作控制，不能承诺SIMD收益；hash和内核page-cache复制也可能成为瓶颈。
- 没有fsync，因此完成write不等于掉电持久化。Arm核型/更快格式化不能改变存储合同；增加持久化策略后所有阶段必须同策略重测。

定位事件建议：task-clock,cycles,instructions,context-switches,cpu-migrations。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

看stream/locale/to_chars、write内核路径及hash占比，核对程序write_calls与strace含stdout差异。记录/tmp为tmpfs还是eMMC/NVMe，不能跨挂载直接比较。

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

默认ON/ON开关的generic产物位于build/rk3588-generic/event_log；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./event_log --test
bash scripts/run-matrix.sh ./event_log records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同ELF同TMPDIR/文件系统/输入，在单A55/A76比较。CPU核型不是存储设备，若page-cache或后台回写主导，应先固定存储条件再比较tune。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

每轮truncate复用文件避免无界增长；临时缓冲≤64KiB，输入vector和page-cache仍占资源。短写/EINTR/ENOSPC/零进展必须传播失败，满盘不是可静默丢日志的优化。

~~~bash
./event_log --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

全文一致且故障语义保持，write_calls下降和尾延迟可重复才接受缓冲；若业务需每条持久化，先加同等fsync。真实服务再加入有界异步队列、轮转与明确过载策略。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：TMPDIR/mount/介质、write_calls/bytes/buffer_peak、page-cache无fsync、系统调用证据、批次与日志驻留/持久化预算；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
