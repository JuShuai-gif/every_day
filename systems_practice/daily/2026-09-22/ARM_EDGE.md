# CPU 补充：ARM 架构、SIMD 与边缘端高性能编程

本页保留为 CPU 缓存争用课程的拓展阅读。最新安排是[每天一节 ARM 小课](../../docs/arm/README.md)，不受主主题轮换限制；[今日第 01 节](../../arm/2026-09-22/README.md)从基础开始按序推进。本页概览不计为完成所有相关课程，没有新增 SIMD 实测或第二个必做练习。

## ARM 架构和 SIMD 是什么

AArch64 是 ARM 的 64 位执行状态。指令集规定程序可使用的指令、寄存器等接口；具体微架构决定指令吞吐、执行单元、缓存与乱序能力；整机还受内存、操作系统调度和温控影响。同一份 ARM 代码在 Apple Silicon、RK3588 和其他 ARM 设备上，最佳线程数与分块大小可能不同。

SIMD 表示一条指令对多个数据通道执行同类操作。NEON（Advanced SIMD）常用 128 位向量，可容纳 4 个 FP32、8 个 16 位或 16 个 8 位元素。容纳某种位宽不等于支持该类型的所有运算，也不意味着程序自动获得 4 倍或 16 倍加速：访存、依赖、归约和尾部仍有成本。

| 能力 | 边缘计算中的使用 | 要核实的边界 |
| --- | --- | --- |
| NEON FP32 加载、FMA、归约 | 特征点积、归一化、小矩阵计算 | 数据连续性、尾部、浮点误差和编译目标 |
| FP16 向量算术 | 适合低精度的计算，结合半精度存储降低访存量 | FP16 存储/转换与 FP16 算术分别判断；累加精度单独选择 |
| INT8 dot-product | 多个 INT8 乘积累加到 INT32，服务量化点积 | `__ARM_FEATURE_DOTPROD`；scale、zero-point、累加溢出 |
| i8mm | 面向整数矩阵乘的指令路径 | `__ARM_FEATURE_MATMUL_INT8`；内核 packing 格式与形状 |
| SVE / SVE2 | 可伸缩向量与谓词控制的专门实现 | 硬件、OS 和编译器支持；不假定所有 ARM 边缘设备都有 |

