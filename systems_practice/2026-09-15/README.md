# 2026-09-15 · CUDA Kernel：双相机预处理融合

## 工业场景

机器人每个控制周期接收左右相机各一张已裁剪、缩放好的 RGB 图像，为 VLA 视觉编码器生成 FP16 输入。这里聚焦 TensorRT 调用前的预处理：UINT8 NHWC → FP16 NCHW，并按通道归一化。数据由确定性生成器提供，无需相机、模型或下载；不是完整相机接入方案。Jetson Thor 或其他 NVIDIA 边缘 GPU 是后续验收目标，本次开发主机为 Apple Silicon。

## 概念回顾

算子融合把原本通过全局内存交换中间结果的多个计算步骤放进同一个 CUDA Kernel。双相机预处理常先把交错排列的 RGB 像素改成按通道连续排列，再做减均值、除标准差和半精度转换。分成两次启动时，第一个 Kernel 写出浮点中间张量，第二个再读回；融合后，每个线程直接根据输出位置找到输入像素，在寄存器内完成归一化并写出最终结果。这样可以减少一次启动和中间张量的读写，但它并不保证时延按字节数同比下降。布局变换仍会影响访存合并，整数索引会消耗指令，小输入还可能主要受启动开销限制。工程上应保持输入、输出、精度和同步语义一致，分别比较设备端计算区间与包含传输的端到端区间。只有正确性通过，并且目标设备上的延迟分布满足预算，才有依据把融合版本接入推理流水线；不能用主机参考实现的时间代替 GPU 测量，也不能把省去的理论访存量直接当成实际带宽提升。

## 编码练习

**唯一任务（约 25 分钟）：把双 Kernel 预处理替换为保持相同接口的融合 Kernel，并完成部署验收。** 仓库提供完整可运行的参考实现；先用 5 分钟读 `layout`、`normalize_cast` 和 CPU 参考，接着用 12 分钟独立推导并重写 `fused` 的索引与计算，最后用 8 分钟运行校验、记录指标。不要额外增加算子或模型。

| 项目 | 合约 |
| --- | --- |
| 输入 | 连续 RGB UINT8，NHWC `[2,224,224,3]`；B=2 表示两台相机；无行间 padding |
| 输出 | 连续 FP16，NCHW `[2,3,224,224]`；共 301,056 元素 |
| 公式 | `y[b,c,h,w] = (x[b,h,w,c]/255 - mean[c])/std[c]` |
| 参数 | mean=`[0.485,0.456,0.406]`，std=`[0.229,0.224,0.225]`；仅为本练习输入合约，上线须匹配模型 |
| 约束 | 不使用全局 FP32 中间张量；预分配资源；不删除同步、错误检查与正确性校验 |
| 验收目标 | 标准形状下融合 Kernel p50 不高于基线；H2D→计算→D2H→同步的 p95 ≤ 1 ms |
| 内存预算 | 标准形状单方案设备有效载荷 ≤ 3 MiB；不含 CUDA 上下文和分配器开销 |

1 ms 是**本练习设定的待验证预算**，不是特定 Jetson 的性能承诺。无 GPU 时完成 CPU 校验并将 GPU 验收留空，不根据 CPU 结果决定是否上线。程序打印 `PERF_GOAL ... PASS/MISS`；性能未达标不会被伪装成正确性错误，也不意味着部署验收通过。

## 文件说明

- `src/preprocess.cu`：双 Kernel 基线、融合参考、CUDA RAII 资源封装、逐元素验收和两类 GPU 计时。
- `src/common.hpp`：输入合约、确定性数据、CPU 参考与独立的输出索引实现、统计工具。
- `src/cpu_check.cpp`：布局、数值、边界和错误输入检查，以及 CPU 参考性能测量。
- `CMakeLists.txt`：C++17 构建，自动检测 CUDA；缺失时仅构建 CPU 校验。
- `run.sh`：构建与运行，将每次输出保存到独立的 `results/run-XXXXXXXX/output.log`。
- `results/verification.md`：本次验证详情、失败原因与修复记录。
- `results/sanitizers.log`：实际 ASan/UBSan 检查输出；其耗时不可作为 Release 性能。
- `build/`：本机生成的二进制与缓存，不可直接搬到 Jetson 使用。

