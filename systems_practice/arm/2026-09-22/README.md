# 第 01 节：先分清 ARM 架构、CPU 和编译目标

今天开始每天一点 ARM，预计阅读和运行查询共 5～10 分钟。目标只有一个：看到“arm64”时，知道它说明了什么，还缺哪些信息。之前的 [ARM 优化概览](../../2026-09-22/ARM_EDGE.md)作为路线参考，具体知识从本节逐步展开。

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

项目根目录运行，无需安装依赖；需要现有 Python 3 和 Clang：

```bash
sh systems_practice/arm/2026-09-22/run.sh
```

脚本查询当前进程环境、`clang++ --version`、`clang++ -dumpmachine` 与默认目标的预定义宏。它不调用可选 SIMD 指令，也不读远程板卡。

实际输出见 [target.json](results/target.json)。本机显示 Darwin/arm64、Apple clang 21.0.0；默认目标定义了 `__ARM_NEON`、`__ARM_FEATURE_DOTPROD` 和 `__ARM_FEATURE_FP16_VECTOR_ARITHMETIC`。未定义 `__ARM_FEATURE_MATMUL_INT8`、`__ARM_FEATURE_SVE` 和 `__ARM_FEATURE_SVE2`。

这些结果描述的是**这次编译器默认目标允许使用的功能**。宏缺失不能直接证明芯片完全没有该能力；宏存在也不能证明另一台部署机器支持。`__ARM_NEON_SVE_BRIDGE` 只表示桥接头文件可用，不能据此认定硬件支持 SVE。[ACLE 的特性宏与桥接宏定义](https://arm-software.github.io/acle/main/acle.html)

## 今天怎样用于工程

部署前先记录开发环境和目标板的软件/硬件信息，再选择编译目标。不要把本机 `-mcpu=native` 产生的特性集合直接当作通用 ARM 发布条件。后续用正确的目标工具链构建，在板端确认功能并测量；可选指令实现和运行时分派留到第 25 节深入。

性能也分两步：先在同一机器、同一输入下判断改动有无收益，再在目标板重复验证。架构相同只解决一部分兼容性问题，无法保证缓存、线程调度或长时间温控表现相同。

今天已运行只读查询，没有新 ARM 计算内核、推理、NEON benchmark、缓存计数器或功耗数据。[验证范围](verification.json)和[来源记录](source.json)分别归档。

## 下一节

**第 02 节：AArch64 的 X/W 寄存器与 NEON V 寄存器。** 从如何阅读一个操作数开始，解释为什么“64 位 CPU”仍会执行 32 位整数和 128 位向量运算，再接到加载/存储与循环。
