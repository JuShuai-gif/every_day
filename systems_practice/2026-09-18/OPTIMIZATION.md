# 本次 kernel 的优化路径、ncu 与指令分析

这是 2026-09-18 练习的补充说明，不增加第二个编码练习或自测。现有目标代码中 `pool<false>` 是同步加载基线，`pool<true>` 是完整的异步搬运优化候选；程序对同一 Shape 顺序运行并检查两者，保留基线用于验收。最终候选为 `pool<true>`，但没有 NVIDIA GPU 实测，不能断言它比基线快或应在生产中默认启用。

## 优化思路与可证伪假设

1. 基线通过普通 global load 和 shared store 搬入 tile，之后执行 CTA 屏障。潜在成本是搬运指令与寄存器中转；编译器如何实际降低这些成本，需要查看生成的 SASS。
2. 优化候选将每线程的 4 个标量搬运变成一条 16 字节 `cp.async`，由 src-size 完成尾部补零。保持同一 `[2,197,67]` 数学输出、stride、误差标准和 CTA 屏障。预期收益是减少显式搬运/中转，而不是减少逻辑输入或输出。
3. 付出的成本是地址转换、有效长度计算、commit/wait，以及仍然存在的 shared tile 和同步。代码立即等待，**没有证明访存与计算重叠**。小 kernel 可能受启动成本和不足的并行工作量限制。
4. 验证路径是先精度/sanitizer，再查编译输出、寄存器数和指令构成，然后检查 ncu 中访存与调度证据，最后脱离 profiler 重跑延迟。若设备时间没有稳定改善，保留同步基线为部署选择；不能只因使用了新指令就宣布成功。

暂不把“双缓冲”“更大 tile”直接作为进一步优化结论：必须先看到存在可隐藏的延迟，并评估 shared/register 增长与 occupancy 的代价。对纯池化也可研究消除 shared 的直接加载路径，但它不是本次已交付或已验证的版本。

## 如何使用 ncu 回答这个问题

以下命令在 Linux NVIDIA 目标设备运行；本机没有 ncu/nvcc，命令尚未执行。每个版本的 section/metric 可用性以本机查询为准，先保存工具版本：

```sh
ncu --version
ncu --list-sections
ncu --query-metrics
nvcc --version
```

先完成 README 的 GPU 构建和正确性验收。CMake 已加 `-lineinfo`，用于源码关联；不要为性能分析改用 `-G`。当前程序每个变体在主测前有 6 个边界 launch、1 个主测正确性 launch、20 个预热 launch。因此以下 **按名称匹配后的 skip=27** 对准主测的第一个事件计时 launch；修改控制流后必须重新计算，不能照搬数字。

```sh
# 先以 basic 集合确认 kernel 名和 launch 选择，报告保存在忽略的 build/ 下。
ncu --kernel-name-base demangled --kernel-name 'regex:.*pool<false>.*' \
  --launch-skip 27 --launch-count 1 --set basic \
  -o systems_practice/2026-09-18/build/gpu/sync-basic \
  systems_practice/2026-09-18/build/gpu/ptx_pool

ncu --kernel-name-base demangled --kernel-name 'regex:.*pool<true>.*' \
  --launch-skip 27 --launch-count 1 --set basic \
  -o systems_practice/2026-09-18/build/gpu/async-basic \
  systems_practice/2026-09-18/build/gpu/ptx_pool
```

检查报告：主测 grid 应是 50 个 block，block 是 256 个线程。如果 demangled 模板名采用别的形式，根据实际报告调整过滤器；零匹配不是成功。可先去掉过滤器并使用 `--launch-count 2` 查看两个边界 kernel 的真实名称，不能拿它们的小 Shape 指标代替主测。

确认过滤正确后，对两个版本分别采集以下与问题相关的 sections。示例是异步版；同步版改过滤器及报告名，其他配置一致。只使用 `--list-sections` 中存在的 section，缺失项记录而不是假造指标。

