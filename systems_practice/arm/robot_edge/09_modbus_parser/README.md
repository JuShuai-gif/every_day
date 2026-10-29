# 09：工业网关 Modbus TCP 流式响应解析器

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

这是独立 C++17 项目：把一条 TCP 接收字节流中的多帧 Modbus `Read Holding Registers` 响应还原为事务号、单元号和寄存器值。输入会分片、粘包，也包含正常异常响应；程序比较三种缓冲策略，并对非法报文和中途断流做拒绝测试。

它是网关客户端中的“接收和解码”组件。没有连接 PLC，没有实现 socket 重连、请求发送或未完成事务表；上层仍需验证事务号/单元号与请求匹配、寄存器数量与请求一致，并处理超时。

## 项目结构

```text
src/main.cpp              运行参数、诊断和三个阶段的基准
include/modbus.hpp        MBAP/PDU 校验、流式解析器、数据集、自测
include/edge_bench.hpp    统一测量与 CSV 输出
CMakeLists.txt            独立构建、CTest、sanitizer 选项
run-mac.sh                Mac 构建、测试、测量与记录
build-rk3588.sh            Linux AArch64 交叉编译
run-rk3588.sh              部署、收集环境/perf、取回记录
scripts/collect.sh         板端采集入口
records/TEMPLATE.md        每轮优化证据和结果表
```

## 协议合同

