# 2026-09-18 PTX / CUTLASS：token 池化的搬运、同步与最终优化

## 工业场景

双相机视觉编码器产生 FP32 `[B,T,K]=[2,197,67]` token，每 8 个 token 按通道求均值，输出 `[2,25,67]`。最后一组仅 5 个 token，分母为 5。连续分组是教学下采样策略，不宣称可以直接替换模型层；输入由确定性公式生成，无需模型或数据下载。

**唯一目标设备：Jetson Thor，SM110（`sm_110`），所有变体、PTX、SASS 和采集均固定此目标。**

具体问题：每个元素只参与一次求和时，是否有必要先将 token 搬入 shared memory？本工程交付完整的三条路径，**默认最终实现为 `pool_direct`**，收益尚未实测：

| 参数 | kernel | 实现与作用 |
| --- | --- | --- |
| `--variant baseline` | `pool<false>` | 普通 global load → shared store → CTA barrier，正确性/性能基线 |
| `--variant async` | `pool<true>` | 16 字节 `cp.async`、尾部补零、每线程 wait 与 CTA barrier，中间优化版本 |
| 默认或 `--variant optimized` | `pool_direct` | 一个 warp 拥有一组输出，合并读取通道，以独立累加器直接求和，省去 shared tile 和 CTA 屏障 |
| `--variant all` | 上述三者 | 相同输入、分组语义、容差与计时边界的完整对照 |

输入 stride 向上取整到 4 个 float，K=67 时 stride=68，padding 写 NaN。支持 B=1..8、T=1..4096、K=1..128，输入输出不别名。部署以目标设备实测 p95 和业务预算为准，不承诺未经验证的延迟或提速百分比。

## 概念回顾

异步搬运的主机制是把全局内存中的有效字节复制到共享内存，并定义目的区剩余字节。中间版本每个线程提交一次十六字节搬运，通道尾部只读取有效部分，越过逻辑行或通道时有效长度为零。不能简单跳过越界线程，否则共享内存可能保留旧值。输入行距与目的地址都满足对齐契约，源长度为零仍使用合法基址，避免在构造地址时越界。

与之耦合的是结果所有权和可见性。提交组与等待只约束当前线程的异步复制；当消费者跨生产者 warp 读取八行时，仍需要所有线程完成等待并经过线程块屏障。编译器的内存约束不等于设备执行的等待，消费者分支也不能让其他线程提前绕过屏障。立即等待没有建立计算与复制重叠，因此更换搬运指令不自动带来性能收益。

最终优化重新审视数据复用：每个输入只贡献一个输出，没有必要让生产者和消费者分别持有同一数据。一个 warp 负责一组输出，相邻线程读取连续通道，每个线程最多维护四条独立累加链，按原来的 token 顺序求和。中间值归当前线程所有，便能合法消除共享缓冲和跨线程同步，而非在原有跨线程算法中强行删除屏障。尾部通过逻辑长度保护，填充毒值不被读取，输出形状与均值分母保持不变。

这种改动减少了代码中明确存在的共享读写与同步，但也把每块线程数降到一个 warp，可能受驻留块数量限制。寄存器压力、加载依赖、指令调度与数据规模仍需实测。应先检查数值和输出所有权，再用机器指令与计数器判断热点，最后脱离分析器测延迟；不能用主机参考结果证明设备并发正确，也不能把新架构指令当成必然更快的标签。

## 知识图谱

| 连接 | 基线 / 异步阶段 | 最终优化阶段 | 不可混淆项 |
| --- | --- | --- | --- |
| 逻辑长度 → 地址范围 | stride 与 src-size 分离，无效 shared 元素补零 | 每个读取由 row/channel 范围保护，不读取 padding | 物理 padding 不是输入特征 |
| 所有权 → 同步 | 八个 warp 搬入八行，消费者跨 warp 读取，必须 CTA barrier | `lane + slot*32` 唯一拥有输出，只有线程私有中间值 | 改变所有权后消除同步，与直接删原算法屏障不同 |
| 搬运 → 机器码 | 普通 load/store；或 `cp.async`、commit、wait | global load、累加、最终 store；具体 SASS 待导出 | PTX 虚拟 ISA 不等于最终机器码 |
| 指令 → 性能证据 | 分析搬运和 barrier 是否限制调度 | 检查加载依赖、累加链、资源及驻留块限制 | stall 所在消费者 PC 不一定是根因 |
| 平台 → 验证 | 在 Thor SM110 上执行异步路径 | 直接路径不依赖 cp.async，同样固定编译为 SM110 | CPU 检查无法验证 CUDA 内存模型；Mac 容器不能提供缺失的 NVIDIA GPU |

