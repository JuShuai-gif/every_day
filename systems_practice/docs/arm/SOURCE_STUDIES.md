# ARM 旧课源码研读：从博客里的快，走到工程上可信

读取日期：2026-09-29。按用户要求，实际使用 Google 检索 `ARM NEON GEMM 优化 site:zhihu.com`，打开知乎原作者文章，再追到 GitHub 具体实现；另读 Arm 官方作者的调度案例、成熟字符串例程及其 benchmark。以下是本轮真正读过的资料，不是待阅读书单。08及以后的学习游标没有推进。

## 先读哪几份，分别解决什么问题

| 原始资料 | 本次实际阅读范围 | 采用价值与边界 |
| --- | --- | --- |
| [BBuf：基于how-to-optimize-gemm初探矩阵乘法优化，知乎，2020-11-02](https://zhuanlan.zhihu.com/p/272208879) | 正文1–7节：行主序、AddDot、寄存器分块、NEON、cache分块、packing；不是只读搜索摘要 | 建立逐步优化路线；历史ARMv7/A53实验不外推为本机或新CPU收益。下面用独立反例核查接口，不照抄教程结论。 |
| [BBuf/how-to-optimize-gemm](https://github.com/BBuf/how-to-optimize-gemm) | 固定提交 `2cd87c4b462baed8e0c896fc34f272604ee4894b` 的 `armv7a/src/MMult1.h`、`MMult_4x4_13.h`、`test_matrix_multiply.cpp` 全文；MMult1另核对master | 教学项目：AddDot → MY_MMult；MY_MMult_4x4_13 → InnerKernel → PackMatrixA/B → AddDot4x4。分析其合同、复用与测试盲区；不把教学仓库冒充生产级库。所读文件无许可头，根目录未见LICENSE，许可未确认，因此不复制实现。 |
| [Arm：Coding for Neon – Part 3: Matrix Multiplication，2013-09-11](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/coding-for-neon---part-3-matrix-multiplication) | Algorithm、Floating/Fixed Point、Scheduling、内嵌 `matrix_asm_sched.s` 的 `matrix_mul_float`/`matrix_mul_fixed` | 原作者的4×4列主序图形变换与独立累加器调度案例。文中为AArch32，不是本课A64；作者Cortex-A8历史加速不能作为本机实测。保留依赖图思路，不搬汇编或固定点性能结论。 |
| [ARM-software/optimized-routines：memcpy.S](https://github.com/ARM-software/optimized-routines/blob/master/string/aarch64/memcpy.S) | master，读取2026-09-29；`__memcpy_aarch64`/别名入口、copy16/copy8/copy4、copy32_128、copy_long、loop64及逆向路径 | 成熟实现的尺寸分派、W/X宽度、无栈叶函数、head/tail和软件流水。文件许可 `MIT OR Apache-2.0 WITH LLVM-exception`；仅阅读分析，不替换本机libc。精确commit本轮未取得，分支链接不是永久链接。 |
| [同仓库：string/bench/memcpy.c](https://github.com/ARM-software/optimized-routines/blob/master/string/bench/memcpy.c) | master，读取2026-09-29；init_copy_distribution、init_copies、memcpy_random、memcpy_medium/large、重叠测试入口 | 原项目按尺寸/对齐/工作集组织的真实benchmark设计，许可同上。借鉴采样维度，不把其SPEC分布当作自己的业务分布。未编译运行上游。 |

文章旧链接 `https://github.com/BBuf/ArmNeonOptimization/blob/master/optimize_gemm/MMult_4x4_13.h` 本轮浏览器确认404；在作者后续资料中找到上述独立仓库并成功阅读固定提交。这里只说“找到可读后续实现”，不推断仓库正式迁移历史。部分raw地址抓取返回Cache miss，改用GitHub文件页读取成功；Cache miss不等于源文件不存在。Arm来源网页/raw可读，不宣称完成本地clone。

## 案例A：为什么通过Sanitizer和方阵测试，ROI推理仍会错

固定来源：[MMult1.h](https://github.com/BBuf/how-to-optimize-gemm/blob/2cd87c4b462baed8e0c896fc34f272604ee4894b/armv7a/src/MMult1.h)。`MY_MMult1`传给`AddDot`的步幅是`lda`，而`AddDot`用它索引`y`（B的一列）。按文件的行主序宏，沿B的K维步进必须用`ldb`。这不是浮点容差问题。

下面是独立推导的最小输入，A为2×3、B为3×2，行步幅单位都是**元素**：

```text
A，lda=5                 B，ldb=4
[1 2 3 pad pad]          [7  8  pad pad]
[4 5 6 pad pad]          [9 10  pad pad]
                        [11 12 pad pad]
```

设padding=1000。正确C00读取B的物理下标0、4、8，得到 `1×7+2×9+3×11=58`；错误候选读取0、5、10，得到 `1×7+2×10+3×1000=3027`。下标10仍在B的12个已分配元素内：ASan不报越界很合理，问题是逻辑合同错。不要为了“让ASan抓住它”偷偷缩短缓冲区，那会掩盖真实失效模式。

已写好[反例与运行说明](../../arm/2026-09-24/source-study/README.md)：正确值`[58,64,139,154]`，错误值`[3027,5008,6078,11032]`；另有等步幅方阵对照，错误候选也通过。程序独立C++17、vector RAII、显式检查与非零失败码，不是上游API移植或性能内核。

对应故障链：摄像头ROI/SDK对齐使A、B stride不同 → 只在部分尺寸数值异常 → 记录shape、元素/字节步幅和前两行实际地址 → 用毒化padding和独立oracle区分“量化误差”与“读错元素” → 修正接口、保留非等步幅回归。上线时还要测零维、非4倍数、非零初始C、允许/禁止的alias、溢出与容量；这里的反例没有证明完整GEMM实现正确。

## 案例B：packing究竟改变什么，为什么核内变快还可能总耗时更慢

固定来源：[MMult_4x4_13.h](https://github.com/BBuf/how-to-optimize-gemm/blob/2cd87c4b462baed8e0c896fc34f272604ee4894b/armv7a/src/MMult_4x4_13.h)。读代码时沿下面的数据流追踪，不只看最后的NEON intrinsic：

```text
原始A按行存储 → PackMatrixA按每个p收集四行 → [A0p,A1p,A2p,A3p]
原始B按行存储 → PackMatrixB复制每行四列   → [Bp0,Bp1,Bp2,Bp3]
                                  ↓
        AddDot4x4：四个结果行向量，各沿p累加，结束后加回原C
```

这里四个累加器表示四个**输出行**，并非把同一个点积拆四份。保留每个输出元素自身的K次序，也给调度器独立工作；FP乘加是否融合仍需检查目标编译结果。不能用本课uint64模加法的“任意重排完全等价”去证明FP版本位级相同。

**独立算账例子**：一个4×4 tile、K=128，按乘与加各算一次共4096 FLOP。核内读取packed A/B各512个FP32，共4096B；读写16个C再加128B，逻辑算术强度约`4096/4224=0.970 FLOP/B`。这只是该tile接口流量模型，不是DRAM实测。如果仅为一次tile另外打包A/B，读取原值与写packed数组又产生8192B逻辑流量，总模型降为`4096/12416≈0.330 FLOP/B`。但若packed面板跨很多tile复用，这笔成本会摊薄，因此必须确认复用作用域。

源码中A在`j==0`时pack；B在每次InnerKernel调用内pack，而外层按M块再次调用InnerKernel。评审时要标出“复用跨哪些循环”，不能笼统写“只打包一次”。固定mc/kc只是这个实现的选择，不是所有CPU最佳值。还要面对：4步长循环未见通用M/N尾块；运行期大小栈数组不符合严格标准C++17；大面板的栈容量；分配/packing计时和线程共享策略。这些是移植工作清单，不是说本轮已交付修复后的通用GEMM。

量产决策用已定义边界的测量：`T总=T分配+Tpack+Tkernel+T边界+T同步`。若权重常驻可重复使用，另报告首帧和稳态；若每帧activation变化，就不能把activation打包摊到无限次。反转成立条件要用实际K次复用与`Tpack/(Tdirect−Tpacked)`阈值判断，并记录负收益。不要直接沿用上面逻辑FLOP/B预测cache miss或加速比。

## 案例C：成熟汇编为什么不从头到尾只用一种宽度

读Arm `memcpy.S`，先看尺寸分派，再看寄存器和控制流。小尺寸用端点覆盖，中大尺寸换更宽加载，长循环用已加载寄存器交错存储/下一批加载。该实现不要求用NEON才算优化；固定宽度、入口成本与重叠处理共同决定设计。对原函数的说明以[源码](https://github.com/ARM-software/optimized-routines/blob/master/string/aarch64/memcpy.S)为准。

**独立区间证明**：若复制长度n∈[16,32]，先读源区间`[0,16)`和`[n−16,n)`，它们的并集覆盖`[0,n)`且都不越界；n=24时重复读8B，不等于超读8B。源数据先全部进入寄存器，之后才写，才有机会安全处理这段范围的重叠。若把加载/存储随意交错，dst=src+8就可能先破坏尚未读取的源。这个证明只覆盖所列小尺寸策略，不能自动证明完整长循环。

**接口边界**：底层实现兼容memmove，不代表调用C++ `std::memcpy`时允许重叠；编译器可依据接口语义优化。业务重叠复制使用memmove，不能依赖某版libc偶然容忍。反汇编的“我看见它能处理”不能推翻源语言合同。

**连接本课ABI**：对照09-26有跨调用活值的例子，检查这里没有`bl`、不建普通栈帧、保持返回地址与返回值所需状态。这给出评审顺序：先列活值和调用边界，再讨论保存寄存器，最后才谈帧大小。不要以“手写汇编/leaf”推断任何代码都可省栈或任意改寄存器。长循环的快慢仍须目标CPU测量；本轮只读了上游，没有运行或测得其周期。

## 案例D：两个真实benchmark，两个完全不同的“快”

[BBuf测试入口](https://github.com/BBuf/how-to-optimize-gemm/blob/2cd87c4b462baed8e0c896fc34f272604ee4894b/armv7a/src/test_matrix_multiply.cpp)取40递增的方阵、等步幅、20次中的最短时间；默认测试4x4_13而非MMult1。错误差值分支调用`exit(0)`，因此仅看退出码不能判定正确。后一点为静态阅读发现，本轮未执行上游错误分支。该测试适合观察理想形状的历史演进，不足以给生产SLA验收。

[Arm memcpy benchmark](https://github.com/ARM-software/optimized-routines/blob/master/string/bench/memcpy.c)实际包含尺寸/对齐分布、不同working set及准备后的预热。值得借鉴的是**输入总体的定义**：你的生产流量是什么，测试就该覆盖什么，而不是照抄别人的分布或只挑最快尺寸。上游计时/实现选择和CPU扩展还需在移植时按其构建框架核查，本轮未验证全部RUN宏和运行时分派。

对09-29现有基准的直接约束：4096×uint64=32KiB、20预热、101个样本，每个样本128调用的均值。因此只能写“该固定热数据场景的批均值分位数”；它没有提供每次调用尾延迟、冷启动或大working set结论。后续扩展时将样本按N/对齐/冷热/并发分组，再分开测kernel和请求E2E；现有入口未增加这些参数，不提供看似可跑的虚假CLI。

**独立统计反例**：两个等字节任务速度分别1和9 GB/s。总体速度不是算术均值5，而是`2/(1/1+1/9)=1.8 GB/s`。正确汇总是总字节/总时间；对延迟分位数则要保留原始样本与样本单位，不平均各组P95。阶段吞吐、端到端延迟和最低单次时间回答不同问题。

## 如何融入全部旧课

| 旧课 | 本次回补后要能做的事 | 阅读定位 |
| --- | --- | --- |
| [01 目标能力](../../arm/2026-09-22/README.md) | 遇到ARM博客先识别A32/A64、数据布局与目标CPU，不直接搬编译命令 | Arm博客与memcpy文件前提 |
| [02 寄存器](../../arm/2026-09-23/README.md) | 用访问宽度、对象边界说明W/X选择，而不是只背清零规则 | memcpy小尺寸分支 |
| [03 寻址](../../arm/2026-09-24/README.md) | 从shape/stride构造能击穿错误索引的oracle | 案例A与现成反例 |
| [04 依赖链](../../arm/2026-09-25/README.md) | 分清独立累加器、指令调度与软件流水，控制归因 | Arm Scheduling、案例B/C |
| [05 ABI](../../arm/2026-09-26/README.md) | 解释一个函数为何需要保存，另一个为何没有相同帧 | memcpy叶函数对照 |
| [06 编译观察](../../arm/2026-09-27/README.md) | 区分自动向量化、intrinsics与汇编；诊断只作用于对应层 | AddDot4x4与现有LLVM诊断 |
| [03补充 ROI](../../arm/2026-09-28/README.md) | 追踪packing顺序、复用边界和成本，不只换成连续buffer | 案例B |
| [07 基准](../../arm/2026-09-29/README.md) | 对输入分布、退出码、统计量、计时边界做benchmark评审 | 案例D |

## 本轮交付与验证边界

Google检索、知乎正文、GitHub上述具体文件均实际读取；BBuf三个文件固定提交，Arm两个文件按分支/日期记录。新反例属于**受问题启发的独立实现**；原课程代码保持，本轮不复制上游实现、不声称运行上游GEMM或libc。反例Release与ASan/UBSan结果见其README与文本日志。Linux/具体Cortex/Neoverse实板、上游性能、PMU/能耗/E2E均未验证。未下载模型、安装依赖或改变CUDA Thor SM110目标。

资料的价值要落实为可解释的机制、可触发的反例、可核对的证据。以后每课按同一方式挑少量原作者资料，正文指出读者应看哪段代码、采用什么、什么条件下失效；不能靠资料数量、博客中的峰值或一段PASS增加“深度”。
