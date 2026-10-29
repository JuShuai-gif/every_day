# IMU 质量门控与滑动统计：从搬移窗口到增量归约

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

工程重放带时间戳的六轴 IMU 数据：值域验证 → 重复/倒序拒绝 → 采集间隙检测 → 时间/容量双重淘汰 → 每个有效输入的统计快照。默认 4,096 条输入、128 点窗口，包含非法读数、重复时间戳和断续采集。

此模块可作为机器人传感器前端的数据质量与去噪统计部分；没有读取真实 I²C/SPI，不实现姿态解算，也不混合加速度与角速度的单位。

## 独立工程

`include/imu.hpp` 定义输入、配置、快照、三阶段处理器与重放；`tests/self_test.hpp` 包含已知结果、事件语义和逐快照对照；`src/main.cpp` 接入基准。目录自带 CMake、CTest、sanitizer、Mac/交叉构建/SSH 运行脚本、环境与 perf 采集、CSV、`records/TEMPLATE.md`，可以单独复制构建。

## 数据与生命周期合同

- 六轴值使用定点整数，允许 `[-100000,100000]`，实际比例与单位需由设备标定确定。
- 时间戳为单调 `uint64_t` 微秒；重复/倒序拒绝，错误数据不推进“上一有效时间”。
- 相邻有效输入间隙大于 50 ms（可配置）时清空窗口，防止混合失联前后数据。
- 先淘汰超过 `max_age_us` 的旧项，再执行数量限制，最后插入。恰好处于时间边界的样本保留。
- 窗口 `1..1024`、单批至多 32,768 条；无效配置与超容量批次拒绝，空输入生成空输出。
- `int64_t` 和/平方和：最坏平方和 `1024 × 100000² = 10,240,000,000,000` 不溢出，乘法前拓宽，增量更新无浮点累积误差。
- 均值 `sum/count`，总体方差 `square_sum/count - mean²`；只对有效输入生成快照，count 不为零。若更换任意浮点输入，需重新考虑数值稳定性。
- 每次调用是独立有限重放，会 reset；持续采集应保持跨批状态并增加批次切分等价性/线程同步测试。

## 优化阶段

| 阶段 | 容器更新 | 统计更新 | 要验证的原因 |
| --- | --- | --- | --- |
| baseline | `vector.erase(begin)` 搬移旧项 | 每次扫描窗口 | 搬移与重复归约占比 |
| stage1 | 固定数组环形索引 | 仍扫描窗口 | 隔离免搬移收益与取模成本 |
| optimized | 相同环形结构 | 移除项减掉，插入项加上 | 从 O(window×axes) 变成 O(axes) |

baseline 已 reserve 窗口，不故意加入每样本分配。Stage1 可能因环形取模更慢，这是需保留的测量结果。所有模式生成相同的逐样本快照，不能通过少输出获得加速。

## 完整实验步骤

1. 在记录模板填写窗口、时间阈值、批处理预算和资源上限。默认 1 ms 时间戳间隔是输入模型，程序不按墙钟睡眠，不声称验证了 1 kHz 实时性。

2. Mac 构建、自检与归档：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/imu_ring_buffer --test
   ./build/native/imu_ring_buffer --mode all --samples 120 --csv records/manual-samples.csv
   ```

   `records/mac-*` 保存真实环境、编译命令、CTest、ASan/UBSan 与 CSV。独立已知窗口 `[2,3,4]` 验证均值 3、总体方差 2/3，而不只比同源实现摘要。

3. 在 Mac 使用可在 Mac 运行的交叉编译器与匹配 RK3588 Linux rootfs 的 sysroot：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   替换实际路径与地址；脚本不自带工具链。确认 ELF/动态库/校验和；本机 Mach-O 不可当 Linux 程序部署。

4. 目标板先 `--test`，确认 CPU 拓扑/MIDR 后设 `CPU_SET`，A55/A76 分开归档并记录前后温度/频率。该单线程模块没有必要为核数而拆线程。

5. 对三个模式各保存热点与 PMU，下面替换 mode 与文件名：

   ```bash
   perf stat -r 5 -e cycles,instructions,cache-misses \
     ./imu_ring_buffer --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./imu_ring_buffer --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   ```

   假设：baseline 搬移/归约占比高；stage1 免搬移但取模可能增加；optimized 的归约指令减少，输出快照/摘要成为新热点。PMU 包含进程初始化和预热，无计数证据时不宣称缓存 miss 已降低。

6. 每轮修改后跑 `--test`，再进行至少一分钟重放：

   ```bash
   ./imu_ring_buffer --mode optimized --seconds 60 --samples 120 --iterations 1 \
     --budget-us 10000 --csv imu-stress.csv
   ```

   示例 10 ms 是整批预算，不是单个控制周期 deadline。记录温度/频率、最坏延迟和摘要；真实 1 kHz 验收还要测实际到达、调度、单条处理与通信延迟。

## 验收与解释

要求每个快照时间戳/count/sum/square_sum 和事件计数完全一致。测试覆盖 1/3/128/1024 点窗口、负值、极限平方和、重复/倒序/过期/间隙、空输入、容量和重复执行。

CSV 的时间是一批 4,096 条处理加全输出摘要，吞吐为输入样本/秒。`iterations=1` 的 p99 仍是批次 p99，不能除以 4,096 称为单样本 p99。`workspace_reserved_bytes` 是预留窗口/环形数组/快照容量，RSS 是进程峰值。

分别记录两轮优化的结果与因果证据，stage1 变慢也保留。`rejected`/`gap_resets` 是合成数据质量事件，不是真实设备丢样率。RK3588 的性能门槛和热点待板端实测填写；持续采集的队列、并发与跨批状态仍是后续设备集成边界。