代码目标固定 Thor SM110；对照 Ampere/Hopper 等架构解释指令演进与适用性，见 [OPTIMIZATION.md](OPTIMIZATION.md)。网络失败，架构资料的官方正文仍待复核。

## 编码练习

**一个 25 分钟任务：在保持 `[2,197,67] → [2,25,67]` 语义不变的前提下，从 shared staging 改成 warp 独占输出的直接累加。** 工程提供完整的最终实现作对照，不是未完成占位符。

1. 约 5 分钟：阅读两个 staging kernel，标出生产者与消费者、必要的 wait/barrier、每元素参与求和的次数。
2. 约 12 分钟：沿 `pool_direct` / `direct_lane` 重建“一个 warp 对应一个输出组，lane 加 slot×32 对应通道”的实现；保证每个输出恰有一个写者，尾块分母不变。注意为什么需要同时改变线程映射与存储方案才能消除屏障。
3. 约 8 分钟：运行 CPU 检查；有 GPU 时运行 `--variant all`、`--sweep` 和三个 `--profile` 变体，比较同一数学任务的正确性与延迟。分析为何一个 warp/block 可能限制并行度，记录优化未获益时的部署选择。

本任务替换原先“8-token 改成 4-token”的练习；不再通过改变池化语义比较性能。GPU 无法运行时，完成代码与主机检查，设备验收明确待完成。

## 文件说明

- [src/ptx_pool.cu](src/ptx_pool.cu)：三种真实 CUDA kernel、RAII、正确性/基准、专用 profile 入口。
- [src/direct_pool.hpp](src/direct_pool.hpp)：最终优化的 host/device 同源索引与累加代码；CPU 检查执行这份实际逻辑。
- [src/pooling.hpp](src/pooling.hpp)：独立标量 oracle、Shape 与输入生成；[src/options.hpp](src/options.hpp)：默认最终版与 CLI 分派。
- [src/cpu_check.cpp](src/cpu_check.cpp)：640 Shape、输出覆盖/唯一写者、NaN padding、非法 Shape 和模式选择检查。
- [src/pool_direct.ptx](src/pool_direct.ptx)：**手写**完整 PTX 等价算法；非 nvcc 输出，本机未汇编/执行。
- [profile.sh](profile.sh)：查询 ncu 能力，采集单 kernel，生成报告/文本摘要。
- [export-isa.sh](export-isa.sh)：导出已构建二进制的 PTX/SASS、另行生成 PTX/汇编手写 PTX，记录版本/参数/哈希。
- [OPTIMIZATION.md](OPTIMIZATION.md)：优化证据链、ncu 解读、耗时指令/依赖分析与架构差异。
- CMakeLists.txt、run.sh：CPU / sanitizer / GPU 构建和参数转发；build/ 全部被忽略。

