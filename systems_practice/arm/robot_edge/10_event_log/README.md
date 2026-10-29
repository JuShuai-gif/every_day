# 10：工业事件日志的真实文件输出与有界缓冲

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

这个独立 C++17 项目把按顺序到达的设备事件编码成 CSV 行，并实际写入临时普通文件。对照每条日志一次写入、64 KiB 缓冲、固定内存整数编码三个阶段，校验完整文件内容一致，并处理短写、EINTR、磁盘写入失败和最终 flush。

临时文件创建后立即 unlink，但文件描述符继续可用；每轮 truncate 并复用同一文件。因此测试不在工作目录生成大量日志，也不会在循环中无限增长文件。测的是文件系统 page cache 接收，**没有调用 fsync，不代表断电持久化完成**。

## 项目结构

```text
src/main.cpp              入口、可核查的 write 次数与测量范围
include/event_log.hpp     Event、文件 sink、写全循环、编码、缓冲、故障测试
include/edge_bench.hpp    采样/分位数/CSV/进程资源统计
CMakeLists.txt            独立构建、CTest、sanitizer
run-mac.sh                Mac 构建、测试、运行、归档
build-rk3588.sh            交叉编译 Linux AArch64
run-rk3588.sh              部署与环境/perf/结果取回
scripts/collect.sh         板端采集
records/TEMPLATE.md        每轮优化记录
```

## 业务合同

每条 Event 包含 `timestamp_us, sequence, level, code, value`；输出行例如：

```text
0,0,INFO,7,-5
12,1,ERROR,42,9
```

- 时间和序号为 64 位无符号整数，code 为 32 位无符号整数，value 为 64 位有符号整数；标签只允许 INFO/WARN/ERROR，不接受用户文本，因此本例不存在 CSV 引号转义需求。
- 按输入顺序写全所有事件，不限流、不抽样、不丢低优先级日志。三个阶段必须逐字节一致。
- 默认 4096 条事件；编码 scratch 128 字节，优化版输出缓冲最多 65536 字节。输入 vector 是离线录制数据，内存随输入大小增长；有界的是处理临时内存。
- 缓冲满或本批结束时写出；`finish()` 显式传播最终写入失败。没有定时 flush：如果移植为常驻服务，必须额外定义最大可接受日志驻留时间。
- 正确处理短写和 EINTR；write 返回 0、ENOSPC 等立即失败；错误后文件可能只包含前缀，程序不报告成功。没有实现掉电恢复、轮转、异步队列或崩溃重放。

## 优化阶段和可验证假设

| 阶段 | 实现 | 验证方式 |
| --- | --- | --- |
| baseline | 每条创建 `ostringstream`，生成字符串后直接 write | 默认正常文件通常为 4096 次 write；看格式化和系统调用开销 |
| stage1 | 保持同一字符串格式化，追加到固定 64 KiB 缓冲 | write 次数应约等于 `ceil(bytes/65536)`；仍可能有逐条堆分配 |
| optimized | 保持同一缓冲，改为 `to_chars` 写入固定 128 字节行 scratch | 消除 stream/locale 和逐条字符串开销；完整输出仍一样 |

每个输入字节还会参与 FNV 消费哈希，保证测量输出被使用；哈希本身也包含在时间中。diagnostic 的 write_calls 是程序实际发起写调用的次数（短写/EINTR 重试也计数），不是估计。异常注入测试验证“写少了但返回成功”的 sink。

## 1. 构建、功能验证和 SLA

```bash
bash run-mac.sh --mode all --samples 30 --warmup 5
# 原始 CSV 自动位于本次 records/mac-*/samples.csv；自定义路径请直接运行二进制。
./build/native/event_log --test
```

先填写事件吞吐、每批 p95/p99、允许 buffering 时间、内存和持久化语义。当前项目没有预设工业日志 SLA。若业务要求每条日志落盘，必须对三阶段加入同等 fsync 策略后重测，不能直接使用这里的加速比。

