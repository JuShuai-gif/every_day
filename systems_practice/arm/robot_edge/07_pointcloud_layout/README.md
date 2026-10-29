# 点云到局部障碍物栅格：复用 AoS 与分块 SoA

**ARM / RK3588 专项入口：[指令、核型、预算与部署实验](ARM_RK3588.md)。**

当前实测见 [ARM 验证记录](records/ARM_VALIDATION.md)；初次重构的结果保存在 [历史记录](records/REFACTOR_VALIDATION.md)。

工程模拟机器人收到驱动点云后的完整 CPU 管线：坐标变换 → NaN/Inf 分类 → 空间与强度裁剪 → 固定占用栅格的点数和最高高度。默认输入 131072 点，输出 128×128 栅格，每格 0.5 m；输入 AoS 每点 32 字节，带 xyz、intensity 及 ring/time 等元数据。

这里处理固定内存点云，不接入雷达驱动、ROS 消息或导航系统。栅格只记录计数/最高高度，不包含射线清空、概率融合或完整规划地图语义。

## 独立工程与正确性合同

`src/pipeline.hpp` 定义 Point/Transform/Grid/Workspace 和三阶段处理；`tests/cases.hpp` 提供已知栅格答案、逐格对照和错误输入；`src/main.cpp` 组织参考检查与计时。项目自带 CMake/CTest、ASan/UBSan、Mac 运行、交叉构建、SSH 部署、环境/perf 采集、CSV/JSON 及记录模板。

- 单帧至多 1,048,576 点；变换矩阵 12 个系数必须有限且绝对值至多 100。
- 输入默认旋转 90°再平移，参数和值选择可精确二进制表示的数，便于定位格子边界差异。
- 变换后 xyz/intensity 非有限的点记为 invalid；其余不满足裁剪的记为 rejected；其余 accepted，三者之和必须等于输入总数。
- 裁剪采用半开区间 x/y `[-32,32)` 米、z `[-3,3)` 米，强度至少 0.2。
- 栅格每格保存点数和 `floor(z×1000)` 毫米最高高度；空格高度为 `INT32_MIN`，下游需同时看点数。
- 32 m 上界相邻可表示浮点数仍在范围内，索引计算必须保持小于 128，不能让浮点舍入把合法点写到 grid 之外。
- Stage1 需要事先预留足够的变换/裁剪向量；容量不足拒绝。优化版只需固定 256 点的局部 SoA 数组；三个模式共用 workspace 对象不代表其实际工作区相同。

## 三阶段优化及开销范围

| 阶段 | 实现 | 假设与需要的证据 |
| --- | --- | --- |
| baseline / AllocatedAoS | 每帧分配变换和裁剪 AoS，三遍处理 | 中间内存、分配和元数据搬运是否占热点 |
| stage1 / ReusedAoS | 复用两个预留 AoS 容器，保留三遍 | 隔离去分配的收益 |
| optimized / BlockedSoA | 每次解包 256 点到 xyz/intensity 连续数组，变换后直接更新栅格 | 转换成本能否被局部性/向量化/少中间遍历收益抵消 |

AoS→SoA 在每帧计时内发生，没有把转换预处理放在外面。优化版除了布局，也融合了裁剪与栅格更新；不能将全部收益只归因于 SoA。是否自动向量化、网格随机写是否成为瓶颈，需看目标板编译和 profiling。

资源模型：输入 `N×32` 字节；baseline 最多另有两个 `N×32` 的中间向量；stage1 构造时预留相同容量；优化运算的 SoA scratch 为 `4×256×sizeof(float)=4096` 字节，栅格两数组共 131072 字节。基准同时保留 stage1 workspace，整个进程 RSS 不等于 optimized 独占工作区。

## 完整优化步骤

1. 先复制记录模板，写点数、AoS 来源/字段、外参、裁剪范围、地图分辨率、单帧预算和内存目标。语义固定后再比较性能。

2. Mac 构建、自检与归档：

   ```bash
   bash run-mac.sh --samples 30 --warmup 5
   ./build/native/pointcloud_layout --test
   ./build/native/pointcloud_layout --mode all --samples 120 --csv records/manual-samples.csv
   ```

   `records/mac-*` 保存编译选项、环境、CTest、ASan/UBSan、CSV/JSON。脚本自己的采样路径不能用自选 `--csv` 覆盖；自定义输出与 `--test` 直接调用程序。

3. 从 Mac 交叉编译并部署到 Linux RK3588：

   ```bash
   export CROSS_CXX=/absolute/path/to/aarch64-linux-gnu-g++
   export SYSROOT=/absolute/path/to/rk3588-sysroot
   bash build-rk3588.sh
   export BOARD=user@rk3588-host
   bash run-rk3588.sh
   ```

   路径与地址需要实际配置，工具链要能在 Mac 运行并匹配目标 sysroot。核对 ELF、依赖、二进制校验和；读 lscpu/MIDR 后设 CPU_SET，分别记录 A55/A76。固定输入/参数，采集前后温度和频率。

4. 板端先 `--test`，再分别定位三个阶段：

   ```bash
   perf stat -r 5 -e cycles,instructions,cache-misses,branches,branch-misses \
     ./pointcloud_layout --mode baseline --profile --samples 120 --iterations 5
   perf record --call-graph dwarf -o baseline.data -- \
     ./pointcloud_layout --mode baseline --profile --samples 120 --iterations 5
   perf report --stdio -i baseline.data
   ```

   对 stage1/optimized 修改模式与文件名。观察分配、变换、AoS 解包、裁剪与栅格散写热点。PMU 是进程范围，包含预热与摘要；不可用事件保留原始失败日志。不因布局改变就假设缓存 miss 必然改善。

5. 每项改动后逐格验证，再压力运行：

   ```bash
   ./pointcloud_layout --mode optimized --samples 120 --seconds 60 --iterations 1 \
     --budget-us 10000 --csv pointcloud-stress.csv
   ```

   10 ms 为示范单帧预算，应由传感器帧率/规划时限确定。至少 5 轮，记录 p95/p99/max、摘要和温度；变化不稳定时不要选最好一轮当结论。

6. 分别判断 baseline→stage1 与 stage1→optimized 的收益和新热点，填写保留/回退决定。若实际下游仍需完整变换点云，当前优化版只发布栅格的合同就不适用，应先增加对应输出再重新测量。

## 指标与验收边界

每次 invocation 是一帧从 AoS 到全栅格，并包含逐格完整摘要；吞吐是输入点/秒（含 rejected/invalid）。输入生成/外参建立在计时外；布局转换、清空栅格和基线临时分配在计时内。`iterations=1` 才是单帧采样，较大 iterations 为均摊延迟。RSS 是进程峰值。

自检逐格比较 counts/max_height 和分类计数，包含空输入、255/256/257 分块边界、已知两个点落同一格、负高度、半开空间边界、NaN/Inf、非法外参与不足 workspace。RK3588 的性能、温度与 PMU 仍需实测；真实接入还需坐标系约定、时钟、去畸变和地图发布接口测试。
