# 多轴命令网关：校验、全轴失能与固定帧编码

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

工程模拟机器人上位控制器的 12 轴命令处理链：时间/结构验证 → 位置/速度/力矩限值 → 按轴号整理 → 二进制编码 → CRC → 传输缓冲。默认重放 2,048 个周期，输入含重复轴、过期命令、越限和急停请求。

程序只生成内存中的自定义协议帧，不连接电机或发送命令。全轴失能是软件消息合同，不代表硬件功能安全认证；产品仍需独立急停、驱动看门狗和总线验收。

## 独立工程结构

`include/motor.hpp` 是数据模型、验证器、编码器、两种 CRC 与处理器；`tests/self_test.hpp` 是独立字节布局检查、CRC 已知答案、故障语义及全帧对照；`src/main.cpp` 是自检和测量入口。目录内包含 CMake/CTest、sanitizer、Mac 与 RK3588 构建/部署脚本、环境/perf 采集、CSV 与实验模板。

## 数据合同与资源边界

- 每周期恰好 12 个不同轴 ID（0–11），允许乱序，输出升序。
- 位置 mdeg：±180000；速度 mdeg/s：±360000；力矩 mN·m：±12000，边界包含。
- 源时间戳不得晚于当前时间，年龄至多 5000 µs。
- 任意结构错误、超时、越限或急停使本周期所有轴失能、三个设定值清零，禁止“忽略坏轴继续发送其他轴”。
- 状态字为 stale=1、bad_axis=2、limit=4、stop=8、bad_count=16，允许同时置位。
- 单批至多 8192 周期，每周期最多验证 13 条命令（包含多一条的错误案例）；更大输入直接拒绝整批，限制坏输入耗时。
- 每批独立，不实现跨周期序号防重放、网络认证、总线发送或队列；真实集成需补这些状态合同。

## 自定义 wire 格式

多字节字段全部小端；有符号设定值按模 2³² 编码，不发送包含 padding 的 C++ struct。

| 偏移 | 长度 | 内容 |
| --- | ---: | --- |
| 0 | 2 | `A5 5A` |
| 2 | 1 | 版本 1 |
| 3 | 1 | 错误位图，0 为正常 |
| 4 | 4 | 序列号 |
| 8 | 8 | 当前单调时间戳 µs |
| 16 | 1 | 轴数 12 |
| 17 | 12×14 | 每轴：ID(1)、位置(4)、速度(4)、力矩(4)、使能(1) |
| 185 | 2 | 前 185 字节 CRC |

总长 187 字节。CRC polynomial=0x1021，init=0xffff，无反射/末尾异或；已知输入 `123456789` 的结果为 `0x29b1`。此协议不代表 CANopen、EtherCAT 或 Modbus。

## 分阶段优化

| 阶段 | 实际实现 | 定位假设 |
| --- | --- | --- |
| baseline | 每周期创建动态命令/字节容器，逐位 CRC，再复制到输出 | 分配、复制、CRC 占比 |
| stage1 | 固定轴数组，直接写 packet，复用输出容量；保留逐位 CRC | 隔离分配/复制减少的收益 |
| optimized | 相同数据路径，CRC 换初始化时构造的 256 项表 | 指令减少是否改善全管线时间 |

三个阶段保留所有校验和相同 wire bytes。若 CRC 占大头，预分配可能收益很小；编译器也可能优化掉部分容器开销，应依据目标板热点归因，不先承诺加速比。

## 可执行优化闭环

1. 复制记录模板，先写轴数、控制周期、命令年龄、总线预算和内存上限。当前測整批编码吞吐，真实 deadline 还要留调度/发送预算。

2. Mac 构建、自检、ASan/UBSan 与结果归档：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/motor_command --test
   ./build/native/motor_command --mode all --samples 120 --csv records/manual-samples.csv
   ```

   `records/mac-*` 保存 CTest、编译命令、环境和原始 CSV。自检检查负数 wire bytes、轴序、错误状态、全零失能和边界，不只比较摘要。

3. 在 Mac 使用能运行于 Mac 的 Linux/aarch64 工具链与匹配 sysroot：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   替换实际路径与 SSH 地址，核对 ELF、依赖及校验和。脚本上传到唯一临时目录，先板端自检再采样，保存环境/频率/温度/perf 并拉回本地；Mac 本机结果不能替代 RK3588 数据。

4. 通过 lscpu/MIDR 确认 CPU 编号后设置 `CPU_SET`，同核同输入重复比较。板端对 baseline、stage1、optimized 各执行并保存独立输出：

   ```bash
   ./motor_command --test
   perf stat -r 5 -e cycles,instructions,cache-misses,branches,branch-misses \
     ./motor_command --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./motor_command --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   ```

   修改模式时也改数据文件名。记录 CRC、分配、复制热点；PMU 为进程范围，含初始化/预热/摘要，权限失败需原样记录，不能填写假数据。

5. 逐字节回归后做至少一分钟压力：

   ```bash
   ./motor_command --mode optimized --seconds 60 --samples 120 --iterations 1 \
     --budget-us 10000 --csv motor-stress.csv
   ```

   10 ms 是整批 2048 周期的示范预算，`sample_budget_misses` 不是电机真实周期错过 deadline 的次数。1 kHz 硬件验收应逐周期测到达、调度、编码、发送、应答与故障恢复。

6. 记录每阶段结果、验收决策、新热点及原因；没有明显收益或尾延迟退化就保留基线，不能只选最好的一次。业务限值若变，先修改合同/独立预期测试再测性能。

## 指标解释与接入边界

每次调用为 2048 周期，耗时含验证、完整帧编码及所有 packet 摘要，吞吐为周期/秒。不能把批次 p99 除以 2048 当单周期 p99。`safe_stop_frames`/`late_input_frames` 来自合成坏输入，不是编码速度导致的故障。`workspace_reserved_bytes` 是输出容量与表，RSS 是全进程峰值。

测试覆盖 CRC 独立答案、字节布局与符号、乱序轴、重复/非法/缺失轴、时间/限值边界、急停、空输入、超容量及重复调用。RK3588 指标待实测；真实工程还需总线协议、接收状态机、时间同步、丢包/重复、驱动失联与安全恢复验收。