```sh
ncu --kernel-name-base demangled --kernel-name 'regex:.*pool<true>.*' \
  --launch-skip 27 --launch-count 1 \
  --section SpeedOfLight --section LaunchStats --section Occupancy \
  --section MemoryWorkloadAnalysis --section SchedulerStats \
  --section WarpStateStats --section SourceCounters \
  -o systems_practice/2026-09-18/build/gpu/async-detail \
  systems_practice/2026-09-18/build/gpu/ptx_pool

ncu-ui systems_practice/2026-09-18/build/gpu/async-detail.ncu-rep
ncu --import systems_practice/2026-09-18/build/gpu/async-detail.ncu-rep \
  --page details > systems_practice/2026-09-18/results/ncu-async-details.txt
```

| 要回答的问题 | 先看什么 | 如何决定改动 |
| --- | --- | --- |
| 是否是访存瓶颈？ | SpeedOfLight、MemoryWorkloadAnalysis 的 DRAM/L2 吞吐及事务/请求关系 | 低有效带宽不必然说明带宽饱和；检查规模、事务利用率和依赖等待，再决定合并访问/减少数据量 |
| 异步路径是否减少中转代价？ | LaunchStats 的寄存器资源；Source 页实际 load/store/异步复制指令及执行计数（有该指标时） | 比较同一编译器和 SM 的输出；若寄存器或总指令增加，需要重新判断净收益 |
| shared/register 是否限制并行度？ | Occupancy 的限制因素，LaunchStats 的每块资源，实际 active warps | 高 occupancy 不是目标本身；只有足够的 ready warps 能帮助隐藏延迟 |
| 为什么 warp 没有发射？ | SchedulerStats 的 eligible/issued warps；WarpStateStats 的依赖等待、屏障等分类 | 将停顿连回生产者、消费者与同步位置；不可仅按最大 stall 百分比删除屏障 |
| 热点到底在哪段机器码？ | Source 页关联 CUDA、PTX、SASS；SourceCounters 中可用的行/PC 信息 | 找出读写和消费者依赖链；PC 采样仅在目标与工具支持时使用，短 kernel 样本不足须明确标记 |

ncu 可能 replay kernel、控制 cache 状态并增加开销，必须记录这些设置；一次采集不等同于稳定的吞吐/延迟结论。确认采样代表哪个 launch、输入和缓存状态，最终 p50/p95 使用不附加 ncu 的程序结果。若出现性能计数器权限错误，记录完整错误并由目标设备管理员按其策略处理，不把缺少指标视为没有瓶颈。

## PTX 与 SASS：提供什么、怎样读

下面是本次 `copy_async_16` 与 `pool<true>` 中实际手写 inline PTX 的指令模板（`%0` 等是 C++ asm 操作数占位符），不是完整 `.ptx` 文件，更不是反汇编结果：

```ptx
cp.async.cg.shared.global [%0], [%1], 16, %2;
cp.async.commit_group;
cp.async.wait_group 0;
```

`%0` 对应转换后的 shared 地址，`%1` 是 global 源地址，`%2` 是 0/4/8/12/16 的有效字节数。三条指令在 C++ 中是独立 asm 语句；其后有 `__syncthreads()`，不能省略。完整 CUDA 源码见 `src/ptx_pool.cu`。

在目标环境保留真实编译输出：

```sh
# sm_80 是本次候选目标；换架构时重新核对 Toolkit 与特性要求。
nvcc -std=c++17 -O3 -lineinfo -arch=sm_80 --ptx \
  systems_practice/2026-09-18/src/ptx_pool.cu \
  -o systems_practice/2026-09-18/results/kernel-sm80.ptx

cuobjdump --dump-ptx systems_practice/2026-09-18/build/gpu/ptx_pool \
  > systems_practice/2026-09-18/results/executable-ptx.txt
cuobjdump --dump-sass systems_practice/2026-09-18/build/gpu/ptx_pool \
  > systems_practice/2026-09-18/results/executable-sass.txt
```

