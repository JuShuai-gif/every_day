# 第 01 节：先分清 ARM 架构、CPU 和编译目标

今天开始每天一点 ARM，预计阅读和运行查询共 5～10 分钟。目标只有一个：看到“arm64”时，知道它说明了什么，还缺哪些信息。之前的 [ARM 优化概览](../../daily/2026-09-22/ARM_EDGE.md)作为路线参考，具体知识从本节逐步展开。

本系列的主要参照是 [ROCK 5B/RK3588、Jetson AGX Thor 与 Orin CPU 对照](../../docs/arm/BOARDS.md)。今天的四层区分用于识别这些具体设备，后续每日小例子将对应板上任务。

## 一个边缘部署问题

你在 Mac 编译了一段特征处理代码，希望把它移到 ARM Linux 板卡。两边都叫 ARM，为什么不能直接保证程序能运行、甚至一样快？先把四层拆开：

| 层次 | 它回答什么 | 对边缘编程的影响 |
| --- | --- | --- |
| 架构/指令集 | 软件能使用怎样的指令与寄存器？AArch64 是 64 位执行状态，A64 是对应指令集 | 决定代码使用的基本机器操作；可选扩展还需单独判断 |
| CPU 微架构 | 指令由怎样的流水线、执行单元与缓存执行？ | 相同指令序列的依赖、吞吐和最佳分块可能不同 |
| SoC/整机 | CPU 与内存、GPU/NPU、互连、散热怎样组合？ | 数据搬运、共享带宽与温控会影响完整请求延迟 |
| 软件目标 | 编译器面向哪种 OS、ABI 与特性集合？ | 相同指令集也不保证二进制、依赖库和系统接口兼容 |

本系列先聚焦运行 macOS/Linux 推理程序的 AArch64 应用处理器路径。ARM 还有其他架构配置与嵌入式用途，不能把本课程结论推广到所有 ARM 芯片。基础架构的后续阅读入口是 [Arm 官方架构教程](https://www.arm.com/architecture/learn-the-architecture)，具体指令会在对应课逐项查证。AArch64/A64 的区分可见 [Arm《Exception model》第 3.1 节](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Exception%20model.pdf)；本次只读到检索返回的该节文本，未阅读完整 PDF。

## 今天的现成观察

项目根目录运行，需要 CMake 和支持 C++17 的 Clang/GCC，无 Python 依赖：

```bash
sh systems_practice/arm/2026-09-22/run.sh
```

实现是 [src/inspect_target.cpp](src/inspect_target.cpp)。Shell 只构建并启动程序；C++ 直接调用 POSIX `uname` 读取运行环境，用 `sizeof(void*)` 观察当前程序 ABI，并通过 `#if defined(...)` 和预定义宏报告编译目标特性。它不通过子进程调用 Python 或编译器，也不执行被查询的可选 SIMD 指令。

关键是两种观察发生的时间不同：`#if` 在编译时选择代码，`uname` 在程序运行时读取当前环境。两者都不是对远程板卡的能力检测。CMake 构建入口见 [CMakeLists.txt](CMakeLists.txt)，没有自动安装或依赖下载。

本次 C++ 程序实际输出见 [target-cpp.txt](results/target-cpp.txt)，编译日志见 [cpp-build-run.txt](results/cpp-build-run.txt)。本机显示 Darwin/arm64、Apple clang 21.0.0；默认目标定义了 `__ARM_NEON`、`__ARM_FEATURE_DOTPROD` 和 `__ARM_FEATURE_FP16_VECTOR_ARITHMETIC`。未定义 `__ARM_FEATURE_MATMUL_INT8`、`__ARM_FEATURE_SVE` 和 `__ARM_FEATURE_SVE2`。

这些结果描述的是**这次编译器默认目标允许使用的功能**。宏缺失不能直接证明芯片完全没有该能力；宏存在也不能证明另一台部署机器支持。`__ARM_NEON_SVE_BRIDGE` 只表示桥接头文件可用，不能据此认定硬件支持 SVE。[ACLE 的特性宏与桥接宏定义](https://arm-software.github.io/acle/main/acle.html)

## 今天怎样用于工程

部署前先记录开发环境和目标板的软件/硬件信息，再选择编译目标。不要把本机 `-mcpu=native` 产生的特性集合直接当作通用 ARM 发布条件。后续用正确的目标工具链构建，在板端确认功能并测量；可选指令实现和运行时分派留到第 25 节深入。

性能也分两步：先在同一机器、同一输入下判断改动有无收益，再在目标板重复验证。架构相同只解决一部分兼容性问题，无法保证缓存、线程调度或长时间温控表现相同。

今天已实际编译并运行 C++ 环境/编译特性查询程序，没有执行张量计算内核、推理、NEON benchmark、缓存计数器或功耗测量。[验证范围](verification.json)和[来源记录](source.json)分别归档。

## 语言规则与旧记录

本系列涉及 ARM、CPU 和计算机体系结构的例子统一使用 C/C++，默认 C++17。第 01 节原先用 Python 编排查询，现已移除该入口并换为 C++。原 [target.json](results/target.json) 与 [旧验证记录](results/verification-python-historical.json)仅保留为历史证据，不代表当前实现；历史源代码可从 Git 查看。学习进度仍为第 01 节，没有新增一天或提前推进。

## 下一节

**第 02 节：AArch64 的 X/W 寄存器与 NEON V 寄存器。** 从如何阅读一个操作数开始，解释为什么“64 位 CPU”仍会执行 32 位整数和 128 位向量运算，再接到加载/存储与循环。