扩展和 intrinsics 的条件参见 [Arm NEON 指令参考](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html) 与 [Arm C Language Extensions](https://arm-software.github.io/acle/main/acle.html)，阅读日期 2026-09-22。

## 一条点积怎样使用 NEON

以连续 FP32 特征 `x[N]`、`y[N]` 的点积为例，输出一个 FP32 数：

1. 保留逐个累加 `x[i] * y[i]` 的算法参考和更高精度结果，用于检验；普通 C++ 循环在优化编译下也可能自动向量化。
2. AArch64 NEON 路径用 `vld1q_f32(x + i)` 和 `vld1q_f32(y + i)` 各加载 4 个 FP32。
3. `vfmaq_f32(acc, vx, vy)` 对 4 个通道分别乘加，官方映射为 `FMLA Vd.4S,Vn.4S,Vm.4S`。循环后通过 `vaddvq_f32(acc)` 横向归约，再计算不足 4 个的尾部。
4. 单个累加器存在循环依赖。尝试 2～4 个独立累加器并在最后合并，可能提高吞吐，但会增加寄存器占用，是否有效需要测量。

以上是调用流程说明，并非本次已编译或运行的新函数。完整实现应保证每次向量加载都在有效内存内，处理 `N=0/1/3/4/5`、stride 和非向量宽度对齐的地址。支持非对齐访问不代表可以越过分配边界。FMA 和归约顺序会改变浮点舍入，应按数值范围检查误差，不能默认逐位相等。[官方指令映射](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)

高性能实现还要让每次加载都有用：按计算方式选择 AoS/SoA，沿连续维度向量化，让重复使用的权重在分块内复用。packing 有额外时间和空间成本，只有足够复用时才划算。融合反量化与累加、归一化与布局转换，可以减少中间读写，也可能增加寄存器压力。这些均是需要用具体输入验证的优化假设。

## 与今天的原子计数有什么关系

本期 [真实目标文件反汇编](results/hot_loop-disassembly.txt) 中出现 `ldadd x8,x9,[x0]`，用于对单个共享整数进行原子读改写；它不是同时计算多路特征的 NEON SIMD。

今天首先处理缓存争用：按 worker 隔离统计槽，在业务允许时减少共享原子访问。不能把多个 `atomic` 换成普通 NEON load/add/store，那会失去并发原子语义。`memory_order_relaxed` 放松顺序，但仍保留原子性和缓存一致性成本。

在同一个双相机推理服务中，worker 的特征计算可以使用 SIMD，任务调度与统计则通过线程私有状态、必要同步和合理布局降低开销。向量化改善单核数据处理，多核并行还需要处理任务粒度、共享状态与调度成本。

## 边缘端优化的实际步骤

| 步骤 | 工作内容 | 验证依据 |
| --- | --- | --- |
| 定位瓶颈 | 分开计时预处理、packing、CPU 算子、加速器提交/等待、后处理和完整请求 | 相同输入的端到端 P50/P95，确认优化部分占比 |
| 改善访存 | 连续访问、缓存分块、复用缓冲区、减少复制与中间张量 | 字节量估算、分阶段耗时；有条件再测缓存和带宽事件 |
| 优化单核 | 先看自动向量化，再尝试 NEON；比较累加器数和块大小 | 数值对照、生成指令、相同数据规模和计时范围 |
| 增加线程 | 复用线程池、合理分片、减少共享统计、观察大小核分工 | 1/2/4 等线程对照、调度成本、核迁移和带宽瓶颈 |
| 优化流水线 | CPU 与 NPU/GPU 协作，计入转换、队列和同步成本 | 缓冲区所有权正确，完整请求延迟确实改善 |
| 板端验收 | 持续运行，观察频率与温度；有测量设备再记录功耗 | 设备/软件版本、预热与采样方法、温控后的延迟与能耗 |

大小核机器上，线程增加可能改变任务所在的核，也可能争抢共享带宽。Linux 核绑定需结合拓扑和权限；macOS 调度/QoS 机制另行核实，不把命令混用。小 Batch 任务还要计入线程唤醒和 packing 开销，不能只报告最内层算术循环。

## 编译与分析怎么做

在项目根目录查看当前 Clang 编译目标的 ARM 特性宏：

```bash
clang++ -dM -E -x c++ /dev/null | rg '__aarch64__|__ARM_NEON|__ARM_FEATURE_(DOTPROD|MATMUL_INT8|FP16_VECTOR_ARITHMETIC|SVE)'
```

这表示编译目标能力，不是另一台机器的运行时检测。可选扩展应隔离成专门编译的实现，由目标 OS 的能力查询选择，保留适当基线路径。不要把面向开发机的 `-mcpu=native` 二进制当成通用 ARM 发布包；交叉编译还需正确的 target、sysroot、ABI 和依赖库。[ACLE 特性定义](https://arm-software.github.io/acle/main/acle.html)

本次实际执行该命令，Apple Clang 默认目标定义了 `__ARM_NEON`、`__ARM_FEATURE_DOTPROD` 和 `__ARM_FEATURE_FP16_VECTOR_ARITHMETIC`，没有输出 `__ARM_FEATURE_MATMUL_INT8` 或 `__ARM_FEATURE_SVE`。输出中的 `__ARM_NEON_SVE_BRIDGE` 不能作为硬件支持 SVE 的证据。向量化报告的三个选项也通过本机 Clang 空输入语法检查；这不等于已运行 SIMD 内核。

对自己的 Clang 内核构建，可添加 `-Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize` 查看向量化报告，再用 `-S` 或目标文件反汇编确认生成指令。看到 `fmla` 只证明生成路径，不证明它是热点或获得加速。比较时注明普通 C++ 基线是否自动向量化；严格标量对照需单独控制其编译选项。

本期 [README](README.md) 已给出 ARM 汇编与 Linux perf 命令。Linux 先 `perf list` 查询事件，再采集 cycles、instructions、缓存及调度信息；事件语义和权限随机器而异。macOS 使用其可用分析工具，不能直接宣称本机已跑 Linux perf。

当前验证仍是主课的 arm64 原子计数正确性、反汇编和布局基准。本页没有新增 NEON 内核、目标板、功耗或模型端到端测试，布局加速数据不能当作 SIMD 加速数据。后续独立 SIMD 课优先从 ggml/ncnn 的实际 ARM 实现选取并核验相关内核，给出本机可运行的标量/NEON 对照。