独立 `nvcc --ptx` 命令生成的模块不必与 CMake 的所有优化选项完全相同；分析已测二进制时以该二进制导出的 SASS 和其完整构建命令为准。保存编译器版本、SM、源码版本和命令，在 ncu Source 页定位 `pool<false>` / `pool<true>`，将热点源行对应到实际指令地址。当前没有真实 SASS，因此不提供猜测出来的机器码助记符、地址或寄存器编号。

| 代码/指令段 | 潜在耗时原因 | 需要的证据；不能得出的结论 |
| --- | --- | --- |
| baseline 的 global 读取及其后续使用 | cache miss、访存事务浪费、load-use 依赖 | 结合内存与依赖等待信息；load 命中和 miss 的成本不同，不能给统一周期 |
| `cp.async` + `wait_group 0` | 搬运仍未完成，立即等待暴露访存延迟 | 区分发出复制与等待完成；热点在 wait 不代表 wait 本身做了大量计算 |
| `__syncthreads()` 对应的真实 SASS 同步段 | 不同 producer 到达时间不同 | 判断哪些 warp 迟到及原因；不能根据 stall 比例移除正确性屏障 |
| shared 读取后的 8 项求和 | shared 访问、累加依赖链、可用计算并行度 | 检查编译器实际展开/调度及 shared 冲突证据；不能仅凭源循环判断瓶颈 |
| `sum / count` 的编译输出 | 编译器可能产生倒数/乘法或其他指令序列 | 查看真实 SASS 与精度选项；不能把源代码 `/` 当成固定机器指令及固定开销 |

“高延迟指令”“低吞吐执行管线”“占总时间最多的代码段”“在消费者 PC 采样到停顿”是四个不同概念。没有设备数据，本表只能列待验证热点。

## 本次重点架构与后续轮换

本次重点是 **Ampere 路径**，对照 Turing 的加载与同步路径。下面列的是待官方文档复核的后续选题路线，**本轮网络失败，不能作为已核实的具体产品支持清单**；不提供未经核实的最低 Toolkit 版本、特殊后缀兼容性或指令周期。

| 架构方向 | 拟研究的新增/特色机制 | 与本 kernel 的关系及需要核对的边界 |
| --- | --- | --- |
| Volta / Turing | Tensor Core 的 warp 级矩阵执行；Turing 的 `ldmatrix` 等矩阵加载路径 | 池化不是 GEMM，不应为展示矩阵指令而改变算法；分别核对各代指令引入时间与支持 dtype |
| Ampere（本次） | `cp.async` 的 global → shared 搬运、分组完成与尾部补零 | 本候选直接使用；目标 SM80+ 仍需工具链、语法、数值与同步验收。后代沿用不代表它们独有 |
| Ada | FP8 Tensor Core 路径及相应矩阵指令能力 | 需要具体 SM、PTX、dtype 核对；本 FP32 求均值不直接利用 FP8，不强行量化 |
| Hopper | TMA / `cp.async.bulk.tensor`、`mbarrier`、`wgmma` | 描述符与同步成本可能不适合小 tile；分别核对通用 SM90 与架构专属目标要求，不统称“任意 SM90 都支持全部特性” |
| Blackwell | 适用目标的 `tcgen05`、Tensor Memory 与新矩阵执行机制 | 数据中心、桌面和 Jetson 的产品 SM 与指令能力分别核对；不可泛化为所有 Blackwell 均支持同一指令族 |

之后每次 GPU 练习选择不同重点架构，并与至少另一代对照；是否适合本次 kernel 比“指令更新”更重要。架构的特色指令不必是该代独占指令，应注明新引入、强化、沿用或受架构专属后缀约束。

待复核的一手资料入口：[PTX ISA](https://docs.nvidia.com/cuda/parallel-thread-execution/)、[Nsight Compute Profiling Guide](https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html)、[Nsight Compute CLI](https://docs.nvidia.com/nsight-compute/NsightComputeCli/index.html)。本轮 web 搜索报 `connection failed: error sending request`，curl 访问 Nsight Compute 官方站点报 `Could not resolve host: docs.nvidia.com`；以上链接是后续核对入口，不代表本次读到了正文。
