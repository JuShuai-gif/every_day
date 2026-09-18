# 2026-09-18 PTX / CUTLASS：token 池化的异步搬运与线程块可见性

## 工业场景

双相机视觉编码器向机器人动作头提供 FP32 `[B,T,K]=[2,197,67]` token。每 8 个相邻 token 按通道求均值，得到 `[2,25,67]`；最后一组只除以 5。这里的连续分组是教学用下采样策略，不宣称能直接替换真实模型的语义聚合层。输入由确定性公式生成，无需模型或下载数据。

设计问题：怎样让 16 字节 `cp.async` 搬运同时支持通道尾部和 token 尾部，并让其他 warp 安全消费 shared tile？物理行距向上取整到 4 个 float，K=67 时 stride=68，填充区写 NaN。每个 CTA 256 线程，8 个 warp 分别搬入 8 行，每线程负责 4 个 float；消费阶段仅前 K 个线程各自累加 8 行，明确跨 warp 读取。

约束：B=1..8、T=1..4096、K=1..128；每块 shared tile 固定 4 KiB，输入和输出互不别名，单 stream 串行。部署目标是满足业务实测 p95 延迟预算；本练习不设未经硬件验证的毫秒承诺，不宣称异步版本必然更快。

## 概念回顾

异步搬运的主机制是把全局内存中的有效字节复制到共享内存，并在同一次操作中定义目的区剩余字节。本练习每个线程提交一次十六字节搬运：通道充足时读取四个浮点数，尾部不足时只读取有效部分，越过逻辑行或通道时有效长度为零。不能简单跳过越界线程的指令，否则共享内存可能残留未初始化值。源行距按四个浮点数对齐，目的区显式十六字节对齐；布局约束与补零语义必须同时成立。源长度为零仍传入合法对齐基址，避免在地址计算阶段构造越界指针。

与之耦合的是异步完成和线程间可见性。提交组把当前线程之前发出的复制归入一组，等待零个未完成组让当前线程的复制结束；它不是整个线程块的会合点。池化消费者会读取另外七个生产者 warp 搬入的行，因此所有线程完成自己的等待之后，还必须经过线程块屏障。消费者分支放在屏障之后，不能让没有输出任务的线程提前返回。编译器屏障也不能代替设备执行的等待或线程块同步。

这版只有一个共享缓冲区，立即等待后计算，不包含多阶段流水线，也没有计算与复制重叠的保证。同步版本采用普通读取和共享写入，提供相同布局及数学结果的对照。对小规模池化，发射开销、空闲消费者和内存带宽都可能抵消复制路径的收益。判断优化必须同时检查精度、设备事件区间和含传输的端到端延迟；主机参考程序只能验证索引、补零与均值定义，不能证明异步指令或跨线程可见性正确。

## 知识图谱

| 层次 | 主机制：尾部搬运 | 耦合机制：完成与共享可见性 | 前置条件 / 不可混淆项 |
| --- | --- | --- | --- |
| 数据契约 | 逻辑 K 与物理 stride 分离；有效长度为 0/4/8/12/16 字节 | 未参与均值的 token 必须补零，分母使用有效 token 数 | 物理 padding 不是模型输入；NaN 用于揭示误读 |
| CUDA / PTX | `copy_async_16` 转换 shared 地址，执行 `cp.async.cg.shared.global` | 每线程 `commit_group` → `wait_group 0` → 全块 `__syncthreads` | `.cg` 此处使用 16 字节；generic 指针不等于 shared 空间地址 |
| GPU 硬件 | warp 协同搬入按行连续的数据 | 前四个 warp 的部分线程读取全部八行 | block 内同步不涉及其他 block；不能把等待当成 CTA 屏障 |
| 编译与主机 | CUDA C++17 编译为 PTX/机器指令，目标 SM80+ | 同一 stream 排序 H2D、kernel、D2H；主机等待后检查结果 | inline asm 的 `memory` clobber 约束编译器，不是 GPU 完成证明 |
| 平台边界 | Mac arm64 运行 C++ 索引参考 | Linux NVIDIA GPU 上验证真正的异步路径 | C++17 没有 CUDA 地址空间保证；无 CUDA GPU 的 Mac 容器不能执行此路径 |

本表与目标代码是独立编写的待目标验证实现。本次网络未能读取源码与 PTX 官方正文；不可把这些设计说明视为本次已完成官方逐条复核。

## 编码练习

**一个 25 分钟任务：把每组 8 个 token 的池化改成每组 4 个 token，并保持同步与异步路径的尾部契约。** 当前文件提供完整可运行的 8-token 基线，不需要填写占位符。