```bash
CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++ \
SYSROOT=/absolute/path/to/rk3588-sysroot bash build-rk3588.sh
BOARD=user@rk3588-host bash run-rk3588.sh
```

Mac 构建用于功能和测量流程验证；交叉编译器必须能在 Mac 执行，sysroot 与板端库匹配。部署脚本拒绝 Mach-O，把证据取回 `records/rk3588-*`。没有板端实测时不要填写 eMMC/NVMe 日志吞吐结论。

## 2. 确认文件系统与测量范围

临时目录来自 `std::filesystem::temp_directory_path()`。板端 `/tmp` 可能是 tmpfs，所以必须记录 `TMPDIR`、`df -T`/`findmnt` 和设备类型。如果要在特定数据盘验证，可在已有测试目录中设置 `TMPDIR` 后运行程序；结果不能跨文件系统直接比较。

计时包含 truncate/seek、编码、哈希、write 和最后的用户缓冲 flush；文件创建与数据集生成在计时外，文件关闭也在计时外。没有真实设备采集、异步日志线程或硬盘写入完成时延。

## 3. 分阶段定位与改进

板端在同一挂载、同一输入和同一 CPU 允许集合分别采集：

```bash
./event_log --test
perf stat -e task-clock,cycles,instructions,context-switches \
  ./event_log --mode baseline --profile --samples 100 --iterations 5
perf record -g -o baseline.perf.data -- \
  ./event_log --mode baseline --profile --samples 100 --iterations 5
perf report --stdio -i baseline.perf.data > baseline.perf.txt
strace -c -e write,ftruncate,lseek \
  ./event_log --mode baseline --profile --samples 10 --warmup 0
```

分别替换为 stage1 和 optimized 并独立保存。对照 write 系统调用次数和格式化热点，解释 stage1/optimized 的额外收益。strace 会改变运行耗时，只用于归因，不作为正式时延数据；stdout 写入也包含在系统级 write 计数中。perf 计入初始化，而程序报告的计时不计入初始化。

若 stage1 已消除大部分时间，再确认 optimized 是否值得维护；若 hash 或内核写入占主导，记录该事实。不要把未观测到的 `memcpy`、磁盘带宽或锁竞争宣称为瓶颈。

## 4. 内容与失败回归

`--test` 实际回读文件、与手写 golden 和独立 `to_string` 参考全文比较。覆盖空日志、4096 条有序日志、所有级别、UINT64_MAX/UINT32_MAX/INT64_MIN/INT64_MAX、容量 7 字节导致跨行/跨字段 flush、最后不足一块的数据写出，以及模拟每次只写 3 字节/EINTR/ENOSPC/零进展。

```bash
cmake -S . -B build/asan -DCMAKE_BUILD_TYPE=Debug -DEDGE_SANITIZE=ON
cmake --build build/asan -j 2
ctest --test-dir build/asan --output-on-failure
./build/native/event_log --mode optimized --seconds 60 --iterations 10 \
  --samples 30 --csv records/stress.csv
```

长测每轮 truncate，验证资源复用和结果稳定，但并不执行磁盘填满或真实断电测试。`iterations=10` 的分位数对应批次平均值；验收单次批次尾延迟使用 1。Sanitizer 用于正确性检查，其性能不能与 Release 比较。

## 5. 验收与归档

记录每个阶段的字节数、事件数、完整内容测试结果、write_calls、buffer_peak、p50/p95/p99/max、吞吐和 RSS；再记录实际磁盘/文件系统、频率/温度、采样命令、源码与编译参数。优化只能在同一内容、同一错误处理和同一持久化合同下比较。

真实工业部署的后续工作是有界异步队列、日志轮转、定时 flush/fsync、队列满时业务策略以及崩溃恢复。当前交付已覆盖编码到文件 write 的闭环，不声称已经完成上述常驻日志服务能力。
