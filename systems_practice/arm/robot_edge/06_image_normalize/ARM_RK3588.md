# ARM / RK3588 实验：RGB 到 NCHW：显式 NEON 与自动向量化的四组对照

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次invocation处理1280×720 RGB8，stride含64字节padding，输出3×720×1280个float；验证/生成全张量在计时内。

p99对应一帧CPU前处理；真实30FPS等预算还需扣曝光/传输/推理/后处理。iterations>1是均摊值，单帧尾延迟必须iterations=1。

## 2. 真正相关的 ARM 优化

- Multipass→Fused减少中间FP32张量与遍历，Vectorized再用NEON一次解交错8个RGB像素。先测融合，再判断手写SIMD相对自动向量化的额外收益。
- 四组合：显式OFF/自动OFF是标量控制；OFF/ON看自动向量化；ON/OFF隔离intrinsic；ON/ON为默认。编译选项与实际backend/反汇编必须同时归档。
- NEON只读完整8像素块，尾部标量；不同stride、7/8/9及15/16/17宽度必须回归。不能依赖padding越界读取，也不能为向量化偷偷换RGB/BGR或NCHW布局。
- 乘倒数与除法有舍入差异，逐元素用2e-6+abs(reference)×2e-6容差。浮点结果有限性、异常参数拒绝和近边界输入先于性能结论。

定位事件建议：cycles,instructions,cache-misses,branches,branch-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

保存AArch64反汇编，确认实际解交错load、扩展、FP32运算与store。NEON指令出现不等于端到端提速；融合后可能受输出写流量限制，cache-misses不是直接带宽。

## 3. 编译变体与可复现开关

本机控制实验（在本项目目录执行，每次生成独立记录）：

~~~bash
EDGE_ENABLE_NEON=OFF EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 30
EDGE_ENABLE_NEON=OFF EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 30
EDGE_ENABLE_NEON=ON EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 30
EDGE_ENABLE_NEON=ON EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 30
~~~

EDGE_ENABLE_NEON只控制项目显式intrinsic路径；EDGE_AUTO_VECTORIZE控制编译器循环/SLP向量化，两者都关闭也不保证依赖库完全不使用SIMD。使用compile_commands、backend输出与反汇编核实真正差异。

交叉构建与部署先设置实际工具链、sysroot和SSH地址：

~~~bash
export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
export SYSROOT=/absolute/path/to/rk3588-sysroot
RK_TUNE=generic bash build-rk3588.sh
BOARD=user@rk3588-host RK_TUNE=generic RK_MATRIX=1 bash run-rk3588.sh
~~~

默认ON/ON开关的generic产物位于build/rk3588-generic/image_normalize；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./image_normalize --test
bash scripts/run-matrix.sh ./image_normalize records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

每个编译组合各自生成generic ELF，用该组合的同一ELF分别在单A55/A76运行；四组合有独立hash，不能混称同一个二进制。同簇仅扩大允许CPU，不自动并行图像。当前不调用RKNN/NPU，不可声称NPU算力相关收益。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

输入/输出预分配，baseline另分配完整交错张量；RSS为进程峰值。token只读首尾，长测不逐帧验证全张量；完整正确性在计时外逐元素比较。

~~~bash
./image_normalize --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

只有容差、布局、尾部、参数测试通过且板端p95/p99收益重复出现才保留NEON；自动融合已足够时可以回退更简单实现，避免单凭Mac数据选型。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：RGB/shape/stride/mean/std、四组合和backend、逐元素容差、首尾token限制、单帧预算、输入输出容量；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