1. 约 5 分钟：阅读 `pooling.hpp` 和 `pool<Async>`，定位 Shape、每行 32 个搬运线程、shared 容量、有效字节以及屏障的位置。
2. 约 12 分钟：调整分组大小及依赖它的生产者循环/launch 线程数，让每块仅搬入 4 行。CPU 与 CUDA 使用相同的分组定义；不要只改分母，也不要让多余 warp 写出 shared tile。
3. 约 8 分钟：把 T=3/4/5 加入本练习的边界集合，执行已有检查；有 GPU 时比较修改前后的数值、块数、shared 容量及两种加载路径的延迟。形状为 `[2,197,67]` 时输出应为 `[2,50,67]`，最后一组只有 1 个 token。

Mac 当天可以完成辅助检查；完整的 PTX 验收必须在目标设备完成。比较分组大小时输出语义已改变，不能把延迟差直接归因于 `cp.async`；同一分组大小内才比较同步/异步版本。

## 文件说明

- `src/ptx_pool.cu`：真实 PTX 搬运、同步对照、CUDA RAII、数值检查、GPU 事件与主机端到端计时。
- `src/pooling.hpp`：Shape/stride 契约、确定性带毒值输入、紧凑逻辑参考与误差检查。
- `src/cpu_check.cpp`：共享 tile 的顺序索引模型；检查所有 K 尾数与补零区域。
- `CMakeLists.txt`、`run.sh`：C++17 CPU / sanitizer / CUDA 构建；缓存仅在忽略的 `build/`。
- `results/verification.md`：实际验证与来源读取失败记录；其他 `.txt` 是原始运行日志。

来源记录（读取尝试日期：2026-09-18）：

