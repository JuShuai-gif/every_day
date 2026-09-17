# 2026-09-16 TensorRT：小 Batch 动态 Shape 与缓冲区契约

## 工业场景

双相机机器人将视觉编码器输出送入控制头：正常每轮处理两个视角，降级时一个，动作队列合并时最多四个。本练习用可直接构建的 `y = ReLU(0.5*x + 0.25)` 仿射激活头，复现真实推理服务的 Shape/缓冲区约束；它是最小工程模型，不代表完整 VLA 的任务能力或性能。无需 ONNX、模型权重下载或数据集。

| 项目 | 约定 |
| --- | --- |
| 输入 | `features`，连续 FP32 `[B,8]`，Batch `1≤B≤4`，行内八个特征 |
| 输出 | `actions`，连续 FP32 `[B,8]`，逐元素仿射后 ReLU |
| Profile | MIN `[1,8]`、OPT `[2,8]`、MAX `[4,8]` |
| 最小输入 | 程序生成 `x[i]=(((i+frame%17)%17)-8)/4`；正确性阶段逐帧变化，性能阶段固定 frame=0 |
| 边界 | B=1/4、ReLU 阈值/负值、负 Batch、B=0/5；拒绝超界后不入队 |
| 内存约束 | 输入/输出各 128 字节；设备 I/O 合计 256 字节，锁页 I/O 合计 256 字节，均为按 Shape 计算的容量，非实测显存；workspace 上限 16 MiB，不能解释为进程总显存上限 |
| 延迟约束 | 假设控制周期 4 ms，为此最小推理段设 E2E p95≤1 ms 的练习预算；这是待目标板验证的工程门槛，并非设备性能承诺 |
| 并发约束 | 单线程、一个 context、一个 stream；每轮完成同步后才允许重填输入或切换 Shape |

## 概念回顾

动态形状的核心是把允许范围、当前形状和实际缓冲区容量组成同一份运行时契约。构建引擎时，优化配置描述输入的最小、最优和最大形状，最优点帮助构建器选择执行策略，却不表示其余形状自动拥有相同延迟。运行时必须先选择配置，再设置本次输入形状，并查询输出形状，确认维度已经确定，才能把地址交给执行上下文。双相机场景中的批量通常为二，但断流降级或短队列合并会改变批量；只修改复制字节数而不更新上下文，可能产生错误输出或越界访问。为最大形状预分配容量可以避免每帧分配，但不能省略当前形状检查，也不能把容量误当作有效数据长度。异步入队返回时，设备可能仍在读取输入；主机复用锁页内存、释放设备缓冲区或修改上下文前，必须证明上一轮已经结束。本练习用同一条流和完成同步建立这一生命周期边界，再把重复形状配置从热路径移走。优化是否有效，需要同时观察主机提交开销、设备推理区间和包含传输的请求耗时，而不是仅看一次入队调用的返回速度。

## 编码练习

**唯一练习：为动态 Shape 请求路径增加安全的“同 Shape 复用”缓存（约 25 分钟）。** 已提供可构建运行的完整基线，无 TODO；在这份基线上进行一次小改动。

1. **5 分钟**：读 `src/trt_dynamic.cpp` 的 `infer` lambda，标出参数检查、Shape 设置、输出查询、传输、入队、同步六个位置，运行对应平台基线。
2. **12 分钟**：在该 lambda 所属调用实例内缓存上次成功配置的 Batch，仅在 Batch 变化时调用 `setInputShape` 和查询/验证输出 Shape。首次调用必须配置；非法 Batch 在访问 context 前拒绝；缓存只在配置和输出检查成功后更新。保持每轮有效字节数计算、正确性检查和同步不变，缓存不得成为跨 context 的全局状态。
3. **8 分钟**：保留 `[1,4,2,1,3,2]` 逐帧变值序列及非法输入检查，比较修改前后同一目标 GPU 上 B=2 的 p50/p95。Mac 上完成代码走读与 CPU 辅助检查，将优化版 GPU 结果记录为未验证，不能以 CPU 检查宣告 TensorRT 修改正确。

提交物就是本目录内修改的源码和新一轮 `results/` 日志；不要为练习自动提交 Git。当前归档数据对应**未加缓存的基线**。

