# Thor SM110：最终 kernel、ncu 与 PTX/SASS

**唯一编译/执行目标是 Jetson Thor SM110（`sm_110`）。** 默认最终优化版是 `pool_direct`，`pool<false>` 和 `pool<true>` 是保留的基线与中间版本。三者做相同 `[2,197,67] → [2,25,67]` 池化，不改分组/精度/输出。本机没有 Thor、nvcc 或 ncu，优化收益尚未验证。

## 1. 为什么最终优化要改变输出所有权

| 阶段 | 完整代码 | 改动 | 可验证的代价与风险 |
| --- | --- | --- | --- |
| baseline | `pool<false>` | 普通加载，先写 shared tile，再跨 warp 消费 | 每块 4 KiB shared、256 线程、CTA barrier；真实指令构成由编译器决定 |
| async | `pool<true>` | 用 16 字节 cp.async + src-size 补零替代显式搬运 | 仍要等待与 CTA barrier；立即等待没有证明复制/计算重叠 |
| optimized（最终默认） | `pool_direct` → `direct_lane` | 一 warp 独占一个输出组，每线程最多四个累加器，直接按连续通道读取 | 32 线程、无显式 shared tile/CTA barrier；可能受驻留块上限、依赖链或寄存器压力限制 |

关键推导：本池化每个输入只用于一个输出，没有跨输出的数据复用。把同一元素分交给搬运线程和求和线程，制造了 shared 中转与通信需求。最终版让同一线程从加载到写出都拥有结果，才能合法消除这段通信。不是在原算法里盲目删 barrier，也没有把 cp.async 改为没有等待的错误代码。

相邻 lane 读取相邻通道，槽位对应 `lane+slot*32`。K=67 时 lane 0..2 各拥有三个输出，其余 lane 拥有两个；K=128 时每 lane 四个。原始 token 加法顺序保持不变，count 只计算有效行。CPU 中执行同源 `direct_lane`，与独立 oracle 比对，另验输出唯一所有权。

源代码能确认 shared 中间数组与显式屏障被移除；不能确认编译器是否产生 local spill、各版本真实指令数、寄存器数及实际 occupancy。优化证据链必须是：正确性 → 机器码/资源 → ncu 瓶颈证据 → 未附加 profiler 的延迟复测。若最终版实测回退，可部署基线并保留结果，不能强称最终候选是最快实现。

## 2. 实际可执行的 ncu 流程

固定使用支持 Thor SM110 的 ncu 和驱动组合。在板端记录 `ncu --version`、`nvcc --version`、JetPack/L4T、设备名/SM/runtime/driver（程序会输出后四项）及频率/功耗模式。不要仅依赖 nvidia-smi，在嵌入式软件栈中它不一定可用。

```sh
# 默认执行最终优化版；完整对照保持相同输入与计时边界。
./systems_practice/2026-09-18/run.sh gpu
./systems_practice/2026-09-18/build/gpu/ptx_pool --variant all
./systems_practice/2026-09-18/build/gpu/ptx_pool --sweep

# 脚本真实存在，自动查询版本/section/metric 并生成报告。
./systems_practice/2026-09-18/profile.sh baseline basic
./systems_practice/2026-09-18/profile.sh async basic
./systems_practice/2026-09-18/profile.sh optimized basic
./systems_practice/2026-09-18/profile.sh optimized detail
```

每次脚本新建 `build/ncu-<variant>-XXXXXX/`，保存工具版本、可用 section/metric、二进制哈希、采集日志、`report.ncu-rep` 和 `details.txt`；不会覆盖旧报告。detail 请求的 section 若缺失会明确失败，先查看 `sections.txt` 后按实际工具能力调整；不得把不存在的指标填成零。

脚本核心命令如下（`REPORT` 是脚本创建的实际目录；手工使用时替换路径）：

```sh
ncu --profile-from-start off --kernel-name-base demangled \
  --kernel-name 'regex:.*pool.*' --launch-count 1 --set basic \
  -o REPORT/report systems_practice/2026-09-18/build/gpu/ptx_pool --profile optimized
ncu-ui REPORT/report.ncu-rep
ncu --import REPORT/report.ncu-rep --page details
```

`--profile optimized` 只运行主测 Shape 的最终版：在采集范围外完成正确性检查及 20 次预热，随后 `cudaProfilerStart()` → 一个 kernel → stream wait → `cudaProfilerStop()`，范围外 D2H 后再次验证。`--profile baseline/async` 保持同样步骤。名称过滤不依赖 bool 模板名的具体展开形式，也不依赖旧版的 `--launch-skip 27`。确认报告只包含期望 kernel，grid=50，优化版 block=32，另外两版 block=256；零 kernel 或选错 Shape 不算成功。

