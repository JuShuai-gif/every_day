# 激光雷达扫描预处理：稳定压缩、坐标变换与障碍物扇区

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

本项目模拟移动机器人收到激光扫描后的 CPU 处理链：输入校验 → 有效点压缩 → 平面坐标变换 → 36 个扇区的最近障碍物距离。默认每帧 65,536 束，包含低强度、量程外、非法角度和过期数据。输出保留完整坐标和原始索引，不能用“距离求和一致”代替逐点验证。

驱动、UDP 解包、时间同步和运动去畸变尚未接入。计时范围是内存中一帧的完整预处理及输出摘要，不是传感器到控制器的端到端延迟。

## 独立工程结构

```text
include/lidar.hpp       数据合同、标定表、三阶段内核、固定输入
include/edge_bench.hpp  参数校验、重复计时、CSV、RSS、异常退出
src/main.cpp           正确性、工作负载与测量入口
tests/self_test.hpp    已知坐标、逐点对照、边界与负例
CMakeLists.txt         C++17、CTest、ASan/UBSan
cmake/rk3588.cmake     Mac 到 Linux/aarch64 的交叉配置
run-mac.sh             本机完整验证与归档
build-rk3588.sh        交叉编译与 ELF 检查
run-rk3588.sh          SSH 上传、板端采集、拉回证据
scripts/              环境清单、温度/频率和 perf 采集
records/              原始结果及 TEMPLATE.md 决策模板
```

## 正确性与资源合同

- 单帧至多 131,072 束。超过配置容量、起始时间晚于结束时间，整帧拒绝。
- 有效距离闭区间 `[300,8000]` 毫米，角度 `[0,3600)`（0.1 度），强度至少 20，时间戳位于扫描闭区间。无回波 0 被拒绝。
- 稳定压缩保留输入顺序与 `source_index`。三个版本共用初始化时建立的标定表和相同转换公式。
- 36 个扇区各 10 度，输出 count 与最近距离。空扇区距离 `UINT32_MAX`，下游应同时检查 count。
- 构造时限制容量并预留 workspace；输出 `workspace_reserved_bytes`，不包括输入、标定表或分配器开销。
- 单处理器非线程安全；当前无队列，因此不声称已测背压或实时丢帧率。

## 分阶段优化与定位假设

| 阶段 | 实现 | 保持不变 | 需要的证据 |
| --- | --- | --- | --- |
| baseline | 临时索引/点集，过滤、转换、扇区统计三遍 | 业务判断与完整输出 | 分配器、容器增长、遍历是否是热点 |
| stage1 | 预留并复用索引、点集容量 | 仍三遍处理 | p95、分配热点、instructions 变化 |
| optimized | 过滤、转换、扇区归约融合单遍 | 有效点顺序、坐标与计数 | 少写中间索引是否减少指令/缓存开销 |

不预设“去分支必然更快”。如果过滤比例低，融合循环的分支与标定表访问可能成为新瓶颈。收益归因必须分别比较 baseline→stage1 与 stage1→optimized；初始化标定表在计时外。

## 编译、部署、测量、定位、回归

1. 把 `records/TEMPLATE.md` 复制为本次实验记录，先写输入、单帧预算、内存上限和优化假设。

2. 在本目录进行 Mac 验证：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/lidar_filter --test
   ./build/native/lidar_filter --mode all --samples 120 --csv records/manual-samples.csv
   ```

   脚本将环境、编译命令、CTest、CSV 和 ASan/UBSan 保存到独立 `records/mac-*`。Mac 的 Mach-O 程序不能作为 Linux ELF 上传运行。

3. 在 Mac 使用可在 Mac 运行、且匹配目标 rootfs 的交叉工具链：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   工具链/sysroot/地址是需替换的配置。脚本保存 ELF 与依赖信息，在唯一远端目录运行并拉回记录；构建成功和板端运行成功分别记录。

4. 从板端 lscpu、MIDR、cpufreq 确认核类型，再设置实际 `CPU_SET` 重测；不要按固定 CPU 编号猜 A76/A55。保持同核、输入、编译参数，保存前后温度/频率。

5. 板端对各模式独立定位，先 `--test`，再跳过自检采样：

   ```bash
   ./lidar_filter --test
   perf stat -r 5 -e cycles,instructions,cache-misses,branches,branch-misses \
     ./lidar_filter --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./lidar_filter --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   ```

   将模式/文件名改为 stage1、optimized 分别执行。PMU 是进程范围，包含初始化、预热与摘要；没有权限时保留失败记录，不把缺失计数写成 0。

6. 回归全部输出，再做长测。下例 10 ms 是练习预算，需要按实际应用调整：

   ```bash
   ./lidar_filter --mode optimized --samples 120 --seconds 60 --iterations 1 \
     --budget-us 10000 --csv lidar-stress.csv
   ```

   保存长测前后温度和频率，检查完整摘要是否稳定、p99/max 是否退化。`--seconds` 是测量循环最短时长。单帧尾延迟使用 `iterations=1`，批量均摊分位数不能代替单帧 p99。

## 指标与验收

时间单位是“一帧处理加全输出摘要”，吞吐是输入束/秒（含被拒绝输入）。摘要消费所有坐标/扇区，为各阶段共同开销；RSS 是整个进程峰值，不能当单阶段内存。`rejected` 是输入质量计数，不是过载丢帧。

要求逐点、扇区与计数完全一致后，至少重复 5 轮比较 p50/p95/p99。自检覆盖已知 0/90 度坐标、量程/强度/角度/时间边界、稳定索引、空帧、最大帧、重复运行及容量拒绝。记录保留/撤回每项改动的决定；RK3588 性能与 PMU 结论只能由实际板端数据填写。

真实接入仍需验证驱动输入、时间同步、去畸变、包丢失与队列背压，本项目没有虚构这些硬件结果。
