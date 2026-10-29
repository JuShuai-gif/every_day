# ARM / RK3588 边缘端性能实验路线

本套案例要回答三个可验证的问题：**计算和数据移动花在哪里；同一任务放 A55 还是 A76；优化后是否满足边缘业务的时间与资源预算。** 先通过数据与输出合同，再用同一输入比较实现、编译方式、核型三个因素。

RK3588 使用四个 Cortex-A76 和四个 Cortex-A55，两类核心的缓存配置不同；芯片规格见 [Rockchip 官方简版数据手册](https://www.rock-chips.com/uploads/pdf/2022.8.26/191/RK3588%20Brief%20Datasheet.pdf)。具体 Linux 核号、在线状态、允许亲和性、cache/cluster 分组必须从运行板读取，不能用 Mac 宏或固定 0–3/4–7 推断。

## 1. 从任务指标出发

| 维度 | 实际记录 | 如何解释 |
| --- | --- | --- |
| 时延 | invocation p50/p95/p99/max、budget 超限次数/比例 | 批次 p99 不能除以事件数当单事件 p99 |
| 吞吐 | 有效工作单位/秒、输入/输出字节与计数 | 01 的单位是帧，06 是像素；不能直接横向比较 |
| 内存 | workspace 上限、队列/缓冲峰值、进程 RSS | RSS 是进程高水位，分别启动进程才能比较驻留内存 |
| 调度 | 核型、请求/实际 CPU 集合、context-switches、cpu-migrations | 绑定核集合不会自动增加工作线程 |
| 热与频率 | 每轮前后频率、governor、温度 | 快照不证明整个运行没有降频；长测需额外连续采样 |
| 功耗 | 外部实测瓦数/焦耳/任务，若没有则记未测 | 不能由 A55 名称或运行时间推导能效 |
| 正确性 | 完整输出、自检、异常与边界、确定性摘要 | SIMD、CRC 和格式转换必须保持业务语义 |

budget 是**一次 invocation**的预算。0 表示未设置；JSON 中的 budget_status=NOT_SET 不代表达标。iterations>1 时得到每批均值的分位数，严格尾延迟实验使用 iterations=1。默认数据是重复热数据回放；冷启动、真实输入/驱动和持续热稳态需分别记录。

## 2. 区分算法、编译器与显式 NEON

每个项目的 baseline/stage1/optimized 表示算法实现阶段。以下开关是另一组实验维度，两个维度不要混为一谈：

| EDGE_ENABLE_NEON | EDGE_AUTO_VECTORIZE | 目的 |
| --- | --- | --- |
| OFF | OFF | 关闭项目显式 intrinsic 与循环/SLP 自动向量化，建立控制组 |
| OFF | ON | 同一源代码由编译器选择向量化 |
| ON | OFF | 有显式 NEON 的位置仍使用 intrinsic，观察与控制组的差别 |
| ON | ON | 默认发布候选，比较组合效果 |

只有 01/06 实现了显式 NEON；其余项目的此开关不凭空产生另一套算法。两个开关都关闭也不保证库函数、编译器其它变换完全不使用 SIMD，最终看汇编。

在任一独立项目运行：

~~~sh
EDGE_ENABLE_NEON=OFF EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 60
EDGE_ENABLE_NEON=OFF EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 60
EDGE_ENABLE_NEON=ON EDGE_AUTO_VECTORIZE=OFF bash run-mac.sh --samples 60
EDGE_ENABLE_NEON=ON EDGE_AUTO_VECTORIZE=ON bash run-mac.sh --samples 60
~~~

默认 ON/ON 为 build/native；非默认为 build/native-neon-OFF-auto-OFF 等独立目录，sanitizer 同样分开。日志打印编译开关和实际 backend。Mac 能验证 arm64/NEON 的功能，不能代表 Cortex-A55/A76 的吞吐、调度或热行为。

01 新增 16 个输入像素/行生成 8 个 box 输出的 NEON 路径；先整数平均再转 float，ROI、奇数尾部和 stride 仍需逐像素一致。06 采用 RGB 解交错到三个平面，检查除法改倒数乘法的容差。[Arm NEON intrinsic 对照表](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)

## 3. 留下指令生成证据

~~~sh
python3 scripts/inspect-build.py build/native records/codegen-native-01
python3 scripts/inspect-build.py build/native-neon-OFF-auto-OFF records/codegen-scalar-01
~~~

输出目录必须为空。工具读取实际 compile_commands.json，保留目标、优化和宏参数，生成每个 translation unit 的 .s、向量化报告、完整命令和哈希。也可对 Linux 交叉构建目录运行，使用其中记录的 Mac 可运行编译器。

重点查业务循环对应符号与行：01 的解交错加载/加宽求和，06 的解交错/转换/向量乘，07 的连续访问是否被自动向量化。编译器可能选择等价指令，不能只数某个助记符或看到一条向量指令就宣称快。总计时包含 hash、线程和系统调用时，需要 perf 的热点归因。

## 4. 先同二进制比核型，再单独比 tune

从项目目录配置真实工具链与 rootfs：

~~~sh
export CROSS_CXX=/absolute/toolchain/bin/aarch64-linux-gnu-g++
export SYSROOT=/absolute/rk3588-sysroot

RK_TUNE=generic bash build-rk3588.sh
RK_TUNE=generic RK_MATRIX=1 BOARD=user@rk3588 bash run-rk3588.sh
~~~

默认保持 -march=armv8-a。RK_TUNE=cortex-a55/cortex-a76 只添加 -mtune，放在独立目录；部署必须使用相同 tune、NEON 和自动向量化开关。-mcpu/-march 的 ISA 含义与 -mtune 不同，不能使用 Mac 的 -march=native 冒充 RK3588 目标。[GCC AArch64 选项](https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html)

~~~sh
RK_TUNE=cortex-a55 bash build-rk3588.sh
RK_TUNE=cortex-a55 RK_MATRIX=1 BOARD=user@rk3588 bash run-rk3588.sh
RK_TUNE=cortex-a76 bash build-rk3588.sh
RK_TUNE=cortex-a76 RK_MATRIX=1 BOARD=user@rk3588 bash run-rk3588.sh
~~~

默认目录 build/rk3588-generic、build/rk3588-cortex-a55、build/rk3588-cortex-a76。非默认向量化开关再追加独立后缀。比较 tune 时仍保持核型、输入、预算和环境一致；这样才能区分编译调优与换核的收益。

## 5. 板端自动发现、绑定、测量和归档

scripts/board_probe.py 读取 MIDR/cpuinfo、在线 CPU、进程允许的 affinity、实际 cache/topology、频率、温度、device-tree 型号。硬件身份和核分组来源都写进 JSON；缺失数据标 unavailable，不猜。sysfs 接口见 [Linux CPU ABI](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-devices-system-cpu)。

RK_MATRIX=1 自动上传工具，尝试四组对照：

- single_a55、single_a76：两个核心类型各选一个已核实且允许使用的 CPU。
- cluster_a55、cluster_a76：有拓扑/同类型共享缓存证据的核集合；不是保证四核，不增加算法线程数。

板端也可直接执行（scripts 内三工具需同行）：

~~~sh
python3 scripts/board_probe.py --output probe.json
MATRIX_REPEATS=3 MATRIX_SAMPLES=120 MATRIX_SECONDS=3 BUDGET_US=5000   bash scripts/run-matrix.sh ./camera_resize records/matrix-camera-01
~~~

这里 5000 µs 是相机 8 帧批次的示例预算，必须按项目改成实际要求。未确定需求时保留 BUDGET_US=0。Mac 一键部署可传相同变量，长测使用 MATRIX_SECONDS=60。板端需 Python 3.9+、Bash、taskset、GNU timeout、sha256sum，perf 用于归因。

每轮记录请求核集合、环境前后快照、stdout、原始 CSV 和状态；summary.json 保存逐轮与合并分位数、预算超限及可比较的单核比值。缺核/失败/摘要不一致不能成为完整有效对照。COMPLETE 仅表示采集完整，不是生产验收或能效结论。

perf stat 优先记录 cycles/instructions、切换/迁移与 cache 事件，不支持则明确降级或保留失败。不同核上通用事件可能不可用，不能填零；PMU 包括初始化和预热，不直接当 kernel cycles/帧。需要定位调用栈时按各 README 的 perf record/report 单阶段执行。

## 6. 十个案例各看什么

| 案例 | ARM/RK3588 的实验重点 | 边缘业务决定 |
| --- | --- | --- |
| [01 相机](01_camera_resize/ARM_RK3588.md) | 整数 NEON、连续写、线程与 hash 占比 | 帧预算、背压/丢帧与采集处理分工 |
| [02 雷达](02_lidar_filter/ARM_RK3588.md) | 稳定压缩、融合遍历、分支和数据访问 | 扫描周期、最近点语义、点数突发 |
| [03 IMU](03_imu_ring_buffer/ARM_RK3588.md) | 增量复杂度、ring 索引与窗口热点 | 高频窗口更新、乱序和 gap 处理 |
| [04 电机](04_motor_command/ARM_RK3588.md) | CRC16 查表与分支；不能换成 CRC32 指令 | 控制周期、安全帧、命令新鲜度 |
| [05 遥测](05_telemetry_batch/ARM_RK3588.md) | 分配与批处理、真实传输调用成本 | 批次等待、背压与断线策略 |
| [06 张量](06_image_normalize/ARM_RK3588.md) | vld3、融合布局、自动/手写向量化 | 模型输入合同、前处理预算和拷贝 |
| [07 点云](07_pointcloud_layout/ARM_RK3588.md) | AoS/SoA、转换成本、栅格散写 | 地图更新周期与内存容量 |
| [08 融合](08_sensor_fusion/ARM_RK3588.md) | 同步/交接、调度、单核与同簇运行 | 时间对齐、尾延迟、队列退出 |
| [09 Modbus](09_modbus_parser/ARM_RK3588.md) | 分支、缓冲搬移、端序与非对齐输入 | TCP 分片、协议边界和吞吐 |
| [10 日志](10_event_log/ARM_RK3588.md) | 格式化与实际 write 的成本分离 | 突发写、缓存上限与持久化要求 |

## 7. 作出可回退的部署选择

先验证同一输出，再比较实际预算超限和多轮数据；平均值变好但尾延迟变坏要单独判断。若 A55 达到预算，可以把它列为部署候选；是否省电必须另测功耗。若 A76 仍不达标，先确认内存、排队、同步和 I/O 的热点，再决定是否分工或接 RGA/NPU。

这十个案例以 CPU 链路为范围，没有伪装实现 RGA、RKNN、DMA 或驱动零拷贝。它们给出这些硬件模块前后的数据合同和测量边界。真实接入要增加实际传输、缓存一致性、硬件输出和端到端时间记录，才能填写设备验收。