## 编译与运行

本机或已有 CUDA 环境的一键入口，不会安装依赖：

```bash
cd /Users/guhaoran/code/EveryDay
bash systems_practice/2026-09-15/run.sh
```

在已配置兼容 CUDA Toolkit 的目标设备，使用独立构建目录，避免复用 macOS 缓存。以下仍以本项目路径举例，迁移时替换 `cd` 路径：

```bash
cd /Users/guhaoran/code/EveryDay/systems_practice/2026-09-15
mkdir -p build-gpu/tmp
export TMPDIR="$PWD/build-gpu/tmp"
cmake -S . -B build-gpu -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_COMPILER=nvcc
cmake --build build-gpu --parallel 2
./build-gpu/cpu_check
./build-gpu/cuda_preprocess 256
```

如需显式指定架构，查询目标设备与 Toolkit 支持后设置 `-DCMAKE_CUDA_ARCHITECTURES=<目标数值>`；不在此猜测 Thor 的架构参数。交叉编译还需对应 sysroot 和主机编译器，以上命令用于目标设备原生构建。

已有 Nsight 时可选采样，结果目录必须留在本练习下：

```bash
cd /Users/guhaoran/code/EveryDay/systems_practice/2026-09-15
mkdir -p results
nsys profile --trace=cuda,nvtx,osrt --output="results/nsys-$(date +%s)" ./build-gpu/cuda_preprocess 256
ncu --set basic --kernel-name regex:fused --launch-skip 10 --launch-count 1 --export="results/ncu-$(date +%s)" ./build-gpu/cuda_preprocess 256
```

## 正确性验证

- CPU：独立的“输入像素遍历”与“输出线性遍历”逐元素比较，绝对误差 ≤ `1e-6`。
- GPU：基线和融合均与 FP32 CPU 参考比较，要求所有结果有限，且 `abs(gpu-ref) ≤ 1e-3 + 1e-3*abs(ref)`；误差覆盖 FP16 舍入，未开启 fast-math。
- 标准 `[2,224,224,3]` 与尾部 `[2,223,225,3]` 检查跨相机、跨通道索引和非整块元素。后者 301,050 个元素不能整除默认 block=256。
- 单像素 `[1,1,1,3]` 使用 RGB=`[0,127,255]`，CPU 还与独立双精度公式比较；B=0 直接返回，不启动零维网格，不调用零长度分配。
- 负 Batch 必须抛出参数错误；H/W 允许 1～4096、B 允许 0～2，限制尺寸避免无界分配。运行错误返回非零；性能目标单独打印。
- CPU Sanitizer 通过只说明已运行 CPU 路径，不能证明 GPU 索引、FP16 转换或 CUDA 资源处理正确。

## 性能分析

每个非空形状先预热 10 次，再采样 50 次。p50/p95 使用 nearest-rank，无需外部统计库。

| 指标 | 计时范围与用途 |
| --- | --- |
| `CPU_reference_wall_ms` | CPU 参考函数的 steady_clock 墙钟时间；不含分配、数据生成、checksum，不是线程 CPU 占用时间 |
| `kernel_ms_p50/p95` | CUDA Event 设备时间；融合为单次 Kernel，基线为两个 Kernel 的完整区间，可能包含启动间隙；排除传输 |
| `e2e_ms_p50/p95` | CPU 墙钟：H2D、Kernel 启动/执行、D2H、最终同步；不含相机采集、分配和逐元素 CPU 校验 |
| 内存与误差 | 最大绝对误差、device/pinned payload 字节数；这些是有效载荷计算值，不是峰值显存实测 |

CUDA Event 应在完成同步后读取；异步拷贝使用 pinned host buffer。依据：[NVIDIA Event API](https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__EVENT.html)、[CUDA Best Practices：传输与计时](https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/)。