实现按 [Modbus TCP Implementation Guide](https://modbus.org/docs/Modbus_Messaging_Implementation_Guide_V1_0b.pdf) 的 MBAP framing 和 [Application Protocol V1.1b3](https://modbus.org/docs/Modbus_Application_Protocol_V1_1b3.pdf) 的功能码 `0x03` 响应进行解码。多字节整数为网络大端；TCP 版本没有 RTU 的 CRC 字段。

| 字段 | 本项目规则 |
| --- | --- |
| Transaction / Protocol | 保留 16 位事务号；Protocol 必须为 0 |
| MBAP Length | 包含 Unit 和 PDU；帧总长 = `6 + Length`；通用上限 260 字节 |
| 正常响应 | 功能码 0x03，byte-count 为 2..250 的偶数，必须与实际帧长度相等 |
| 寄存器 | 1..125 个 16 位无符号值，逐项保留 |
| 异常响应 | 功能码 0x83，长度必须恰好容纳一字节非零异常码；保留异常码供上层解释 |
| 错误路径 | 非法头、长度、功能码、byte-count 或 EOF 截断立即失败；连接视为不可继续 |

不尝试在非法数据里寻找“看起来像下一帧”的字节，避免错位后产生虚假寄存器值。本组件不声称支持全部 Modbus 功能码；非零未知异常码保留给上层，不判断设备扩展含义。

默认回放 2048 帧，每第 37 帧为异常，其余每帧 32 个寄存器；分片按 `1,2,7,31,509,3,127` 字节循环，最大接收块 512 字节。expected 数据是编码前的语义结构。各阶段解析器缓冲有上限，测试/基准保存完整输出以便消费，输出内存随帧数增长；生产系统应把每个 Response 交给有界下游队列。

## 优化步骤及待验证证据

| 阶段 | 实现变化 | 定位方向 |
| --- | --- | --- |
| baseline | 每个完整 ADU 复制为 vector，再 erase 接收缓冲前缀 | 小对象分配、memmove、重复前缀整理 |
| stage1 | 使用读取游标直接解码，每次 feed 最后整理一次剩余尾部 | 分配次数及搬移次数是否下降 |
| optimized | Header/Body 状态机，固定 260 字节；接收块内完整 ADU 直接解码，仅复制跨块帧 | 是否进一步减少复制、分支及缓冲峰值 |

不把“不做长度检查”作为优化。所有阶段使用同样的校验和响应结构。baseline/stage1 未完成尾部最多 259 字节，加接收块最多 512 字节，缓冲有效字节数不超过 771（预留容量 772）；optimized 固定 ADU 存储 260 字节。

## 1. 编译与确立验收

```bash
bash run-mac.sh --mode all --samples 30 --warmup 5
# 原始 CSV 自动位于本次 records/mac-*/samples.csv；自定义路径请直接运行二进制。
./build/native/modbus_parser --test
```

先在记录表写出目标帧率、每批 2048 帧的 p95/p99 预算、内存预算和最小收益。批次时间不是现场总线响应延迟；本例没有等待网络或 PLC 处理。

交叉编译使用可以在 Mac 执行的 Linux AArch64 编译器及匹配板端系统的 sysroot：

```bash
CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++ \
SYSROOT=/absolute/path/to/rk3588-sysroot bash build-rk3588.sh
BOARD=user@rk3588-host bash run-rk3588.sh
```

脚本会保留构建参数、板端环境、输出和采样记录。Mac 的 arm64 Mach-O 不能直接部署到 Linux。尚无目标板连接时，板端验证与性能保持“未测”。

## 2. 基准与 perf 定位

计时包含接收分片回放、缓冲整理、协议校验、解码、输出保存和全结果哈希；不包含数据集生成和自测。不连接网络，所以没有网络吞吐结论。`receive_buffer_peak` 只计算解析器内部有效缓冲，不是进程 RSS。

板端分别采集三个阶段：

```bash
./modbus_parser --test
perf stat -e cycles,instructions,branches,branch-misses,cache-misses \
  ./modbus_parser --mode baseline --profile --samples 100 --iterations 10
perf record -g -o baseline.perf.data -- \
  ./modbus_parser --mode baseline --profile --samples 100 --iterations 10
perf report --stdio -i baseline.perf.data > baseline.perf.txt
```

将 baseline 替换成 stage1 和 optimized 并重新归档。观察 vector 分配、`memmove`、decode 和结果存储占比，每帧 instructions/cycles 是否减少。不是所有内核都开放所有 PMU 事件；记录 perf 失败与事件不支持，不能填 0 或根据源码编造热点占比。`--profile` 跳过自测，perf 仍包含程序初始化。

若 optimized 在单字节分片下不更快，应单独记录该输入，而不是只保留完整帧快路径的结果。修改 `run()` 的 chunk schedule 做 `1` 和 `512` 两组对照时，保存修改及源码哈希，并确保三个阶段使用完全一致的 schedule。

## 3. 语义回归与故障输入

`self_test()` 包含：

- 手写 golden 帧 `12 34 00 00 00 07 01 03 04 00 2A 12 34`，验证事务 `0x1234`、单元 1、寄存器 42 和 `0x1234`。
- golden 在每个分割位置切分；逐字节异常帧；多个完整帧粘连；空流。
- 每个未完成前缀都必须在 `finish()` 失败；非零 Protocol、过小/过大 Length、错误功能码、奇数/零/不一致 byte-count 必须失败。
- 125 个寄存器边界和完整 2048 帧语义逐项比对；buffer_peak 上限检查。

```bash
cmake -S . -B build/asan -DCMAKE_BUILD_TYPE=Debug -DEDGE_SANITIZE=ON
cmake --build build/asan -j 2
ctest --test-dir build/asan --output-on-failure
./build/native/modbus_parser --mode optimized --seconds 60 --iterations 20 \
  --samples 30 --csv records/stress.csv
```

`iterations>1` 测的是批次平均值的分位数。验收单批尾延迟时设为 1。实际 PLC 接入后还应做重连、超时、重复事务、请求响应错配和上游洪泛测试；当前测试没有覆盖网络栈。

## 4. 记录与接受优化

按 `records/TEMPLATE.md` 记录每阶段校验结果、响应/异常数、缓冲峰值、p50/p95/p99/max、吞吐、RSS、源码版本、输入 schedule、perf 和温度。接受 optimized 的条件是完整语义无差异、错误输入仍严格拒绝，且在目标板上达到预先填写的收益/资源门槛。若收益不足，保留测量并说明限制，不以“用了状态机”作为性能结论。
