# 08：双传感器时间对齐与有界融合流水线

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

这个独立 C++17 项目回放 IMU 和轮式里程计的角速度记录：两个真实生产线程完成零偏校正，分别送入有界队列，主线程按轮速时间戳线性插值 IMU，再输出加权角速度。输入是确定性模拟数据，不连接 ROS、CAN 或真实传感器。

目标是学习如何把线程、时间对齐、背压、停止与排空加入同一份可测量程序。这里的融合是明确的教学模型，不是 EKF、导航解算或硬实时控制器。

## 项目结构与阅读顺序

```text
src/main.cpp              参数入口、统计输出、三个阶段的基准
include/fusion.hpp        数据合同、两种队列、流水线、独立参考和自测
include/edge_bench.hpp    预热、轮换采样、分位数、CSV、进程资源统计
CMakeLists.txt            独立构建、CTest、ASan/UBSan/TSan 选项
run-mac.sh                Mac 构建/自测/采样/归档
build-rk3588.sh            Mac 上交叉编译 Linux AArch64 ELF
run-rk3588.sh              上传、板端采集、取回记录
scripts/collect.sh         板端环境、验证、perf 和结果采集
records/TEMPLATE.md        本案例的实验记录和验收清单
```

先读 `Sample/Input/Result`，再读 `reference()` 的数学定义，之后阅读 `Queue/Reader/run()`，最后看 `self_test()` 的失败路径。

## 业务合同和边界

- 默认 8192 条 IMU（时间间隔 1000 μs）和 2048 条 wheel 记录（间隔 4000 μs，偏移 250 μs），每路时间戳必须严格递增且数值有限。
- 两路时间已经映射到同一个单调时钟。IMU 校正为 `raw - 0.01`；wheel 校正为 `raw + 0.02`。
- 对 wheel 时间 `t` 找到包围它的两个 IMU 样本并插值；恰好命中时间戳时直接采用。输出 `0.75 × imu(t) + 0.25 × wheel(t)`。
- 超出 IMU 时间覆盖范围的 wheel 显式计入 `unmatched`，不外推。默认数据没有未匹配记录。
- 每路队列容量 64，满时阻塞；不通过丢样本制造优化收益。optimized 的每个 reader/producer 临时块最多 16 条，因此“队列容量 64”不是整个流水线只驻留 64 条数据。
- 源录制数据和输出数组按输入规模占用内存；流式传输的 queue/cache 有固定上限。默认输出上限 2048 条。
- `close()` 唤醒等待者并允许排空；wheel 结束后继续排空 IMU，最后 join。线程创建/消费失败会先关闭两路队列再 join，避免满队列上的生产者永远等待。

## 分阶段优化及归因

| 阶段 | 实际实现 | 要验证的瓶颈假设 |
| --- | --- | --- |
| baseline | 每条记录一次队列锁；有界 `deque` 保存记录 | deque 分配/回收与大量锁、唤醒造成开销 |
| stage1 | 改成固定 64 元素环，仍逐条 push/pop | 固定存储是否减少分配成本；锁数量没有因此减少 |
| optimized | 固定环 + 每次最多 16 条批量入队/出队 | 摊薄锁和条件变量开销；降低上下文切换 |

三个版本的融合公式、输入、输出和满队列策略相同。批量传递在真实低频输入下可能增加等待时间；这里回放已经存在的记录，不模拟 wall-clock 到达，因此结果只能说明回放吞吐/总耗时。不要把总批次 p99 当作单个传感器消息的端到端 p99。

## 1. 定义验收并编译

在本目录运行：

```bash
bash run-mac.sh --mode all --samples 30 --warmup 5
# 原始 CSV 自动位于本次 records/mac-*/samples.csv；自定义路径请直接运行二进制。
./build/native/sensor_fusion --test
```

开始测量前在记录表填写目标板的批次延迟预算、最小收益、可接受 p99 变化和长测时长。暂未给定业务 SLA，项目不声称已经达到工业控制周期。

