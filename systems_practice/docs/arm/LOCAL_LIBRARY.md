# 本地 ARM 资料：使用规则与已确认勘误

2026-09-28 用户确认纳入每日生成要求。此文是资料使用约束，不是新课程交付。后续选用本地资料时先读本页；原始 PDF 保持只读，不复制到课程仓库。

## 来源与审查范围

- 实际目录：`/Users/guhaoran/书籍资料/ARM/VivekPublicRepo`，不是“ARM 文档”。
- 原仓库：[vivekgit84/VivekPublicRepo](https://github.com/vivekgit84/VivekPublicRepo)，本地实际 commit `03210a2b0b24626540eead73a8759973c94dd53b`，检查时工作区干净。
- 33 份 PDF、551 页，主要为 MMU、页表/TLB、屏障、缓存、中断、虚拟化、QNX/BSP 资料。MMU 目录列出第23章，但本地缺该章PDF；独立中断资料不能未经核对就认作替代。
- 全部文件已提取文本并清点；实际阅读目录、描述符速查表、屏障手册、架构概述、MMU性能章，以及故障/调试/案例/中断的部分页面。**未逐页审完551页，不表示未列出的内容准确。** 三处关键页面渲染核对，排除文本提取造成的位号/指令/层级误读。
- 仓库跟踪文件是PDF与Markdown资料，未发现可编译实现项目及LICENSE；许可尚未确认。读取资料不等于阅读成熟开源实现，不用它满足每日源码课的实现阅读要求。
- [文件页数与SHA256](../results/arm-library-20260928/inventory.json)用于核对本次版本；[审查记录](../results/arm-library-20260928/review.json)区分读取与验证范围。先前网页无法读取正文的[历史记录](../results/career-os-20260928/sources.json)保留；本地审查是后续新增证据。

## 必须遵守的引用流程

1. 只在当期机制相关时选具体PDF和页面，先检查本地版本/文件哈希及勘误。路径缺失时记录，不假称访问成功。
2. 读取原页，记录文件、物理页码/章节、版本或SHA256、实际阅读范围。抽取全文不自动等于阅读全文。
3. 对照对应版本的Arm架构/CPU官方文档、Linux源码或SDK原始实现，核实位域、指令条件、异常级、安全状态、内存类型与一致性域。PDF作为选题提纲，不能成为技术结论的唯一依据。
4. 每课source/README分别列出“资料中的说法、已核实结论、适用条件、一手证据、仍待验证项”。已有错误须使用纠正后的结论，不照抄示例；尚不能核实的争议结论不进入可运行实现。
5. 核对资料、实现阅读、本机编译运行、目标板验证分别记录。硬件查询/模拟结果不替代目标板性能；ARM基础用C/C++，CUDA仍固定Thor SM110。
6. 不修改原书籍目录，不将PDF、全文提取物或嵌套Git仓库提交进课程；仅归档必要摘要、勘误与来源记录。许可未确认时不大段转载。

## 已确认的四处错误

页码均为PDF物理页码，以本次commit和文件哈希为准。下面是抽查发现，不是完整勘误表。

| ID | 文件与页码 | 资料中的错误 | 经核实的结论与依据 |
| --- | --- | --- | --- |
| ARM-PDF-01 | ARM-MMU/MMU Descriptor Bit-Level Summary.pdf（原文件名含非断行连字符），第3页 | Table Descriptor把PXNTable、UXNTable写为bit48、49 | 对该传统描述符格式，对应位为59、60；Linux ARM64的P4D/PUD/PMD_TABLE_PXN和TABLE_UXN定义可核实。扩展格式仍须按目标架构重新检查。见[S1]。 |
| ARM-PDF-02 | MMU-Chapter 19 MMU Performance Optimization Techniques.pdf，第5页、19.4节 | 48-bit VA、4KB granule跳过L0，只需L1–L3 | 常规配置覆盖完整48-bit VA需四级L0–L3；每级9位索引加12位页内偏移，四级为48位，三级为39位。不能把某条block提前终止的walk等同于省去根级。见[S2]。 |
| ARM-PDF-03 | Memory Barrier/ARM64 Memory Barriers..pdf，第8页、5.1节 | DC CVAU后直接IC IVAU，遗漏两者之间的完成屏障 | 通用单核代码同步顺序为DC CVAU → DSB ISH → IC IVAU → DSB ISH → ISB。实际代码需覆盖全部相关cache line；IDC/DIC特性可改变维护需求，多核还需另外同步，不能泛化为任意场景配方。见[S3]。 |
| ARM-PDF-04 | ARMInterruptExceptionWorkflow.pdf，第1、3页 | 声称FIQ仅属于GICv2 | GICv3也支持FIQ；分组、安全状态、异常级与路由配置影响IRQ/FIQ行为。不能以该简化流程代替GICv3规则。见[S4]。 |

一手核对来源（实际阅读日期2026-09-28；在线分支可能变化，正式课程需再固定对应版本）：

- [S1：Linux ARM64 pgtable-hwdef.h](https://github.com/torvalds/linux/blob/master/arch/arm64/include/asm/pgtable-hwdef.h)，table descriptor权限位宏。
- [S2：Linux AArch64 Memory Layout](https://docs.kernel.org/arch/arm64/memory.html)，4KB页的39/48位地址与三级/四级关系。
- [S3：Arm官方实现clear-cache说明](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/caches-self-modifying-code-implementing-clear-cache)，单核维护序列及IDC/DIC条件。
- [S4：Arm GICv3/v4 Software Overview](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/GICv3_v4_overview.pdf?revision=65f91645-cd52-4795-952b-f01095ff5ef8)，第15页中断分组与IRQ/FIQ映射。

另外，ISB与预测器状态、Stage-2固定两倍开销、通用DMA/cache操作配方等表述需要单独审查；这里不把它们列为完成核验的勘误。涉及Linux DMA时必须读[DMA API指南](https://docs.kernel.org/core-api/dma-api-howto.html)，区分一致性、顺序、地址映射、传输方向和所有权，不能直接套PDF汇编配方。

## 就业阅读优先级

维持“C++/Linux工程 → 推理正确性与稳定性 → 性能分析 → ARM优化”的主线。这套资料主要补充体系结构机制，不替代Linux调试、NEON、PMU、可编译代码和端到端推理项目。

| 顺序 | 资料范围（均需核对） | 学习目标与工程连接 |
| --- | --- | --- |
| 先学 | OS进程/虚拟内存基础，再用第1/2/3/5/6/8章做概念索引 | 区分VA/PA、页表、TLB、Cache、进程隔离；解释模型首次访问和工作集问题 |
| 随相关课深入 | 第15/16章，随后第9/17/18章与已纠正的屏障资料 | 区分内存类型、一致性与顺序；联系共享缓冲区生命周期与CPU–设备同步 |
| 有测量问题时查 | 第19/26/27章及故障专题 | 先获得Linux/板端真实计数器和时序证据，再解释瓶颈；资料中的工具名称不等于目标平台已存在可用命令 |
| 暂缓系统展开 | Stage-2、复杂虚拟化、EL3启动、QNX专属实现 | 明确走BSP/驱动/Hypervisor岗位或实际项目需要时，再核对版本后深入 |

章节顺序只约束参考资料选读，本地PDF本身不另开每日栏目或重排既有ARM28课；另由用户授权新增的[OS栏目](../os/README.md)承接系统机制。保持每天5–10分钟ARM小课、一个20–30分钟主编码练习和一个无答案自测；不要求逐日读完551页，不增加必做作业。每次规划调整不推进游标，不把概念阅读标成实板或源码项目完成。