来源读取尝试日期：2026-09-18。优先尝试 [NVIDIA/CUTLASS](https://github.com/NVIDIA/cutlass) tag `v3.5.1` 的 [include/cutlass/arch/memory_sm80.h](https://github.com/NVIDIA/cutlass/blob/v3.5.1/include/cutlass/arch/memory_sm80.h)，拟研究 GEMM shared tile 搬运中的 `cp_async` / `cp_async_zfill`；这些是待检索符号，未实际读到实现。GitHub/raw 请求失败，替代 [PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/)、ncu 与架构 tuning guide 也连接失败。

本工程是**独立教学实现**，没有复制或声称改编 CUTLASS 源码；保留对齐、有效字节、完成/会合分离与输出所有权，省略 GEMM、多阶段流水线、swizzle、MMA 和完整库依赖。源码实际阅读仍未完成，失败 URL/原因见 [verification.md](results/verification.md)。

## 编译与运行

Mac 辅助验证：

```sh
./systems_practice/2026-09-18/run.sh cpu
./systems_practice/2026-09-18/run.sh sanitize
```

GPU 环境固定为 **Jetson Thor / SM110**，使用与 Thor 软件栈匹配的 CUDA 驱动和 host compiler。本工程选择 CUDA Toolkit 13.0+、PTX 9.0、CMake ≥3.18 与 C++17；这是工程配置基线，精确 JetPack/L4T/驱动组合须在板端记录并核实。本机尚未验证该工具链组合。CMake 拒绝非 110 架构，设备编译与运行时再次检查目标，不默认为 `sm_110a`。无新增依赖安装。
```sh
# 默认运行最终优化版；参数可直接转发给程序。
./systems_practice/2026-09-18/run.sh gpu
./systems_practice/2026-09-18/build/gpu/ptx_pool --variant all
./systems_practice/2026-09-18/build/gpu/ptx_pool --sweep

# 独立采集入口，不依赖固定 launch-skip 数字。
./systems_practice/2026-09-18/profile.sh baseline basic
./systems_practice/2026-09-18/profile.sh async basic
./systems_practice/2026-09-18/profile.sh optimized detail
./systems_practice/2026-09-18/export-isa.sh sm_110
```

目标配置明确为 `-DCMAKE_CUDA_ARCHITECTURES=110`。运行脚本会覆盖旧构建缓存中的架构参数；导出脚本先按 SM110 重新配置/构建，再提取实际二进制的 PTX/SASS。其他 GPU 只作理论对照，不生成对应目标代码。记录 Thor 型号、JetPack/L4T、CUDA/driver、ncu 版本及频率/功耗模式。

## 正确性验证

CPU 实测覆盖 B=2、K=1..128、T∈{1,7,8,9,197} 共 640 Shape。staging 顺序模型与**最终 direct 的实际同源代码**分别对照独立 oracle；输入 padding 为 NaN，输出初始化为 NaN 以暴露漏写，并检查每个输出只有一个 lane 拥有。三种非法 Shape 被拒绝；默认最终版、三变体对照、单变体 profile、sweep 和非法模式均检查。

GPU 默认检查 7 个 Shape；`--variant all` 每个 Shape 检查三变体；`--sweep` 扩展为 640 Shape×3，包含 0/4/8/12/16 有效字节及各种行尾。要求结果有限、最大绝对误差 ≤1e-6。默认输入为有限 FP32，NaN/Inf 仅用于无效 padding，不额外承诺特殊数值语义。

```sh
compute-sanitizer --tool memcheck systems_practice/2026-09-18/build/gpu/ptx_pool --sweep
compute-sanitizer --tool racecheck systems_practice/2026-09-18/build/gpu/ptx_pool --variant all
compute-sanitizer --tool synccheck systems_practice/2026-09-18/build/gpu/ptx_pool --variant all
```

设备命令本次未运行；CPU 无法验证 PTX 语法和 GPU 同步。手写 PTX 仅作为独立阅读/汇编输入，当前主程序不加载它；汇编成功也不等于该 PTX 已执行验证。

## 性能分析

完整操作与指令解读见 [OPTIMIZATION.md](OPTIMIZATION.md)。最终 direct 的显式 shared tile 从每块 4096 字节变成 0，线程数从 256 变成 32，块数仍为 50；这是**源代码资源/映射分析，不是实测性能**。实际寄存器、spill、occupancy 和指令数量必须查看编译输出与 ncu。

每个版本 GPU kernel 先预热 20 次，再用 CUDA event 采样 100 次；另对 pageable H2D + kernel + D2H + stream wait 做 20 次链路预热和 100 次主机计时。报告最近秩 p50/p95；不含初始化、分配、CPU 验证，也不包括相机与完整推理服务。事件区间可能含主机提交间隙，不是单条指令延迟。

profile 模式同样先检查和预热，再用 `cudaProfilerStart/Stop` 包住一个 kernel，采集后仍校验输出。脚本使用 `--profile-from-start off`、名称过滤、`--launch-count 1`，不依赖调用次数。ncu replay/cache 控制会扰动实验，正式收益必须用无 profiler 的基准复测至少 3 轮；记录 GPU/SM、驱动/Toolkit、频率/功耗模式、温度和负载。

CPU 仅报告正确性，NPU 不参与；GPU/端到端延迟和功耗本次均无实测值。允许最终候选比基线慢，届时保留数据并选择满足业务预算的实现。

## 实际运行结果

当前 Mac Darwin arm64，AppleClang 21.0.0，CMake 4.4.3：

| 项目 | 结果 | 证据 |
| --- | --- | --- |
| 新增最终逻辑 CPU Release | 编译运行通过；640 Shape、覆盖/唯一写者与 CLI 检查通过 | [cpu-optimized.txt](results/cpu-optimized.txt) |
| 新增最终逻辑 ASan/UBSan | 同一检查通过 | [sanitize-optimized.txt](results/sanitize-optimized.txt) |
| GPU 三变体构建 | 缺 nvcc，配置失败；编译/运行/精度未验证 | [gpu-optimized.txt](results/gpu-optimized.txt) |
| ncu 脚本实际调用 | exit 127，缺 ncu，未采集报告 | [ncu-optimized.txt](results/ncu-optimized.txt) |
| ISA 导出脚本实际调用 | exit 127，缺 nvcc，未生成编译器 PTX/SASS | [isa-optimized.txt](results/isa-optimized.txt) |
| 手写 PTX | 已提供源码，未汇编/执行 | [pool_direct.ptx](src/pool_direct.ptx) |
| 格式化 / Shell 语法 / 差异检查 | 通过 | [audit-optimized.txt](results/audit-optimized.txt) |

旧日志保留，新验证不覆盖旧结果。CTest 总时间不是性能数据。没有安装依赖、下载模型或生成假的设备证据。

## 工程注意事项

直接路径每个输出只有一个写者，每个中间结果归同一线程拥有，因而不需要 shared 同步。这个证明不适用于 staging 变体：它们仍须保持完整的 wait 和 CTA barrier。`direct_lane` 的四个累加器希望提供独立计算链，但是否寄存器化和调度重叠应以真实 SASS 为准。

K=67 时每行只有 16 字节对齐，不保证每行按 128 字节 cache line 对齐；“相邻 lane 访问连续”也不等于“每次正好一个事务”。查 ncu 的实际事务与缓存行为后，再决定是否更改 stride；额外 packing 必须计入端到端。

资源使用 RAII，所有 CUDA API 检查返回值，析构失败报告且不抛异常。清理错误视为验收失败。profile 报告/二进制/汇编缓存仅放 build/；可提交适量真实文本摘要，但不得提交 `.ncu-rep`、cubin、模型或缓存。

## 工业故障与面试追问

以下为设计约束对应的排障场景，未在本机 GPU 复现；工具诊断文字依目标版本变化。

| 触发条件 | 现象 | 根因 | 最小诊断 | 修复 / 取舍 |
| --- | --- | --- | --- | --- |
| 尾通道按完整 16 字节视为有效 | NaN/数值错误 | 逻辑 K 与物理 stride 混淆 | padding 毒值、oracle、memcheck | staging 正确 src-size；direct 正确通道保护 |
| staging 中保留 wait 却删除 CTA barrier | 随机误差 / shared hazard | 本线程完成不代表其他 warp 已就绪 | racecheck、源/SASS 与依赖分析 | 恢复屏障；只有改为独占输出后才能移除跨线程依赖 |
| direct 改为一个 warp 却让多个 lane 写同一通道 | 漏写或竞争 | 输出映射不是一一覆盖 | NaN 输出、owners 计数、memcheck 与结果校验 | 保持 `lane+slot*32` 的唯一所有权 |
| direct 的 kernel p95 反而变差 | 资源变少但没有收益 | 可能驻留块限制、依赖链或工作量太小；未实测不能定因 | Occupancy/SchedulerStats、实际 SASS、无 profiler 对照 | 根据证据调整映射；必要时部署基线 |

面试追问（基础 → 实现 → 边界 → 权衡）：

1. src-size 与 stride 各约束什么，为什么 NaN padding 能揭露部分错误？
2. wait_group 与 CTA barrier 分别保证谁的完成和可见性？
3. 为什么改变输出所有权后能省掉 shared 和屏障，而在旧算法中直接删屏障不行？
4. lane+slot×32 怎样覆盖 K=1/67/128，每个输出为什么恰有一个写者？
5. SourceCounters 把停顿标在累加指令上时，如何区分算术依赖和前序访存等待？
6. 为什么一个 warp/block 与更少 shared 并不保证更高 occupancy 或更低延迟，哪些新架构指令不适合此 kernel？

## 自测问题

若 GPU 实测发现 `pool_direct` 的 shared 与 barrier 指令消失，但 p95 仍高于 `pool<true>`，你会如何利用同一输入上的 ncu 资源/调度指标、真实 SASS 依赖链与不附加 profiler 的重复测量，区分驻留块限制、加载等待和测量干扰，并决定最终部署哪个版本？
