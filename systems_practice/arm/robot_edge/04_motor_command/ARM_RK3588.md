# ARM / RK3588 实验：多轴命令：确定性校验、CRC 与控制周期预算

本文把本项目的算法改动、Arm执行特征和边缘部署验收连接起来。状态：**RK3588待实测**；Mac用于功能、代码路径和采样协议验证，不替代板端数据。

## 1. 先固定本项目的工作负载

每次 invocation 编码2048个12轴周期，每周期187字节；含时间/限值/轴号校验、全轴失能消息、排序、编码、CRC和完整输出摘要。

2048周期批次p99不可除2048当单周期p99。5ms源命令年龄是输入有效性合同，不是编码deadline；1kHz控制还要留调度、发送、应答和安全余量。

## 2. 真正相关的 ARM 优化

- stage1 固定缓冲减少动态容器/复制，optimized 将逐位CRC换成256项查表。先看指令依赖和查表缓存，再判断调度tune是否有收益。
- 本例CRC16 poly=0x1021与AArch64 CRC32指令不是同一个校验算法，不能直接换 intrinsic 后声称兼容。[Arm ACLE](https://arm-software.github.io/acle/main/acle.html#crc32-intrinsics)定义的是CRC-32/CRC-32C。任何CRC实现必须逐字节通过同协议已知答案。
- 不为12轴控制字段强行引入NEON；不规则校验、错误位图和串行CRC依赖未必适合向量化。显式NEON开关在这里不产生新的业务内核。
- 输入时间检查先处理未来时间，再做无符号差；ARM上也必须保留这一顺序。限值或重复轴错误不能用预测分支提示绕过，更不能用性能测试代替失能语义验证。

定位事件建议：cycles,instructions,branches,branch-misses,cache-misses。事件支持与权限取决于板端内核/PMU，失败要留日志，不填0。

比较分配、serialize和CRC热点，避免将查表的主要收益记成预分配收益；错误输入比例改变分支路径，要固定并记录。没有真实write/ioctl调用。

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

默认ON/ON开关的generic产物位于build/rk3588-generic/motor_command；非默认开关会用独立后缀，以构建日志为准。设置RK_TUNE=cortex-a55或cortex-a76产生独立目录，部署必须使用相同RK_TUNE。CMake对应EDGE_CPU_TUNE，仅性能调度调优，不据此提高ISA要求；区别见[GCC AArch64选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)。

RK_MATRIX=1让部署入口执行并拉回完整核型矩阵；默认0运行快速采集。矩阵可加MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3，长测将MATRIX_SECONDS改60，BUDGET_US按一次invocation设定。保持开关变量和tune与所部署产物一致。

## 4. 同一二进制先比核，再比编译调度

核型依据[Rockchip官方资料](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)，具体Linux CPU编号通过MIDR/cpuinfo与online、当前亲和性确认，禁止默认CPU4就是大核。先记录二进制SHA256和输入/源码hash。

在板端保留脚本相邻关系后运行：

~~~bash
./motor_command --test
bash scripts/run-matrix.sh ./motor_command records/matrix-generic
~~~

OUTDIR必须不存在或为空；run-matrix.sh、board_probe.py、summarize-matrix.py同目录。自动生成single_a55/single_a76/cluster_a55/cluster_a76，缺核型或同簇证据就标unavailable，不能猜拓扑。默认MATRIX_REPEATS=3、MATRIX_SAMPLES=120、MATRIX_SECONDS=3，warmup=5、iterations=1；BUDGET_US=0代表未设预算，可按本项目每invocation合同设置。

同一ELF在A55/A76单核各测，真实控制线程亲和性还需考虑IRQ与总线线程；当前没有总线线程，进程绑核不能证明实时调度隔离成功。

第一轮固定generic ELF和输入比较亲和性；第二轮固定同一核/同一输入比较generic、a55-tuned、a76-tuned ELF。不要把换核、换编译器和改算法同时发生的差异称为某一项收益。

## 5. 边缘资源与长期验证

批次≤8192、每周期最多检查13条命令；任一错误全轴失能，记录safe_stop_frames/late_input_frames。它们是合成坏输入，不是丢控制周期。

~~~bash
./motor_command --mode optimized --samples 120 --seconds 60 --iterations 1 --csv stress.csv
~~~

记录p50/p95/p99/max、真实budget_exceeded、吞吐、RSS、前后温度/频率和后台负载。RSS是进程峰值；warmup后的缓存状态也要一致。正式采样与perf/strace归因分开，--profile跳过自检，使用前必须独立通过--test。

## 6. 选核、保留或回退的证据

只有完整packet一致、边界与故障测试通过才能接受。CRC表收益小则可保留逐位参考；选核根据真实控制预算和其他负载，不凭大核/小核标签推断安全性或功耗。

没有功耗测量就不报告瓦数、能耗/任务或能效胜负。A55满足预算只是容量/部署选择证据；温度、降频、长期尾延迟也必须实测。所有未接入设备/网络/存储语义按README列为未验证。

在records/TEMPLATE.md的目标板专用区记录：轴数/协议/CRC、故障比例、safe-stop与late-input计数、187字节一致性、编码批次和真实控制周期预算；同时关联矩阵CSV/JSON、拓扑证据、编译清单和失败日志。阶段收益与核型收益分别写结论。
