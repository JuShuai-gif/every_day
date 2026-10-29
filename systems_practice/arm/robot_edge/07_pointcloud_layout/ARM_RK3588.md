# ARM / RK3588 实验：点云栅格：SoA 转换、自动向量化与散写

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次invocation处理131072个32字节AoS点，变换/分类/裁剪后生成128×128计数与最高高度栅格，并消费全部格子。

p99是一帧scan→grid完整延迟，吞吐按输入点/秒含拒绝点。真实传感器去畸变/地图发布开销未包含，不能以此声称导航闭环deadline达标。

## 2. 真正相关的 ARM 优化

- baseline分配中间AoS，stage1复用，optimized按256点解包局部SoA并融合栅格写入。AoS→SoA转换成本在计时内，不能先转好数据再宣称端到端收益。
- 连续xyz数组可给编译器向量化机会，但过滤和格子散写仍有数据依赖。当前无手写NEON，EDGE_AUTO_VECTORIZE ON/OFF比显式NEON开关更直接。
- optimized同时改布局与融合，不能把所有加速归SoA。若要纯布局归因，需要另做保持相同遍历次数的控制变体，而不改动本轮业务合同。
- 半开[-32,32)边界附近的float必须映射合法格子；索引不能因舍入到128越界。保留NaN/Inf分类、负高度floor和逐格结果，不能仅校验accepted总数。

定位事件建议：cycles,instructions,cache-misses,branches,branch-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

分开AoS解包、连续变换、分支过滤、栅格散写、完整摘要。只有目标板计数/热点支持时才说局部性改善；数据分布改变格子碰撞，必须固定seed。

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

默认ON/ON开关的generic产物位于build/rk3588-generic/pointcloud_layout；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./pointcloud_layout --test
bash scripts/run-matrix.sh ./pointcloud_layout records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同ELF单A55/A76比较，再测同簇允许集的迁移影响。当前单线程，不能把同簇结果称多核并行；并行栅格更新需要局部栅格归并或同步的新实验。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

最大1M点；局部SoA4096字节、栅格131072字节，程序仍预留stage1向量，RSS不等于optimized最小内存。下游若需要完整变换点云，必须保留该输出再重测。

~~~bash
./pointcloud_layout --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

逐格counts/height和分类计数一致且稳定收益才选分块方案；点数小/栅格散写主导时可回退复用AoS。选A55释放大核容量需以预算为据，不凭标签推断能效。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：AoS点数/seed/外参、256块与尾部、网格分布、转换在计时内、workspace模型与进程RSS分别记录；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
