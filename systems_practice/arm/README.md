# 每天一点 ARM：从架构到边缘端高性能编程

每天随北京时间 08:30 的既有练习交付一节，默认阅读与观察约 5～10 分钟。主主题继续轮转，ARM 小课每天按自己的进度推进。每天只讲一个小点，连接前一节，配现成例子或命令，不增加必做作业。

[今天第 01 节](2026-09-22/README.md) · [课程历史](index.md) · [完整顺序](curriculum.json) · [当前进度](progress.json)

## 首轮路线

编号是学习顺序，不是必须赶完的日历日期。缺资料时先补齐；不跳过前置，不因日期变化自动标记完成。

| 阶段 | 节次 | 从理解走向应用 |
| --- | --- | --- |
| 架构与工具链 | 01～07 | ISA/CPU/SoC → 寄存器 → 加载存储 → 指令依赖 → ABI → 编译目标 → 基准方法 |
| NEON 与数据处理 | 08～14 | 自动向量化 → 向量加载/尾部 → FMA/误差 → 多累加器 → 重排/布局 → FP16 → INT8 点积 |
| 存储与多核 | 15～21 | Cache/工作集 → 分块/packing → 带宽/预取 → TLB → 原子/内存序 → 伪共享 → 大小核/线程池 |
| 边缘推理与部署 | 22～28 | GEMV/小 Batch → 量化解码融合 → 图像处理融合 → 扩展分派 → 性能工具 → CPU–加速器流水线 → 热稳定/能耗验收 |

首轮完成后继续分析经实际阅读的 ggml、ncnn、Arm Compute Library 或 KleidiAI 小内核，逐渐组成边缘推理项目；不把教程重新从第一节循环一遍。每日路线可依据已学内容调整，但须在进度里记录原因。

## 每节的组织方式

先用一两句承接前一节；再解释一个概念、它在边缘端的用途、一个小例子及其真实结果；提供一手资料和下一节预告。基础节允许使用只读命令；进入 SIMD 代码后再做标量对照、尾部/误差验证、反汇编和计时。

一节内容已交付、查询命令已运行、内核已验证、目标板已验证分别记录。同一天重跑只补充本节。CPU 或 SIMD 主主题日可以共用代码，但小课仍按前置知识讲清当天的新收获。

## 资料怎么用

- [Arm Learn the Architecture](https://www.arm.com/architecture/learn-the-architecture)：查找架构入门与专题指南，具体章节逐课核实。
- [Arm Learning Paths：自动向量化入门](https://learn.arm.com/learning-paths/cross-platform/loop-reflowing/introduction-to-autovectorization/)：已阅读其普通循环与 NEON 向量加法示例，作为后续第 08 节资料候选；届时重新核对编译器和实际生成结果，不直接套用教程性能结论。
- [ACLE](https://arm-software.github.io/acle/main/acle.html)：核实扩展、特性宏及 intrinsics 条件；第 01 节已阅读相关宏定义。
- [NEON Intrinsics Reference](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)：按具体 intrinsic 查询输入类型、指令映射和支持条件。

每天主动检索当期一手资料并记录阅读日期/版本。源码课须定位真实文件和函数；只有网页摘要或访问失败时如实标注，不声称读过完整实现。Mac 上观察到的性能不能直接代表 RK3588 或其他 ARM 板卡。
