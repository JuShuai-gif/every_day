# 每天一点 ARM：从架构到边缘端高性能编程

每天随北京时间 08:30 的既有练习交付一节，默认阅读与观察约 5～10 分钟。主主题继续轮转，ARM 小课每天按自己的进度推进。每天只讲一个小点，连接前一节，配现成 C/C++ 例子与编译运行命令，不增加必做作业。

[今天第 01 节](../../arm/2026-09-22/README.md) · [课程历史](../../arm/index.md) · [完整顺序](../../arm/curriculum.json) · [当前进度](../../arm/progress.json)

## 以哪些板卡为主线

重点使用 **RK3588（以 ROCK 5B 为教学参照）与 Jetson AGX Thor** 的实际任务，Jetson AGX Orin 作为 Cortex-A/CPU 对照。每节从板上的一个问题进入架构、代码与验证。[板卡对应关系与阶段实例](BOARDS.md)说明了设备、CPU 和验证边界。Thor 使用 Neoverse-V3AE，Orin 使用 Cortex-A78AE，课程会区分两者。

## 首轮路线

编号是学习顺序，不是必须赶完的日历日期。缺资料时先补齐；不跳过前置，不因日期变化自动标记完成。

| 阶段 | 节次 | 从理解走向应用 |
| --- | --- | --- |
| 架构与工具链 | 01～07 | ISA/CPU/SoC → 寄存器 → 加载存储 → 指令依赖 → ABI → 编译目标 → 基准方法 |
| NEON 与数据处理 | 08～14 | 自动向量化 → 向量加载/尾部 → FMA/误差 → 多累加器 → 重排/布局 → FP16 → INT8 点积 |
| 存储与多核 | 15～21 | Cache/工作集 → 分块/packing → 带宽/预取 → TLB → 原子/内存序 → 伪共享 → 大小核/线程池 |
| 边缘推理与部署 | 22～28 | GEMV/小 Batch → 量化解码融合 → 图像处理融合 → 扩展分派 → 性能工具 → CPU–加速器流水线 → 热稳定/能耗验收 |

首轮完成后继续分析经实际阅读的 ggml、ncnn、Arm Compute Library 或 KleidiAI 小内核，逐渐组成边缘推理项目；不把教程重新从第一节循环一遍。每日路线可依据已学内容调整，但须在进度里记录原因。

## Cortex 会怎样讲

Cortex 部分重点讲 **RK3588 的 Cortex-A55/A76**，并联系 Orin 的 Cortex-A78AE；Thor 的 Neoverse-V3AE 单独讲清，按实际设备选取机制。Cortex 是处理器核系列名称；Armv8-A 等是架构版本，不能混为一谈。

- 第 04、06 节：顺序/乱序执行、指令依赖，以及核型号和编译目标的关系。
- 第 11、15 节：NEON 执行资源、寄存器压力、L1/L2 与 SoC 缓存配置，解释为什么相同代码在不同核上表现不同。
- 第 21、26 节：大小核调度、线程池和性能计数器，结合具体优化手册找瓶颈。
- 架构导读还会简要比较 Cortex-A（应用处理）、Cortex-R（实时处理）、Cortex-M（微控制器）及其边缘用途；不把 NEON 或 AArch64 默认推广到所有 Cortex 产品。

参考 [Arm 处理器分类](https://developer.arm.com/developer/ip-products/)、[Cortex-A55 官方资料](https://support.arm.com/compute-ip/cortex-a55)和 [Cortex-A76 官方资料](https://support.arm.com/compute-ip/cortex-a76)（2026-09-22 查询）。本次支持页直访提示服务查询失败，仅见公开入口，未读完整优化手册。具体吞吐、缓存大小和可选扩展在对应课按核版本/SoC 核实，不能从产品名猜测；Mac 验证不当作 Cortex 板端性能数据。

## 每节的组织方式

先用一两句承接前一节；再解释一个概念、它在边缘端的用途、一个小例子及其真实结果；提供一手资料和下一节预告。**所有 ARM/CPU/体系结构示例必须使用 C/C++，默认 C++17。** 基础节也使用可编译的小程序直接查询，Shell/CMake 仅作构建入口；进入 SIMD 代码后再做标量对照、尾部/误差验证、反汇编和计时。

一节内容已交付、查询命令已运行、内核已验证、目标板已验证分别记录。同一天重跑只补充本节。CPU 或 SIMD 主主题日可以共用代码，但小课仍按前置知识讲清当天的新收获。

## 资料怎么用

- [Arm Learn the Architecture](https://www.arm.com/architecture/learn-the-architecture)：查找架构入门与专题指南，具体章节逐课核实。
- [Arm Learning Paths：自动向量化入门](https://learn.arm.com/learning-paths/cross-platform/loop-reflowing/introduction-to-autovectorization/)：已阅读其普通循环与 NEON 向量加法示例，作为后续第 08 节资料候选；届时重新核对编译器和实际生成结果，不直接套用教程性能结论。
- [ACLE](https://arm-software.github.io/acle/main/acle.html)：核实扩展、特性宏及 intrinsics 条件；第 01 节已阅读相关宏定义。
- [NEON Intrinsics Reference](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)：按具体 intrinsic 查询输入类型、指令映射和支持条件。

每天主动检索当期一手资料并记录阅读日期/版本。源码课须定位真实文件和函数；只有网页摘要或访问失败时如实标注，不声称读过完整实现。Mac 上观察到的性能不能直接代表 RK3588 或其他 ARM 板卡。