| 类别 | 仓库 / 版本 / 具体位置 | 原场景与本次关系 | 状态 |
| --- | --- | --- | --- |
| 优先开源源码 | [NVIDIA/CUTLASS](https://github.com/NVIDIA/cutlass)，tag `v3.5.1`；候选文件 [include/cutlass/arch/memory_sm80.h](https://github.com/NVIDIA/cutlass/blob/v3.5.1/include/cutlass/arch/memory_sm80.h)；拟查找 `cp_async` / `cp_async_zfill` 封装 | 拟研究 GEMM shared tile 的异步搬运；函数名是待核实检索目标，不是本次读到的源码符号 | GitHub 页面与 raw 文件均未成功取得；没有实际阅读该实现，不声称改编或受已读 CUTLASS 源码启发 |
| 替代一手资料 | NVIDIA [PTX ISA：cp.async](https://docs.nvidia.com/cuda/parallel-thread-execution/#data-movement-and-conversion-instructions-cp-async) | 拟核对 src-size、地址对齐、完成与可见性规则 | web 连接失败，curl DNS 失败；未读取正文，目标设备验收前仍需核对 |
| 本次原创 | `pool<Async>`、`copy_async_16` 与 CPU 参考 | 独立教学实现，保留尾部长度、补零与完成/会合分离；省略 GEMM MMA、多阶段流水线、双缓冲、布局 swizzle 与完整 CUTLASS 依赖 | 已验证 CPU 契约；PTX/设备路径未验证，无第三方源码复制 |

因此这次是 **PTX 主题练习**，不是 CUTLASS API 示例，也没有构建或验证 CUTLASS 库。网络失败使“实际阅读开源源码”这一目标未完成；详细尝试 URL 和原始失败摘要见验证记录。

## 编译与运行

在仓库根目录执行。无需安装新依赖即可使用已存在的本机 CMake/AppleClang：

```sh
./systems_practice/2026-09-18/run.sh cpu
./systems_practice/2026-09-18/run.sh sanitize
```

目标设备要求：Linux NVIDIA GPU、计算能力至少 8.0、支持目标设备的 CUDA Toolkit 与驱动、CMake ≥3.18、兼容的 C++17 host compiler。代码采用 SM80 引入的指令，教学构建默认生成架构 80；建议已有 CUDA 12.x 或更新的兼容工具链。不能仅凭“Jetson”名称推断兼容，按具体设备与 Toolkit 支持列表设置架构；不使用 CUTLASS 安装包。

```sh
# 使用目标设备已经安装且兼容的 CUDA 工具链。
nvidia-smi
nvcc --version
./systems_practice/2026-09-18/run.sh gpu

# 若实际设备需要其他架构，在相同 build 目录显式配置后重新构建。
# 以下 80 是示例参数，不能当成所有设备的实际架构。
cmake -S systems_practice/2026-09-18 -B systems_practice/2026-09-18/build/gpu \
  -DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=80 -DCMAKE_BUILD_TYPE=Release
cmake --build systems_practice/2026-09-18/build/gpu -j 2
systems_practice/2026-09-18/build/gpu/ptx_pool
```

Jetson 环境可能没有 `nvidia-smi`，此时记录 JetPack/L4T、设备型号、`nvcc --version` 和程序输出的计算能力、runtime/driver 版本。脚本不会自动安装任何组件。

## 正确性验证

CPU 实测：B=2，K=1..128，T∈{1,7,8,9,197}，共 640 组；显式检查 shared 模型中所有无效元素为零，输入 stride padding 为 NaN。非法 B=0、T=0、K=129 必须拒绝。输出要求有限且最大绝对误差 ≤1e-6。

GPU 程序提供 7 组 Shape，同步与异步路径分别比对同一 CPU oracle，覆盖 1/2/3 个 float 的尾部和完整 16 字节、越过行/通道的零长度复制、完整 tile 与 token 尾块。主测 `[2,197,67]`；循环基准后继续检查输出。正式设备验收还需要下列检查全部完成：

```sh
compute-sanitizer --tool memcheck systems_practice/2026-09-18/build/gpu/ptx_pool
compute-sanitizer --tool racecheck systems_practice/2026-09-18/build/gpu/ptx_pool
compute-sanitizer --tool synccheck systems_practice/2026-09-18/build/gpu/ptx_pool
```

这些命令本次均未执行。Sanitizer 的覆盖能力随 CUDA 版本变化，工具通过也不能替代内存模型分析；应保留版本、完整输出与 `PASS` 行。CPU 顺序模型无法发现缺失 GPU 屏障。

## 性能分析

新增 [优化路径、ncu 操作、PTX/SASS 与架构对照](OPTIMIZATION.md)：明确 `pool<false>` 基线与 `pool<true>` 最终优化候选，说明采集与指令分析步骤。候选收益尚未在 GPU 验证。

GPU 事件计时：先 20 次 kernel 预热，随后 100 次独立样本，每次 event 包围单次 launch，并等待结束 event。报告最近秩 p50/p95，区间不含 H2D/D2H；微小 kernel 的 event 区间可能含 GPU 等待主机提交间隙，不能当成单条 PTX 指令延迟。

主机端到端计时：另做 20 次完整链路预热和 100 次采样，`steady_clock` 覆盖 pageable host H2D + kernel + D2H + stream 等待；不含初始化、内存分配和 CPU 精度检查。不等同于完整模型、相机采集到控制动作延迟。CPU 本次仅做正确性检查，不报告微基准；NPU 不参与此练习。

```sh
nsys profile --trace=cuda,nvtx --force-overwrite=true \
  -o systems_practice/2026-09-18/build/gpu/pool-trace \
  systems_practice/2026-09-18/build/gpu/ptx_pool
ncu --set basic --target-processes all \
  --log-file systems_practice/2026-09-18/results/ncu-target.txt \
  systems_practice/2026-09-18/build/gpu/ptx_pool
cuobjdump --dump-ptx systems_practice/2026-09-18/build/gpu/ptx_pool \
  > systems_practice/2026-09-18/results/ptx-target.txt
```

查看 PTX 中异步复制、提交和等待是否存在；PTX 不是最终机器码，需要时补充 `cuobjdump --dump-sass`。Profiler 运行会扰动延迟，正式 p50/p95 使用未附加 profiler 的输出，至少重复 3 轮并记录 GPU 型号、驱动、Toolkit、频率/功耗模式、温度和负载。

固定 8-token 时，每块 shared 4096 字节、50 块，这些是布局计算值而非性能实测。记录两种路径 kernel p50/p95、端到端 p50/p95、正确性误差和 sanitizer 结果；仅在真实业务预算满足且优化差异稳定时考虑部署。功耗和实际 occupancy 本次未测。这里立即等待且读取量很小，异步版本慢于同步版本是合法结果。

## 实际运行结果

2026-09-18，Mac Darwin arm64，AppleClang 21.0.0，CMake 4.4.3：

| 项目 | 实际状态 | 证据 |
| --- | --- | --- |
| CPU Release | 配置、编译、640 组契约与 3 组非法输入通过 | [cpu.txt](results/cpu.txt) |
| CPU ASan/UBSan | 配置、编译、同一检查通过 | [sanitize.txt](results/sanitize.txt) |
| CUDA 配置 | 失败：`Failed to find nvcc.` | [gpu-configure.txt](results/gpu-configure.txt) |
| GPU 编译 / 执行 / 精度 / 同步与内存检查 | 未验证：无 nvcc 和 NVIDIA GPU | [verification.md](results/verification.md) |
| GPU kernel / 主机 E2E / 功耗 | 未验证，无性能实测数据 | 没有用 CPU 测试耗时代替 GPU 指标 |
| 仓库格式化 | `scripts/format-cpp.sh` 成功 | [format.txt](results/format.txt)，成功无输出 |

CTest 总耗时属于测试运行时间，不是池化性能。未下载源码/模型，未安装依赖。

## 工程注意事项

源 stride 必须是 4 个 float 的倍数，源分配由 `cudaMalloc` 提供对齐，列偏移是 4 的倍数。不要直接接入未知 stride 的 tensor view；扩展接口前应验证布局或者显式 packing，并把 packing 计入端到端预算。

每线程的目的 16 字节范围不重叠；所有线程都执行等待和块屏障，消费者不覆盖 shared tile。只有一轮搬运，不涉及循环复用；未来增加循环和双缓冲时必须重新建立“最后一次消费结束后才覆盖”的证明。

资源用 RAII 管理，所有 CUDA API 检查状态，析构检查并报告失败且不抛异常。发生异步错误时在 stream/event 同步点归因；不得忽略同步结果来换取更好看的延迟。若日志出现 `cleanup` 错误也视为验收失败。

`src-size` 的补零规则、目标指令支持和具体开源封装仍需联网逐条复核；本次独立实现未声称经过源码审计。所有构建缓存、二进制和 trace 位于忽略的 `build/`，日志留在 `results/`，不得提交设备产物。

## 工业故障与面试追问

以下是依据本实现约束列出的排障场景，**不是本次在 GPU 上复现的故障**。适用范围为支持该 PTX 路径的 SM80+ 和匹配 CUDA 工具链，实际诊断文本依版本而异。

| 触发条件 | 可观察信号 | 根因 | 最小诊断 | 修复 / 取舍 |
| --- | --- | --- | --- | --- |
| K=67，复制整段 16 字节并把物理 padding 当成有效数据 | NaN 传播或尾通道误差 | 混淆逻辑长度与 stride，未按 src-size 补零 | NaN padding + CPU oracle + memcheck | 保留有效字节与对齐 stride 两个独立契约 |
| 移除 wait 或 CTA barrier，跨 warp 消费 | 随机精度异常或 shared hazard | 单线程异步完成与其他线程会合不是同一条件 | racecheck、反复变更 Shape 与运行负载，检查实际指令 | 恢复每线程等待及全块屏障；不以“偶尔通过”验收 |
| 只把 token 分组从 8 改成 4，仍启动 256 个生产者 | shared 越界或不稳定结果 | tile 容量与生产者数量未共同更新 | memcheck + 逐线程地址范围推导 | 同时调整生产者数量和 tile 契约，保持全块参与屏障 |
| 未固定目标/驱动组合，或在旧 GPU 上运行 | 编译错误、架构不支持或模块加载失败 | PTX/CUDA 工具链及硬件能力不匹配 | 保存 nvcc、driver、runtime、实际架构与原始错误 | 使用支持目标设备的工具链与架构，不静默把同步回退标作异步 |

面试追问（基础 → 实现 → 边界 → 权衡）：

1. 为什么逻辑通道长度、物理行距、复制字节数必须分别表示？
2. generic pointer 到 shared 地址的转换解决了什么问题，直接转为 32 位整数为何不充分？
3. `commit_group`、`wait_group 0` 和 `__syncthreads` 分别约束谁，为什么消费者布局影响所需同步？
4. 一个 warp 没有有效输入时，仍需参与哪些操作，才能让整个 CTA 的控制流安全？
5. 若把 K 扩大到 129，当前 tile 组织和线程映射有哪些地方必须重新设计？
6. 怎样证明比较中的收益来自复制路径，而不是输出分组变化、缓存预热或 profiler 干扰？

## 自测问题

同事在 SM80+ 上将 `wait_group 0` 保留，却把 `__syncthreads` 改成每个 warp 自己的 `__syncwarp`，理由是“每行由一个 warp 搬运，而且 CPU 的 640 组检查全通过”；对于当前按通道跨行消费的实现，这个论证是否充分，你会如何构造可证伪的 GPU 验证并划定 CPU 检查能证明的范围？