## 文件说明

| 文件 | 用途 |
| --- | --- |
| `src/trt_dynamic.cpp` | 完整 TensorRT 网络构建、序列化、反序列化、动态 Shape 推理、CUDA RAII 和 GPU 基准 |
| `src/common.hpp`、`src/common.cpp` | Shape 契约、确定性输入、独立解析验算、CPU 参考和统计 |
| `src/cpu_check.cpp` | Mac 可执行的参考验算、尾部哨兵、非法 Batch/空指针检查 |
| `CMakeLists.txt`、`run.sh` | C++17 构建和 cpu/sanitize/gpu 三种模式；每轮新建结果目录 |
| `results/verification.md` | 验证范围、真实失败原因和日志索引 |
| `results/sources/` | 已读取的 NVIDIA 文档快照；用于归档核对，不参与构建 |

## 编译与运行

### Mac 本机可验证部分

从仓库根目录运行，使用已有 CMake≥3.20 和 C++17 编译器：

```bash
bash systems_practice/2026-09-16/run.sh cpu
bash systems_practice/2026-09-16/run.sh sanitize
# 如需重现本机依赖失败：
bash systems_practice/2026-09-16/run.sh gpu
```

CPU 模式不会查找 TensorRT，也不会把 GPU 代码编译为替身。脚本将临时目录、编译缓存、CUDA 缓存与构建日志固定在本练习内；每轮独立目录保存 `output.log` 和退出码。没有隐式安装步骤。

### Linux NVIDIA GPU / Jetson 目标设备待验证部分

依赖现有 NVIDIA 驱动、CUDA Toolkit（`cuda_runtime_api.h`/cudart）、TensorRT 开发包（`NvInfer.h`/libnvinfer）、CMake 和 C++17 编译器。不需要 nvonnxparser，不含自定义 CUDA kernel，故目标主程序为 `.cpp`，直接调用 TensorRT 和 CUDA Runtime。

源码按 TensorRT **10.x / 11.x** API 编写：10.x 显式开启强类型网络，11.x 使用默认强类型网络；其他主版本在预处理阶段拒绝。两个分支均**尚未在目标环境编译**，此范围是设计目标，不是全版本兼容认证。FP32 输入/权重保持类型一致，不启用 FP16/INT8/FP8/FP4；小 Batch 本身就是本次部署场景。后续接入低精度模型仍需独立精度验收。

- **Linux x86_64**：使用目标 TensorRT 版本支持矩阵列出的 GPU、驱动、CUDA 与编译器组合；已有 tar 包安装可用 `TENSORRT_ROOT` 指定，系统包一般由 CMake 自动找到。
- **Jetson（如 Orin/Thor）**：在板端原生编译，使用该板 JetPack/L4T 配套支持的 CUDA 与 TensorRT；不要用“aarch64 相同”推断 SBSA 包可直接替代 JetPack 包。先在矩阵选择实际 TensorRT 版本和平台，不在此猜定 JetPack/驱动组合。
- 引擎在目标板本地构建。当前代码不启用版本/硬件兼容模式，不承诺 plan 跨平台、GPU 架构或版本复用。

```bash
# Linux x86_64：系统已安装支持组合时，从仓库根目录运行
bash systems_practice/2026-09-16/run.sh gpu

# 若现有 Toolkit / TensorRT 装在自定义位置（路径替换为实际目录）
TENSORRT_ROOT=/opt/TensorRT CUDAToolkit_ROOT=/usr/local/cuda \
  bash systems_practice/2026-09-16/run.sh gpu

# Jetson：项目位于板端，已安装配套开发头文件/库时
bash systems_practice/2026-09-16/run.sh gpu
```

