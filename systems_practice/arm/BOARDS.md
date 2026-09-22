# 用实际板卡学习 ARM 边缘性能编程

课程以 RK3588 板卡和 Jetson 为主要教学参照，每天选择一个具体设备上的小问题，由问题解释架构，再给出代码/观察命令与验证办法。基础知识仍按前置顺序推进，不每天重复产品参数。

## 固定参照设备

| 参照设备 | 已核实的 CPU 对应关系 | 课程中的作用 |
| --- | --- | --- |
| Radxa ROCK 5B，RK3588 | 4 个 Cortex-A76＋4 个 Cortex-A55 | 主线之一：大小核、NEON、缓存/带宽、线程池、RKNN 与 CPU–NPU 协作 |
| Jetson AGX Thor Developer Kit，T5000 模块 | 14 个 Neoverse-V3AE 核 | 主线之一：ARM CPU 张量计算、主机调度、共享内存带宽、CPU–GPU 流水线；CUDA 执行目标仍为 Thor SM110 |
| Jetson AGX Orin Developer Kit | Cortex-A78AE | Cortex-A 的 Jetson 对照：核实现、CPU 侧 NEON、调度与平台差异；不把 Orin GPU 作为新的 CUDA 执行目标 |

表中硬件关系于 **2026-09-22** 核实自 [Radxa ROCK 5B/5B+ 产品介绍](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)、[NVIDIA Thor 官方规格](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-thor/)和 [NVIDIA Orin 官方规格](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/)。阅读范围是网页产品介绍及规格表，没有执行板端测试。

RK3588 是 SoC 名称，ROCK 5B 才是这里选定的具体板卡。其他 RK3588 板卡的内存、供电、散热、接口及系统镜像需独立核实。Jetson 是产品家族：Thor 的 CPU 属于 Neoverse 系列，Orin 的 CPU 属于 Cortex-A 系列；T5000/T4000、AGX/NX/Nano 的核数、内存及软件支持不能混用。

这里选定的是教学参照，未确认用户具体拥有哪款板卡，也不要求购买。当前本机仍是 Mac；可执行的通用代码先在本机检查，Linux 板端的命令、工具链、精度与性能分别标明验证状态。

## 每个阶段怎样落到板上

| 阶段 | RK3588 的具体问题 | Jetson 的具体问题 |
| --- | --- | --- |
| 架构/工具链 | 为什么同一循环在 A55 与 A76 上成本不同？怎样识别目标核与编译选项？ | 怎样识别 Orin/Thor、CPU 型号与 Jetson Linux 环境？ |
| NEON | 对连续 FP32 特征做点积，检查尾部、FMA 误差和多累加器 | 对 CPU 前后处理做同口径向量化比较，不能把 GPU 时间记到 CPU SIMD 上 |
| 存储/多核 | 图像/量化块的访问布局，A76/A55 任务分配及共享统计 | CPU 算子和 GPU 并行时的带宽、队列、线程唤醒与干扰 |
| 推理部署 | 预处理→RKNN→后处理，计入布局转换、缓冲区及同步 | 预处理→TensorRT/CUDA→后处理，计入主机提交、等待与完整请求延迟 |
| 持续运行 | 固定输入下比较线程数、频率与散热后的稳定延迟 | 核实功耗模式、温度与 GPU/CPU 竞争后再比较 P50/P95 |

每节选一列中的一个小问题深入，不同时布置两套完整工程。涉及 Cortex-R/M 的内容只在实时控制或 MCU 协作确有帮助时简要对比，主要精力仍放在这两类边缘设备。

## 每节须交付的设备信息

1. 具体板卡/模块、SoC、CPU 核；当前资料日期与实际软件环境分开。
2. 一个输入明确的问题，例如 UINT8 图像转换、FP32 点积、INT8 点积或 worker 队列；标明 shape、dtype 和计时区间。
3. 与本节层次相符的命令：基础课先观察设备和汇编，后续再编译、绑定线程、采集性能；不预设 CPU 编号、可选扩展或 PMU raw event。
4. 明确哪些结果来自 Mac，哪些来自目标板；产品标称指标、模型推算与真实测量分开。

实际接入板卡后先读型号、OS、内核、CPU 拓扑与特性，再核实编译器及 RKNN/JetPack/驱动版本。根据采集结果选择核心和工具，不硬编码“CPU0～3 一定是哪种核”，也不假定相同物理内存意味着可以省略同步。
