# ARM / RK3588 边缘端性能实验（Mac 开发，Linux 板端验收）

这 10 个目录可以单独复制、独立 CMake 构建。每个项目包含业务实现、确定性回放、已知答案/异常/边界测试、三个优化阶段、本机验证、交叉编译、部署和原始数据归档。

重点是 ARM 指令和访存、RK3588 A55/A76 核型选择、边缘业务的预算与尾延迟。先读 [ARM 性能实验路线](ARM_PERFORMANCE.md)：四种向量化编译对照、汇编生成证据、实际核拓扑识别、绑核实验矩阵与预算超限统计。每个项目另有独立 ARM_RK3588.md 和目标板记录表。

它们覆盖端侧软件链路，不直接控制执行器或连接真实相机/NPU。硬件接入边界写在各 README 中。此前单次耗时及只对输入求和的初稿已替换；01 的旧 results/mac-*.txt 仅作历史保留，不与本轮不同工作负载比较。

| 项目 | 现在真正执行的工作 | 三阶段改动 |
| --- | --- | --- |
| [01 相机](01_camera_resize/README.md) | 有界帧索引队列 → ROI/box 下采样 → FP32 → 完整输出消费者 | 每帧分配 → workspace 复用 → NEON 融合和安全尾部 |
| [02 雷达](02_lidar_filter/README.md) | 质量/时戳/量程过滤 → 稳定压缩 → 坐标转换 → 扇区最近点 | 临时容器 → 容量复用 → 单遍融合 |
| [03 IMU](03_imu_ring_buffer/README.md) | 六轴时间窗口、顺序拒绝、gap reset、逐样本统计 | 头部搬移 → ring → 增量统计 |
| [04 电机](04_motor_command/README.md) | 多轴限值与新鲜度校验 → 全轴安全帧 → 编码/CRC | 分配 → 复用 → 查表 CRC |
| [05 遥测](05_telemetry_batch/README.md) | 带 CRC 的字节帧、短写、重试/背压、批次延迟边界 | 动态编码 → 固定编码 → 有界批量发送 |
| [06 图像](06_image_normalize/README.md) | 带 stride 的 RGB8 → NCHW FP32 → mean/std 归一化 | 多遍中间张量 → 融合 → 安全 NEON 尾部 |
| [07 点云](07_pointcloud_layout/README.md) | 坐标变换 → crop → 占据栅格，含布局转换成本 | 临时 AoS → 复用 AoS → 分块 SoA |
| [08 融合](08_sensor_fusion/README.md) | 两条生产线程、有界队列、时戳对齐/插值、关闭排空 | deque → 固定 ring → 批量交接 |
| [09 Modbus](09_modbus_parser/README.md) | TCP 分片流、MBAP/长度校验、0x03/0x83 响应解析 | erase → cursor → 有界 ADU 状态机 |
| [10 日志](10_event_log/README.md) | 编码 → 短写/EINTR 处理 → 临时文件写入/回读 | 每条 write → 批量缓冲 → 固定数字编码 |

## 从一个项目开始

~~~sh
cd systems_practice/arm/robot_edge/01_camera_resize
bash run-mac.sh
~~~

本机要求 CMake 3.20+、C++17 编译器、Bash、Python 3（标准库用于 JSON 汇总）。自动完成 Release 构建、CTest、三阶段测量、ASan/UBSan 正确性测试，归档到新的 records/mac-日期-随机串/，旧记录不覆盖。SANITIZE=0 可跳过内存检查，但不能记录为 sanitizer 已通过。

~~~sh
build/native/camera_resize --test
build/native/camera_resize --mode all --seconds 60 --samples 120 \
  --iterations 10 --csv records/stress.csv
~~~

--iterations > 1 时，分位数是每批平均调用耗时，不是单帧尾延迟；验收单次 deadline 请用 --iterations 1。p99 使用最近秩，30 样本时接近最大值，不是生产 p99 保证。--budget-us 统计超过预算的样本，不代表硬实时认证。

## Mac → RK3588

~~~sh
CROSS_CXX=/absolute/toolchain/bin/aarch64-linux-gnu-g++ \
SYSROOT=/absolute/rk3588-sysroot bash build-rk3588.sh
BOARD=user@rk3588-host bash run-rk3588.sh
# 从板端 MIDR/CPUinfo/拓扑确认核类型后再选择，不预设 CPU4 一定是 A76
BOARD=user@rk3588-host CPU_SET=4-7 bash run-rk3588.sh
~~~

工具链必须能在 Mac 执行；显式指定 Linux、sysroot 和查找域避免混入 macOS SDK。采用通用 Armv8-A，不臆测 I8MM/SVE 支持。[CMake 官方说明](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-linux)

重点实验使用自动核型矩阵；预算单位必须对应各项目的一次 invocation。默认 BUDGET_US=0 表示尚未设置预算。

~~~sh
RK_TUNE=generic bash build-rk3588.sh
RK_TUNE=generic RK_MATRIX=1 BOARD=user@rk3588-host bash run-rk3588.sh
~~~

RK_TUNE 还可选 cortex-a55、cortex-a76，仅设置 -mtune，产物分目录保存。先同一二进制比核型，再同一核型比编译调优。RK_MATRIX=1 用 Python 3 探测真实可用核，保存重复采样、deadline misses、环境和 perf；详见性能实验路线。

脚本先创建独立远程目录，再上传二进制、编译命令和源码哈希。保存测试、120 组原始样本、CPU/温度/频率前后快照、每阶段 perf stat、优化阶段 perf record/report；失败仍尝试取回记录。perf 无权限/事件不支持会记录失败，不自动修改系统权限。[perf stat](https://www.man7.org/linux/man-pages/man1/perf-stat.1.html)、[perf record](https://www.man7.org/linux/man-pages/man1/perf-record.1.html)

板端要求 Bash、GNU timeout、file、sha256sum、匹配的运行库；taskset/perf 用于绑核和分析。每个远程阶段有超时，防止队列错误导致部署永久等待。没有 SSH、sysroot 和交叉工具链时，只能完成 Mac 验证与脚本检查，不能写“已部署 RK3588”。

## 测量合同与记录

- baseline / stage1 / optimized 在 all 模式逐轮轮换先后顺序，输入相同。阶段名称不保证更快，退化应如实保留。
- 测试比较完整业务输出和独立已知答案。--profile 仅供已经通过测试的单阶段采样，明确打印 correctness=SKIPPED。
- 基准消费返回值并使用编译器内存屏障；它们不是线程同步。每阶段返回 token 在重复运行中必须稳定，但采样 token 不代替完整正确性测试。
- 每个 README 说明计时是否包含分配、I/O、线程启动、布局转换和消费者；模拟 sink 的 write 次数不称为真实 syscall。
- CSV 保存每轮批次耗时、单次均值、迭代数与摘要。RSS 是进程最高驻留内存；逐阶段内存比较须分别启动新进程。
- records/TEMPLATE.md 记录预算、证据和回滚选择。脚本保存源码 SHA-256、环境、完整编译参数与命令。
- Mac ASan/UBSan 关闭 LeakSanitizer；01/08 另用 -DEDGE_TSAN=ON 构建并通过队列自检，日志见验证报告。这不等于泄漏检查、板端功耗或长期设备稳定性验收。

~~~sh
bash verify-all.sh
~~~

全套本机验证串行执行，避免并发构建负载干扰。查看 [ARM 专项验证](ARM_VALIDATION.md) 与 [初次重构历史记录](VALIDATION.md) 的真实范围。
