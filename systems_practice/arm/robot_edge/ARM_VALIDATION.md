# ARM / RK3588 专项验证：2026-09-30

本轮已落实 ARM 路径、编译对照和板端性能实验工具。Mac 验证完成；**RK3588 交叉编译、真实核型矩阵、PMU、热稳态和功耗尚未实测**。没有配置板端连接、匹配 sysroot 和 Mac 可运行的交叉工具链，不能用下面的 Apple Silicon 数据替代 RK3588。

## 实际完成的检查

- 默认配置覆盖全部 10 项目；01/06 额外覆盖另外 3 种向量化组合，共 16 个构建配置。
- 16 个配置各 4 项 CTest 均通过，共 64 次检查；全部配置的 ASan/UBSan 自检通过。LeakSanitizer 关闭。
- 01/08 当前源码的独立 TSan 队列自检通过：[01 日志](01_camera_resize/records/arm-tsan-20260930-112717-4lzefl3y/session.log)、[08 日志](08_sensor_fusion/records/arm-tsan-20260930-112719-wi8l3rgz/session.log)。
- 板端工具有 16 个不同 fixture 测试，每个独立项目随带副本；预算/汇编命令另有 7 个合同测试。fixture 通过不等于板端已运行。
- 61 个 Shell 文件语法、51 个 Python 文件的 Python 3.9 语法、38 个 C++ 文件格式通过。
- 16 份运行档案的源码和当前二进制 SHA-256 核对通过；每份有 3 阶段×60 样本，共 2880 行正式采样。
- 真正调用可执行文件检查预算超限统计，使用极小测试预算确认 2/2 次超限；这不是业务时限。[合同/前置检查](records/arm-checks-20260930-112602-aeoh7_pt/checks.log)、[哈希与参数检查](records/arm-checks-20260930-112602-aeoh7_pt/artifact-and-options.log)、[预算测试](records/arm-checks-20260930-112602-aeoh7_pt/deadline-smoke.json)。

## 默认配置的当前本机数据

Darwin 25.6.0 / arm64，Apple Clang 21.0.0；Release，显式 NEON=ON，自动向量化=ON。各阶段预热 5 次，60 样本，iterations=1，阶段次序轮换；项目串行运行。预算未指定，JSON 标 NOT_SET。以下单位均为一次 invocation 的 µs，不能跨项目直接比较；60 样本最近秩 p99 等于本轮最大值。

| 项目及原始记录 | 工作量/invocation | baseline p50 | stage1 p50 | optimized p50 | optimized p95 |
| --- | --- | ---: | ---: | ---: | ---: |
| [01_camera_resize](01_camera_resize/records/ARM_VALIDATION.md) | 8 帧/批 | 1031.666 | 1208.458 | 633.459 | 656.375 |
| [02_lidar_filter](02_lidar_filter/records/ARM_VALIDATION.md) | 65536 束/扫描 | 435.542 | 413.250 | 271.500 | 330.416 |
| [03_imu_ring_buffer](03_imu_ring_buffer/records/ARM_VALIDATION.md) | 4096 IMU 样本/批 | 543.625 | 671.458 | 81.000 | 83.584 |
| [04_motor_command](04_motor_command/records/ARM_VALIDATION.md) | 2048 控制周期/批 | 2374.042 | 2318.709 | 1082.708 | 1135.916 |
| [05_telemetry_batch](05_telemetry_batch/records/ARM_VALIDATION.md) | 8192 事件/批 | 1005.791 | 932.875 | 1030.375 | 1059.375 |
| [06_image_normalize](06_image_normalize/records/ARM_VALIDATION.md) | 921600 像素/帧 | 901.542 | 182.709 | 266.500 | 280.750 |
| [07_pointcloud_layout](07_pointcloud_layout/records/ARM_VALIDATION.md) | 131072 点/帧 | 928.167 | 931.417 | 504.792 | 647.958 |
| [08_sensor_fusion](08_sensor_fusion/records/ARM_VALIDATION.md) | 2048 轮速观测/批 | 1217.458 | 1180.625 | 896.708 | 944.250 |
| [09_modbus_parser](09_modbus_parser/records/ARM_VALIDATION.md) | 2048 响应/批 | 522.167 | 466.208 | 444.750 | 479.667 |
| [10_event_log](10_event_log/records/ARM_VALIDATION.md) | 4096 日志/批 | 4966.583 | 853.709 | 789.875 | 836.250 |

## ARM 指令与对照证据

01 已实现每轮两行各 16 个输入像素 → 8 个整数 box 输出 → FP32；覆盖所有 0..1020 四像素和、lane、奇数边界、非对齐 ROI 与无 padding 情况。06 原有 NEON 路径已统一接入开关，保留完整张量容差测试。

使用实际 compile_commands 生成汇编并成功保存四份配置记录；01 的相机业务循环可见 ld2.8b，06 可见 ld3.8b。不能只凭助记符推断性能。[相机汇编](01_camera_resize/records/arm-codegen-neon-on-auto-on/0-camera.s) · [归一化汇编](06_image_normalize/records/arm-codegen-neon-on-auto-on/0-main.s)

| 项目 | 显式 NEON | 自动向量化 | 同一 optimized 算法 p50 µs | p95 µs |
| --- | --- | --- | ---: | ---: |
| 01 | ON | ON | 633.459 | 656.375 |
| 01 | OFF | OFF | 894.875 | 944.625 |
| 01 | OFF | ON | 672.000 | 678.666 |
| 01 | ON | OFF | 664.042 | 672.792 |
| 06 | ON | ON | 266.500 | 280.750 |
| 06 | OFF | OFF | 531.125 | 553.625 |
| 06 | OFF | ON | 180.958 | 183.500 |
| 06 | ON | OFF | 268.250 | 283.167 |

01 本轮 ON/ON 更快；06 本轮 OFF/ON 更快，手写 NEON 并非默认最优。配置之间为顺序执行的一轮开发机对照，不能保证相同温度和调度，也不能外推 Cortex-A55/A76。完整 CSV 和每配置日志见逐项目记录。

## 板端工具具体防止的误判

探测器同时考虑 MIDR/cpuinfo 身份、在线状态和当前允许 affinity；核型映射与 [Linux AArch64 定义](https://raw.githubusercontent.com/torvalds/linux/master/arch/arm64/include/asm/cputype.h) 一致。缺少明确拓扑不能猜 cluster；两核 part 相同也不能证明 SoC 身份，device-tree 另记。

每轮前后在 taskset 下记录实际允许集合，与请求集合逐一核对；前后二进制 SHA 必须一致。跨核结果摘要/工作量不一致会使汇总 FAILED。缺轮次、缺阶段、perf 失败/不支持、未知 profile/mode 都不能填成完整有效证据。perf 覆盖率、采样完成状态、预算结果分别报告。

预算缺失与真实超限已经通过 fixture 和实际可执行程序检查；COMPLETE 只代表采集完成。脚本还没有在真实 RK3588 上执行，不能以这些检查冒充板端驱动、内核权限、热行为或性能通过。

## 实际运行入口

~~~sh
# 任一项目：Mac 功能与数据协议
bash run-mac.sh --samples 60

# 配置真实 CROSS_CXX / SYSROOT / BOARD 后：目标板实验
RK_TUNE=generic bash build-rk3588.sh
RK_TUNE=generic RK_MATRIX=1 BOARD=user@rk3588-host bash run-rk3588.sh
~~~

完整的同二进制绑核、不同 tune 对照、预算设置与回退流程见 [ARM 性能实验路线](ARM_PERFORMANCE.md)。