**理论账本，非实测：** 基线逻辑读写量为每元素 `1+4+4+2=11` 字节，融合为 `1+2=3` 字节；标准形状对应 3,311,616 与 903,168 字节。融合去掉 1,204,224 字节 FP32 临时有效载荷。缓存、访存事务和相机内存路径会改变真实 DRAM 流量，不能据此声称固定加速比。

在同一设备、电源模式、散热和后台负载下记录两种实现的 p50/p95、block、GPU 型号、驱动/Runtime 版本、功耗模式与温度。Nsight Systems 检查传输和启动间隙；Nsight Compute 检查内存吞吐、占用率和索引指令开销。Profiler 会扰动运行，性能验收用未插桩程序；若结果接近噪声，交换测量顺序并独立复测。50 个样本用于快速练习，生产尾延迟需要更长采样。

## 实际运行结果

北京时间 2026-09-15 09:41，Darwin 25.6.0 arm64，AppleClang 21.0.0，CMake 4.4.3，Release。记录来自[原始成功日志](results/run-2m3zbaM3/output.log)。

| 项目 | 真实状态或结果 |
| --- | --- |
| CPU 编译及运行 | **实际运行并验证**；退出码 0，四种形状和负 Batch 检查全部通过 |
| CPU 最大布局误差 | 0.000000（日志打印精度） |
| 标准双相机 CPU 参考 | p50 **0.159875 ms**，p95 **0.275375 ms** |
| 非整齐尺寸 CPU 参考 | p50 0.183875 ms，p95 0.224208 ms |
| 单像素 CPU 参考 | p50/p95 0.000042 ms；接近计时分辨率，不宜作优化依据 |
| CPU ASan + UBSan | **实际运行并验证**；编译运行成功，未报告地址或未定义行为错误 |
| CUDA 编译 | **未验证**：CMake 检测 CUDA compiler NOTFOUND，未调用 nvcc |
| GPU 正确性、Kernel/端到端性能 | **因缺少 NVIDIA GPU 与 CUDA 依赖而无法验证** |
| Nsight 分析 | **仅生成命令但未运行**；本机未发现 nsys/ncu |

本次没有 GPU 性能数值、TensorRT 推理结果或功耗测量。CPU 计时不是 GPU 端到端时延。Shell 初始失败及修复保存在[验证记录](results/verification.md)。

## 工程注意事项

- 摄像头常输出 NV12/BGR、有 stride 或 DMA buffer，本例只接收已缩放的连续 RGB；接入前必须确认色彩、行跨度和模型的 mean/std，不能只改指针。
- 下游若采用 NHWC、动态分辨率、不同 TensorRT 输入 dtype，应以绑定张量合约为准；避免重复做布局转换。这里没有 resize、色彩转换或 TensorRT 引擎。
- 当前测量为单 stream 串行流水线；生产若直接将输出交给同一 stream 上的推理，可省 D2H。消费者必须等生产完成，缓冲区复用必须有完成事件保障。本练习保留 D2H 用于公平验证。
- pinned memory 和 device buffer 由 RAII 管理，所有 CUDA 状态检查；异常时先同步 stream，再释放缓冲区。设备清理错误也会报告并使最终结果失败。
- 集成 GPU 的共享物理内存不等于所有拷贝天然免费；需在实际相机内存路径上分析。不要把桌面独显或本机 CPU 数据直接迁移为 Jetson 指标。
- `no kernel image` 通常需核对目标架构；`insufficient driver` 需核对驱动与 Toolkit；Nsight 可能受性能计数器权限限制。记录具体错误，勿自动升级驱动或改系统权限。
- 20～30 分钟只覆盖融合实现与最小验收；没有覆盖真实相机、完整模型、控制回路安全性或长时间热稳态测试。

## 自测问题

若融合后 Kernel p50 从 0.08 ms 降至 0.04 ms，但端到端 p95 仍为 1.3 ms（这两个数字是假设），你会用哪类时间线证据判断下一步该优化传输、缓冲区交接还是调度，并如何保证新的计时边界与原验收标准一致？
