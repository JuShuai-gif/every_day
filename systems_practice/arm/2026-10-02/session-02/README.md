# ARM第10课：FMA不等于逐位相同——浮点归约的精度合同

本日正式小课，接第09课尾部处理。前面并发游标产生的[尾部补充](../README.md)保留，不计第二课。岗位能力第3层：给机器人视觉embedding相似度点积建立精度回归；输入为等长FP32向量、n≤4096、有限且绝对值≤1e10，本课已测n=0…257。现成阅读，无附加必做任务。

## 先看数据如何变化

融合运算只在乘加结束时舍入；非融合先舍入乘积再加。取a=1+2^-23、b=1-2^-23、c=-1，精确乘积1-2^-46，非融合FP32乘积先变成1，最终0；FMA保留-2^-46。它是通用浮点语义，不是“ARM随机误差”。

| 同一组乘积 | 累加安排 | 本机真实结果 |
| --- | --- | --- |
| [1e8,1,-1e8,1] | 标量从左到右 | 1 |
| 同上 | NEON四lane后树状加和 | 0 |
| 同上 | double参考 | 2 |

向量化既改变每lane依赖链也改变横向相加顺序。FMA可以降低单次舍入误差，但不能解决归约的病态抵消，不能把“更快”“误差更小”“逐位一致”混成同一验收。

## 已读源码与机制

[ggml仓库](https://github.com/ggml-org/ggml)，master，读取2026-10-02，commit未固定，MIT许可。实际读[src/ggml-cpu/vec.cpp](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/vec.cpp)的`ggml_vec_dot_f32`和[simd-mappings.h](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/simd-mappings.h)的NEON F32宏：点积→多个向量累加→向量加和→横向归约→标量尾部。保留`vfmaq_f32`与`vaddvq_f32`两个机制；省略ggml调度、多个累加器、其他ISA和张量图。本例独立实现，未改编上游函数或复现其性能。

源码的架构宏分支提醒我们：不同构建路径可能改变数值顺序。不要把某次生成汇编推广为所有ggml版本。本次Mac编译是独立例子，不是编译了ggml。

本次于2026-10-02实际尝试[Google检索](https://www.google.com/search?q=CUDA+transpose+stride+bank+conflict+FP32+FMA+noexcept+vector+xv6+kalloc)和[知乎检索](https://www.zhihu.com/search?type=content&q=FMA%20vector%20noexcept%20kalloc)，均返回Internal Error，未读到文章正文。以下技术依据来自实际取得的GitHub实现和官方资料，不把检索摘要算源码阅读。

读过本项目[本地资料规则](../../../docs/arm/LOCAL_LIBRARY.md)；该资料主要为MMU/屏障，没有将其当作本课FMA实现依据，本次未重新读取PDF，不声称新的PDF页验证。

## 代码与真实指令对应

[src/example.cpp](src/example.cpp)提供scalar/fused/neon三个noinline入口。编译`-ffp-contract=off`且关闭自动向量化：scalar显式保留乘与加，`std::fma`和NEON intrinsic仍明确要求融合。真实[host-arm64.s](results/host-arm64.s)可搜索符号：scalar循环是`fmul`接`fadd`；fused用`fmadd`；neon用`fmla.4s`及两级`faddp`。操作数是128位V寄存器里的四个FP32，最终横向归约成S寄存器；尾部走标量FMA。没有声称这些指令固定需要多少周期。

数据依赖图：连续加载→四lane乘加→同lane下一轮依赖→横向合并→尾部。向量累加增加并行机会，收尾仍串行；很短向量可能没有收益。本课测数值不测性能，没有P50/P95或板端收益数字。

## 已写好的对照和结果

```sh
cd systems_practice/arm/2026-10-02/session-02
sh run.sh
rg -n 'fmla|faddp|fmadd|fmul|fadd' results/host-arm64.s
```

Apple clang21、arm64-apple-darwin，Release和ASan/UBSan均通过774次（258长度×3路径）；最大绝对误差8.38486e-7。验证容限`1e-6+4*(n+1)*epsilon*sum(abs(a*b))`是本教学工作集的保守合同，不是假称任意求和的严密最优误差界。抵消例单独展示相对误差为何不稳定。Inf、NaN、越量程三类被拒绝。原始[run.txt](results/run.txt)保存所有输出；真实FMA反例为0对-1.42109e-14。

## 两条排障链与采用条件

1. 向量化后单测“相等”失败→假设索引错误或舍入顺序改变→先用整型可精确输入查索引，再固定FMA合同并与double绝对误差比→使用abs+规模相关容限；代价是容限设计需结合模型最终阈值。不能随意放宽到把错地址吞掉。
2. 大小量抵消导致余弦相似度排序变动→聚合误差放大→记录sumAbs、参考量级与分类边界，检查融合/归约差别→必要时FP64累加或补偿和，接受额外成本。仅有FMA指令不能证明误差被解决。
3. 输入溢出/NaN向下传播→输出无效却通过宽容比较→先检查finite与量程，失败显式返回；本例拒绝值并未执行溢出运算。

迁移到ROCK5B/RK3588或AGX Thor的**CPU**时：固定AArch64/Linux编译器与sysroot、确认ABI和动态库；重跑三路径、n=0/尾部/抵消/非有限合同，保存实际汇编。Mac Mach-O不能直接复制运行。Linux示例命令（工具链已存在时）：`aarch64-linux-gnu-g++ -std=c++17 -O2 -ffp-contract=off -fno-tree-vectorize src/example.cpp -o build/linux-example`；交叉库/sysroot按设备配置，不在本机执行或安装。未测Linux、板端CPU、PMU、功耗、长时间稳定性；无模型任务精度或E2E收益时不替换生产算子。完整部署闭环仍缺目标板与模型回归。

## 面试追问与下一节

FMA减少了哪次舍入？为什么横向归约改变数值？sumAbs与最终和的比值说明什么？关闭fast-math能保证标量与SIMD逐位一致吗？空向量和NaN如何定义合同？什么时候值得付出FP64累加成本？

下一节为第11课，继续按[课程表](../../curriculum.json)推进；本课不额外安排自测。

[格式化后最终验证](results/final-run.txt)再次通过，保留先前结果。