官方依据（2026-09-16 读取并存档）：[动态 Shape 基础](https://docs.nvidia.com/deeplearning/tensorrt/latest/inference-library/dynamic-shapes-basics.html)、[C++ API](https://docs.nvidia.com/deeplearning/tensorrt/latest/inference-library/c-api-docs.html)、[支持矩阵](https://docs.nvidia.com/deeplearning/tensorrt/latest/getting-started/support-matrix.html)。本次返回的 latest 文档标记 11.3.0；归档版本 URL 曾返回 404，未将其当作已核实资料。

## 正确性验证

- CPU 实际执行顺序 B=`1,4,2,1,3,2`，frame 依次递增，使相同 Batch 的输入也不同，能暴露旧帧复用问题。解析期望为 `max(0,((i+frame%17)%17)-6)/8`，不重复调用参考算子充当答案。
- 每轮检查有效输出和容量尾部哨兵。CPU 还检查 B=`-1,0,5,INT_MAX` 和空输入指针，必须拒绝；ASan/UBSan 任一报错或程序非零退出即失败。
- 目标 GPU 同样跑变值 Shape 序列，逐元素满足 `|gpu-ref|≤1e-6+1e-6*|ref|`，拒绝非有限输出；对最小确定性样例还用解析式验算。每个性能样本结束后也比较 CPU 参考。
- 目标程序打印每个 Shape 的最大绝对误差，GPU 请求入口检查 B=-1/0/5。该检查证明封装层拒绝超界，不宣称实测了 TensorRT 原生越界行为。
- 主机尾部哨兵只验证主机输出有效长度；设备越界必须用目标 `compute-sanitizer` 检查。GPU 精度、原生编译和设备内存检查目前均未验证。

## 性能分析

所有统计均在引擎构建、分配与正确性序列之后；GPU 两遍测量各预热 10 次、采样 100 次，CPU 为 10 组预热、100 组采样，每组 1000 次调用后折算单次。百分位使用 nearest-rank。计时后仍验证输出，不以移除同步换速度。

| 指标 | 精确边界与解释 |
| --- | --- |
| `cpu_reference` | 预分配数组上的 C++ 参考函数调用，包含参数校验；不含分配/输入生成/输出验算；CPU 热缓存辅助微基准 |
| `cpu_enqueue_api` | 主机 `enqueueV3` 调用前后 steady_clock；这是提交耗时，不能当作 GPU 完成时间 |
| `gpu_inference_interval_cuda_events` | 同一 stream 上，H2D 后记录 start，enqueue 后记录 stop；不含 H2D/D2H，包含网络执行及区间内可能的设备空闲/主机提交间隙；不是单个 kernel 的独占时间 |
| 单个 GPU Kernel 时间 | 需 Nsight kernel 活动统计，程序不伪造该值；在分析日志中单独记录各 kernel 次数和时间 |
| `e2e_shape_h2d_enqueue_d2h_sync` | 另一遍不插入 CUDA events，从 Shape 校验之前到 D2H 后 stream 同步返回；包含两次主机 enqueue 计时器读取；不含引擎构建、输入生成、结果比较、上游采集和队列等待 |
| 吞吐 | 串行已测请求数/累计 E2E 时间，单位 request/s；每请求 B=2，不能当作整机 VLA 吞吐 |
| 内存/功耗 | 程序报告 I/O 容量、plan 字节、workspace 上限；总显存、峰值与板级功耗需在目标采集；当前无实测 |

验收：先全部正确性通过；同设备、相同电源模式/时钟/温度条件、相同编译配置下比较基线与修改版日志，期望避免 E2E p95 劣化超过 10%，并核对 1 ms 练习预算。10% 是练习回归门槛，不是统计显著性证明；不能保证微小模型的 Shape 缓存必然提速。计时抖动明显时增加采样数并保存新日志，保留旧证据。不要用 sanitizer 或 profiler 运行结果作为 Release 延迟基线。

目标设备已有分析工具时，从本练习目录运行（替换第一行占位路径）：

```bash
cd systems_practice/2026-09-16
GPU_RUN="$(pwd)/results/gpu-替换为已成功运行的目录后缀"
export TMPDIR="$(pwd)/.tmp" CUDA_CACHE_PATH="$(pwd)/.cache/cuda"
export XDG_CACHE_HOME="$(pwd)/.cache"
ANALYSIS_DIR="$(mktemp -d "$(pwd)/results/profile-XXXXXXXX")"
compute-sanitizer --tool memcheck --error-exitcode 1 \
  "$GPU_RUN/build/trt_dynamic" "$ANALYSIS_DIR/memcheck.plan" \
  > "$ANALYSIS_DIR/memcheck.log" 2>&1
nsys profile --trace=cuda --stats=true --output="$ANALYSIS_DIR/timeline" \
  "$GPU_RUN/build/trt_dynamic" "$ANALYSIS_DIR/nsys.plan" \
  > "$ANALYSIS_DIR/nsys.log" 2>&1
# Jetson 可在另一终端仅在测量期间运行；Ctrl-C 结束采集
tegrastats --interval 100 --logfile "$ANALYSIS_DIR/tegrastats.log"
```

Nsight trace 包含 engine build 和热身；定位性能阶段的末两组 110 次请求再分析，不能把构建期间的 kernel 算入推理延迟。Jetson 的遥测采样间隔远大于此极小网络的一次请求，需报告采样条件，不能宣称逐请求功耗。

## 实际运行结果

| 范围 | 状态与证据 |
| --- | --- |
| Mac Release CPU 编译/执行 | **实际运行并验证**；AppleClang 21.0.0、Darwin arm64、CMake 4.4.3；CTest 1/1 通过，6 次 Shape/逐帧输入检查、4 个非法 Batch 和空指针检查通过；[最终日志](results/cpu-bEqMZkQH/output.log) |
| Mac ASan/UBSan | **实际运行并验证**；同一最终源码 CTest 1/1、所有显式检查通过，无 sanitizer 报错；[日志](results/sanitize-eK6F5Sad/output.log) |
| CPU 参考性能 | B=2、1000 次/组，预热10组、采样100组；p50 **0.000001584 ms/次**，p95 **0.000001708 ms/次**；是热缓存极小函数辅助数据，不用于 GPU 或机器人延迟估算 |
| Mac GPU 配置尝试 | **实际尝试并失败**，退出码1；CMake `FindCUDAToolkit.cmake` 报 `Could not find nvcc executable`；[原始日志](results/gpu-L9qxckGK/output.log) |
| TensorRT 目标源码/构建与输入 | **已生成，GPU 编译和执行因缺少依赖/设备未验证**；本机 CUDA 查找先失败，TensorRT 头文件和库的检测尚未执行，不能宣称已验证其安装状况 |
| GPU 精度/Kernel/E2E/吞吐/功耗 | **未验证、无实测数据**；需 Linux NVIDIA GPU 或配套 Jetson 环境完成验收 |

最终证据和失败摘要见 [verification.md](results/verification.md)。早期 `results/cpu-L6rYfWcG` 与 `results/sanitize-TFz1rBHp` 是增加逐帧变值检查之前的保留日志，不作为最终源码验证依据。

## 工程注意事项

- 配置失败不要继续 `enqueueV3`；输出仍含动态维度或容量不足必须终止。本练习输出由输入 Shape 唯一确定，不覆盖数据相关输出，不能直接套用在 NonZero 等动态输出上。
- 不复制 CUDA RAII 对象；析构不抛异常，但检查和打印 CUDA 清理失败，程序最终返回非零。最后声明的 Drain 在异常退出时先同步，之后才释放 events、缓冲区和 context；同步错误意味着结果无效，不继续服务请求。
- 本例完整串行完成一轮请求再进入下一轮；若扩展到并发服务，需独立 context/stream/缓冲区与缓存所有权。不要共享当前 lambda；任务取消时也应先确认 GPU 生命周期结束再释放数据。
- 256 字节设备 I/O 不包含引擎、context、CUDA runtime 或 workspace。使用锁页内存是为了保证显式异步传输的生命周期，Jetson 统一物理内存也不能自动免除这些契约。
- 手动调用二进制需传入练习内全新 plan 路径；推荐使用 `run.sh` 的唯一目录，避免覆盖已有 plan。输入范围限于生成的有限值，不把极值、NaN/Inf 或量化误差覆盖列为已验证。
- 小网络的调度和传输开销可能主导延迟，不能把结果外推到真实视觉编码器。串行参考路径没有队列上限、掉帧策略或硬实时保证，部署前需另行评估系统约束。

## 自测问题

当 Batch 在 1 和 4 之间交替时，如果只保存上次输入地址和最大缓冲区容量，却省略当前 Shape 更新与请求完成同步，哪些契约可能被破坏，且为什么固定 B=2 的一次精度测试不足以证明这种实现可安全用于双相机控制循环？