## 3. 看哪些指标，怎样决定下一步

| 问题 | ncu section / 信息 | 证据与推断边界 |
| --- | --- | --- |
| 是否受带宽限制？ | SpeedOfLight、MemoryWorkloadAnalysis：DRAM/L2 吞吐、请求/事务、缓存命中 | 低有效带宽不必然是带宽饱和，也可能任务太小或缺乏 ready warps；先看实际事务利用率 |
| shared 消除是否体现在机器码？ | Source 页 CUDA/PTX/SASS 对应；可用的动态指令信息 | 最终版不应有算法需要的 shared 中转/barrier；仍须查 spill/local 访问，源代码无 shared 不代表零额外访存 |
| 是否受资源限制？ | LaunchStats、Occupancy：每块 register/shared、理论/实际 active warps 及限制因素 | 一个 warp/block 可能被最大驻留块数约束；高 occupancy 也不保证足够的 eligible warps |
| 线程为什么没有发射？ | SchedulerStats、WarpStateStats：eligible/issued warps、依赖/屏障等待 | 把 stall 回溯到产生依赖的访存、算术或不同到达时间；不能单靠最高百分比决定删代码 |
| 热点在哪个依赖链？ | SourceCounters、源码/SASS 视图、目标支持时的 PC 采样 | 消费者 PC 上的停顿可能来自更早的 load；短 kernel 的样本可能不足，不能假装每条指令都有可信周期 |

basic 确认目标与大方向后，对相同条件的三版本分别使用 detail；只采最终版无法解释改动是否有效。CMake 使用 `-lineinfo`，不要改为 `-G` 后报告正式性能。详细指标名依 ncu/SM110 支持情况通过 `--query-metrics` 查询，不硬编码其他架构的计数器。

ncu 的 replay、cache 控制与计数器收集会改变条件，记录其设置。正式 GPU event p50/p95 与主机 H2D+kernel+D2H+wait p50/p95 使用无 ncu 程序，预热后 100 样本，至少独立复测三轮。不能把 profiler 中的单次耗时或 CPU 测试耗时当提速证据。

## 4. 今天交付的 PTX 和真实 SASS 的获取

[pool_direct.ptx](src/pool_direct.ptx) 是完整的**手写 PTX** 等价算法，声明 `.version 9.0`、`.target sm_110`、64 位地址，参数与 CUDA kernel 对齐。为便于阅读，它逐通道累加；CUDA 最终版交错维护四个独立累加器，因此不能把手写指令数当作 C++ 编译器的指令数。该手写文件没有被当前主程序加载，本机也没有 ptxas，汇编与执行都未验证。

实际 CUDA 源中的中间版本使用以下手写 inline PTX 模板；它们不是完整模块，也不是 SASS：

```ptx
cp.async.cg.shared.global [%0], [%1], 16, %2;
cp.async.commit_group;
cp.async.wait_group 0;
```

`%0` 是转换后的 shared 地址，`%1` 是 global 源地址，`%2` 是有效字节数。三条指令后必须有 staging 算法所需的 CTA 屏障。最终 direct 没有这段搬运/等待，因为已经消除了跨线程数据交换。

```sh
# 固定 SM110，脚本拒绝其他目标，包括未经确认的专属后缀。
./systems_practice/2026-09-18/export-isa.sh sm_110
```

导出脚本先按 SM110 重建，再记录工具链、CMake 参数、二进制/源码哈希，并生成：

- `executable.ptx.txt` / `executable.sass.txt`：真实已构建 CUDA 二进制的 PTX/SASS，分析主体。
- `generated.ptx`：另用 `nvcc -std=c++17 -O3 -lineinfo -arch=sm_110 --ptx` 生成；所有参数显式记录，不假称与 CMake 每项选项完全一致。
- `handwritten.cubin` / `handwritten.sass.txt`：由 `ptxas -arch=sm_110` 单独汇编手写 PTX 后导出的指令；与主程序产物分开，不能声称这个模块执行过。

全部进入忽略的 `build/isa-sm110-XXXXXX/`。完整源码关联在 ncu Source 页完成；归档热点文本时标明 kernel、实际 PC 地址、源行、计数器、版本、目标和哈希，不编造 SASS 地址/寄存器/助记符。当前本机没有真实 SASS 文件，只有手写 PTX 和可执行导出脚本。

