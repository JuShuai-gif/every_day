# 遥测出口：固定帧编码、短写重试与有界批处理

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

该工程模拟工业边缘网关汇集传感器事件后的出口：事件顺序检查 → 二进制编码和 CRC → 有界批处理 → 短写/暂不可写处理 → 输出字节流。默认重放 8192 条遥测，时间戳间隔 40 µs；每条事件带序列号、时间戳、传感器 ID 和有符号读数。

接收端是确定性的内存模型，每次最多接收 173 字节、每第 7 次调用返回暂不可写。这里没有 socket、系统调用或真实网络计时；`write_calls` 是模型调用次数，不能解释为实测系统调用数或实际网络收益。

## 独立工程与数据合同

`src/pipeline.hpp` 包含编码/解码、CRC、Sink、短写 drain 和三阶段管线；`tests/cases.hpp` 包含独立 CRC 预期、完整字节流对照、解码与故障测试；`src/main.cpp` 接入可重复测量。项目自带 CMake/CTest、ASan/UBSan、本机和交叉编译/部署脚本、环境/perf 采集、CSV/JSON 与 `records/TEMPLATE.md`。

帧总长 24 字节，多字节字段使用小端，自定义格式如下。它不冒充厂商现成协议。

| 偏移 | 长度 | 字段 |
| --- | ---: | --- |
| 0 | 2 | `A5 5A` |
| 2 | 1 | version=1 |
| 3 | 1 | flags=0 |
| 4 | 4 | sequence |
| 8 | 8 | time_us |
| 16 | 2 | sensor |
| 18 | 4 | value，模 2³² 编码的有符号整数 |
| 22 | 2 | 前 22 字节的 CRC |

CRC 初值 0xffff，逐位右移、多项式 0xa001，已知 `123456789` 对应 0x4b37。解码要求完整帧倍数、合法头部和 CRC；损坏或截断直接拒绝。事件时间允许相同，但不得倒序；批处理必须保持字节顺序和读数，不丢失或重复事件。

发送 workspace 是 64×24=1536 字节的固定数组，处理时最多保留 64 帧；输入向量在计时外构造。测试模式的 capture Sink 保存完整输出用于逐字节断言，正式基准只消费字节并累计摘要，因此其输出缓存不会随事件数增长。

## 三阶段与时间语义

| 阶段 | 实现 | 要验证的优化原因 |
| --- | --- | --- |
| baseline / Allocated | 每事件创建 24 字节动态容器，单帧 drain | 分配、编码与模型调用各占多少成本 |
| stage1 / Fixed | 复用固定缓冲，仍逐帧 drain | 单独测消除容器分配的收益 |
| optimized / Batched | 64 帧容量或最老事件等待 500 µs 时 flush | 少量调用处理更多字节的 CPU 成本与等待权衡 |

500 µs 是**虚拟时间**中的批处理期限。重放器在下一事件之前插入期限 flush；输入结束时立即排空尾批。即使下一事件很晚，模型的最老等待也不超过期限。真实服务需要定时器/事件循环主动唤醒；本例不保证 OS 调度下的 500 µs 延迟。

短写 drain 保留发送偏移；暂不可写超过连续 16 次会报错，但内置 Sink 每第 7 次才拒绝，因此默认重放覆盖短写与可恢复背压，不覆盖真实持续失联。真实接入要使用 poll/epoll 等可写通知，并明确断线、超时、落盘或丢弃策略，不能复制此模型的立即重试做网络忙等。

## 编译、部署、定位与回归

1. 先复制记录模板，填写事件速率、批容量、最大允许等待、丢失/重复容忍度、内存与吞吐目标。把 CPU 批次耗时和事件驻留时间分别定义。

2. Mac 编译并保存真实记录：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/telemetry_batch --test
   ./build/native/telemetry_batch --mode all --samples 120 --csv records/manual-samples.csv
   ```

   脚本归档编译选项、环境、CTest、ASan/UBSan、原始 CSV 和 JSON 汇总；`--test`/自选 `--csv` 用可执行程序直接调用，避免覆盖脚本管理的档案。

3. 在 Mac 上用可运行于 Mac、与目标 rootfs 匹配的 Linux/aarch64 工具链：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   先替换实际路径与 SSH 地址。检查 ELF、库依赖、上传校验和。读取板端 lscpu/MIDR 后按实际核编号设置 `CPU_SET`；A55/A76 分开归档，固定 governor/负载并保存前后温度与频率。Mac 的 Mach-O 与本机结果不等同于 RK3588 Linux。

4. 板端先 `--test`，再分别分析三个阶段，修改模式时也修改文件名：

   ```bash
   perf stat -r 5 -e cycles,instructions,branches,branch-misses \
     ./telemetry_batch --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./telemetry_batch --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   ```

   观察分配器、CRC、摘要与 drain 热点，核对 batching 是否减少模型调用。PMU 是进程范围，含初始化/预热；缺失权限/事件需保存失败信息。不能因调用次数减少就断言网络吞吐上升。

5. 每次改动后跑完整自检，再进行长测：

   ```bash
   ./telemetry_batch --mode optimized --samples 120 --seconds 60 --iterations 1 \
     --budget-us 10000 --csv telemetry-stress.csv
   ```

   10 ms 是一批 8192 事件的示范 CPU 预算，需改成业务目标；它与 500 µs 虚拟 batch dwell 是两个指标。至少重复 5 轮，记录摘要、p95/p99/max、RSS、温度及决定。

## 验收边界

计时包括整批验证、编码、模型 drain 及所有输出字节摘要；吞吐为事件/秒。单次 invocation 是 8192 条，p99 不能除以 8192 充当单事件 p99。`iterations>1` 得到批量均摊分位数；RSS 是整个进程峰值。

自检覆盖 CRC 独立答案、正负整数、空/单条、64 帧边界、尾批、同时间突发、500 µs 虚拟期限、短写/恢复背压、字节完全相同、解码原值、破坏 CRC、截断和倒序拒绝。没有真实 socket、包丢失或工业链路测试，RK3588 的性能结论必须在板端记录后填写。