Mac 能独立检查代码、线程退出和采样协议。Mac 生成的是 Mach-O；板端要求 Linux ELF：

```bash
CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++ \
SYSROOT=/absolute/path/to/rk3588-sysroot bash build-rk3588.sh
```

编译器必须可在 Mac 上执行，sysroot 必须与目标板的 libc/libstdc++ 匹配。交叉编译本身不等于板端验证通过。

## 2. 部署与记录环境

```bash
BOARD=user@rk3588-host bash run-rk3588.sh
```

脚本新建板端临时目录，保存编译信息、环境、输出与 perf 记录，取回到 `records/rk3588-*`，不会自动删除板端证据。用 `lscpu -e`、sysfs topology/cpu_capacity 和板级资料先确定 CPU 编号，再指定 `CPU_SET`；不要默认 `4-7` 永远是 A76。绑定整个进程时三个线程都在同一允许集合内，并不是分别绑定两条生产线程。

## 3. 测量与瓶颈定位

采样范围包括输入校验、队列/输出构造、两次线程创建、传输、插值、排空、join 和结果哈希。输入数据生成、独立自测、诊断打印不进入每次计时。`queue_waits` 是条件等待次数，`queue_peak` 是两路峰值的最大值；它们受调度影响，不参与 correctness 哈希。

在板端目录分别运行，不要把三个阶段混在同一份 profile：

```bash
./sensor_fusion --test
perf stat -e task-clock,context-switches,cpu-migrations,cycles,instructions \
  ./sensor_fusion --mode baseline --profile --samples 50 --iterations 10
perf record -g -o baseline.perf.data -- \
  ./sensor_fusion --mode baseline --profile --samples 50 --iterations 10
perf report --stdio -i baseline.perf.data > baseline.perf.txt
```

再将 mode 和文件名前缀改为 `stage1`、`optimized` 重复。检查是否存在 `pthread`/条件变量/分配函数热点，比较每条输出的 instructions、context-switches 和 wall time；这些是待采集证据，源码不能证明热点比例。`--profile` 跳过自测和额外诊断，但进程级 perf 仍包含一次数据生成/初始化。

如果线程创建占主导，下一轮实验应做常驻线程 + 多批次生命周期；不能从本程序推断常驻 ROS executor 的性能。若 stage1 几乎无收益，保留该结果并把重点转向锁粒度。

## 4. 正确性、资源和长测

`--test` 包含手算输出 `1.0/1.75/2.5`、前后越界、空流、单元素、容量 1 背压、IMU 长尾排空、重复完整数据、乱序拒绝、close 后 push/pop。完整输出逐项与二分查找参考比对（时间完全一致，数值误差 ≤ `1e-12`）；不以 checksum 相等替代正确性。

```bash
cmake -S . -B build/asan -DEDGE_SANITIZE=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build build/asan -j 2
ctest --test-dir build/asan --output-on-failure
cmake -S . -B build/tsan -DEDGE_TSAN=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build build/tsan -j 2
./build/tsan/sensor_fusion --test
./build/native/sensor_fusion --mode optimized --seconds 60 --iterations 10 \
  --samples 30 --csv records/stress.csv
```

TSan 是否可运行取决于主机运行时；记录真实退出码。`iterations=10` 的分位数是 10 次批次平均值，不能作单次尾延迟；尾延迟验收用 `iterations=1`。长测验证重复生命周期下退出和结果稳定，无法代替真实传感器数小时输入及断连重连测试。

## 5. 记录、结论与下一步

复制记录模板到本次新目录，归档命令、CSV、perf、CPU 亲和性、频率/温度和失败日志。通过条件：全部语义检查通过、queue_peak ≤ 64、默认 unmatched=0、没有挂起/数据竞争、同一板端环境下达到预先填写的预算。未连接 RK3588 前，板端吞吐和收益标记“未测”。

真实部署下一步接入同一时钟的驱动数据、取消与重连、常驻线程、每条记录的采集到发布延迟及超时策略；硬实时调度策略需在真实系统中单独验证。