## 5. 哪些指令或依赖可能耗时长

| 指令/代码位置 | 为什么值得关注 | 怎样确认 |
| --- | --- | --- |
| 最终版 `input[...]`；手写 PTX 的 `ld.global.f32` | cache miss、事务利用率差或 load-use 等待；实际 SASS 的具体 load 变体需导出 | 看内存事务/缓存与依赖等待，并定位后续消费者，不能赋予所有 load 一个固定周期 |
| `sums[slot] += value`；手写 PTX 的 `add.rn.f32` | 同一输出有八步串行依赖，四个 slot 是可并行的独立链 | 查 nvcc 是否展开/交错调度、是否寄存器化，关联 eligible warps 和依赖 stall |
| `sum/count`；手写 PTX 的 `div.rn.f32` | C++ 可能被降低为多条算术指令，或由编译器利用分母范围 | 查真实 SASS；手写 PTX 的单条除法不代表最终单条机器指令，不直接放松精度换性能 |
| 中间版 `cp.async` → `wait_group 0` | 数据未到导致等待；发出异步操作不等于隐藏其延迟 | 联合复制路径、warp 调度与等待位置分析，不把 wait 的停顿误判为 wait 自身计算慢 |
| staging 的 CTA barrier 对应机器码 | 不同 warp 的生产工作/到达时间差导致等待 | 确认依赖后保留必要屏障；只有改变所有权才能合法消除 |
| 地址计算中的整除/取余 | group → batch/tile 的索引分解可能产生较长整数序列 | 查看编译器对运行时除数的处理及执行次数，只有在端到端证据支持时再调整 grid 映射 |

这里列的是潜在热点，不是 Thor 上的实测排名。单指令延迟、发射吞吐、动态次数、依赖链等待和 kernel 总延迟不能混成一个数。没有设备数据或明确 SM110 一手依据时，不给“这条指令固定耗时若干周期”的结论。

## 6. Thor SM110 与其他架构的指令差异

当前代码只为 Thor SM110 生成 PTX/SASS，`__CUDA_ARCH__` 编译检查和运行时计算能力检查都限制为 1100 / 11.0。其他架构只用作知识对照。以下指令族的演进解释需在联网后与官方正文核对；本轮网络不可达，不冒称已经验证了 Thor 上全部特性的支持条件。

| 对照对象 / 机制 | 特点与本次选择 | Thor 上的使用边界 |
| --- | --- | --- |
| 较早架构的普通加载/存储及 warp 执行 | 连续 lane 的地址映射是合并访问基础；最终版依靠所有权与访存布局，不依赖矩阵运算 | 最终实现仍编译为 SM110；不生成旧架构代码 |
| Ampere 引入的 `cp.async` 路径 | global → shared 异步搬运、分组完成和补零，是本次中间版本 | 在 Thor 中属于沿用的机制，不应称为 Thor 独有；实际编译/设备行为待验 |
| Hopper 的 TMA、`cp.async.bulk.tensor` / `mbarrier` 机制 | 描述符与批量搬运适合有数据复用的 tile/pipeline | 本 kernel 缺少复用，不为展示新指令强加描述符和共享中转；具体 SM110 指令/同步条件需核对 |
| Hopper 的 `wgmma` 与 Blackwell 相关 `tcgen05` / Tensor Memory 路线 | 表示不同矩阵执行/数据放置机制，不能把 Hopper 路径直接视为 Thor 对应路径 | 本次不是 GEMM，不使用；未经 Thor 专属支持表、dtype 和目标后缀核实，不把任何一族写进可执行代码 |
| 架构专属 `a` / 家族 `f` 特性目标 | 编译目标后缀涉及不同的特性与兼容边界 | 用户指定 `sm_110`；本次明确不切到 `sm_110a`，也不借用其他 Blackwell 产品的 SM100/SM120 能力表 |

“特色”应注明是新引入、加强、沿用还是目标专属；不是所有新架构功能都适合本 kernel。之后仍固定 Thor，只轮换对照架构或分析的 Thor 特性。

工程选择 CUDA Toolkit 13.0+ 和 PTX 9.0 作为配置基线，不宣称本机已验证与某个 JetPack/L4T/驱动版本兼容。待复核官方入口：[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/)、[Blackwell Tuning Guide](https://docs.nvidia.com/cuda/blackwell-tuning-guide/index.html)、[Nsight Compute CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)、[Profiling Guide](https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html)。本轮 web 读取均报连接失败，先前 curl 报 DNS 失败，未取得正文。
