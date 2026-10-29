# 重构验证记录：2026-09-30

这是初次重构的历史归档，早于后续 ARM 专项增强。当前代码增加了 NEON 路径、编译对照、预算字段和板端矩阵工具；最新范围见 [ARM 专项验证](ARM_VALIDATION.md)。本页哈希核对是当次操作，不能等同于后续源码仍未变化。

10 个项目均已完成本机 Release 构建、正确性/异常测试、三阶段采样和 ASan/UBSan。01、08 的队列另外通过 TSan 自检。RK3588 交叉编译、部署、PMU 和持续运行尚未执行；当前环境未配置目标 sysroot、Mac 可运行的交叉工具链与 BOARD 地址。

## 本轮方法和证据

- 主机：Darwin 25.6.0 / arm64，Apple Clang 21.0.0，C++17，CMake Release；保留完整编译命令和源码、二进制 SHA-256。
- 每阶段预热 5 次、60 个样本、每样本 1 次 invocation，三阶段逐轮轮换次序。项目串行测量，没有并发跑其他项目基准。
- 每项目 4 项 CTest 全通过，共 40 项；内部自检覆盖已知答案、完整输出/容差和各业务异常。10 项 ASan/UBSan 自检通过，LeakSanitizer 明确关闭。
- 60 个样本的最近秩 p99 等于本轮最大值。当前只是一轮开发机观察，不是生产分位数或稳定加速比保证；不能跨工作负载比较下面的耗时。
- 最终审计核对了 10 份源码与二进制哈希、1800 行正式采样、51 个 Shell 脚本语法、10 个 Python 脚本语法、38 个 C++ 文件格式和 10 份一致的基准头文件。
- 另有每项目 0.2 秒 profile/iterations 参数冒烟运行，用来验证运行入口，不是长期压力验收，也不混入正式性能表。

[最终审计日志](records/host-checks-20260930-110208-a7lqkidc/checks.log) · [相机 TSan](01_camera_resize/records/tsan-20260930-110042-clqn9ltl/session.log) · [融合 TSan](08_sensor_fusion/records/tsan-20260930-110042-rxcidulc/session.log)

## 本机三阶段结果

单位为一次 invocation 的 µs。01 是 8 帧一批，其他批次定义见逐项目记录。倍率为 baseline p50 / optimized p50，低于 1 表示 optimized 在该轮更慢。阶段名表示实现候选，不保证逐步变快。

| 项目与详细记录 | baseline p50 | stage1 p50 | optimized p50 | baseline/optimized |
| --- | ---: | ---: | ---: | ---: |
| [01 相机预处理](01_camera_resize/records/REFACTOR_VALIDATION.md) | 1039.250 | 1204.083 | 638.709 | 1.63× |
| [02 雷达过滤](02_lidar_filter/records/REFACTOR_VALIDATION.md) | 483.333 | 460.584 | 276.375 | 1.75× |
| [03 IMU 时间窗口](03_imu_ring_buffer/records/REFACTOR_VALIDATION.md) | 540.959 | 674.792 | 80.916 | 6.69× |
| [04 电机命令编码](04_motor_command/records/REFACTOR_VALIDATION.md) | 2381.041 | 2311.291 | 1081.291 | 2.20× |
| [05 遥测批处理](05_telemetry_batch/records/REFACTOR_VALIDATION.md) | 1053.125 | 976.125 | 1076.250 | 0.98× |
| [06 图像归一化](06_image_normalize/records/REFACTOR_VALIDATION.md) | 895.834 | 181.334 | 266.250 | 3.36× |
| [07 点云栅格](07_pointcloud_layout/records/REFACTOR_VALIDATION.md) | 949.917 | 951.541 | 514.542 | 1.85× |
| [08 传感器融合](08_sensor_fusion/records/REFACTOR_VALIDATION.md) | 1258.917 | 1237.208 | 889.833 | 1.41× |
| [09 Modbus 流解析](09_modbus_parser/records/REFACTOR_VALIDATION.md) | 536.208 | 487.375 | 454.917 | 1.18× |
| [10 事件日志](10_event_log/records/REFACTOR_VALIDATION.md) | 5298.750 | 887.959 | 805.333 | 6.58× |

05、06 在本机优先保留 stage1 作为性能选择：05 的模拟批处理未得到 CPU 收益，06 的手写 NEON 也未超过编译器优化后的融合实现。01、03 的 stage1 变慢、07 的 stage1 接近无收益，均保留原始结果。10 的 optimized p50 更低但 p99 比 stage1 更高，不能把吞吐改善写成尾延迟全面改善。

## 本轮修正的可复现边界

- 点云：接近 32 m 上界的有效 float 坐标，原索引计算可能舍入到 128；改用 double 计算索引，新增 nextafter 边界回归。
- 图像：mean/stddev 自身有限仍可能导致 FP32 输出溢出；新增端点范围验证和正确输出形状下的负例，避免测试被无关形状错误掩盖。
- profiling：02–05、07 的诊断预跑在 --profile 中跳过，避免单阶段 PMU 混入其他实现。
- 脚本：完整保留错误日志与远程失败记录；板端测试、采样与 perf 均有超时；每次创建独立记录目录，不覆盖历史数据。

## 仍需目标环境提供的证据

目标 sysroot/工具链和 SSH 地址就绪后，在每个独立项目运行 build-rk3588.sh、run-rk3588.sh。采集 A55/A76 的实际核拓扑、频率/温度、三个阶段的 PMU 与真实设备输出。未完成这些步骤前，以上结论只用于开发机上的实现比较，不写“RK3588 验收通过”。
