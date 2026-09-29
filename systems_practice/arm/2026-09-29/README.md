# 2026-09-29 ARM 07：先确认A64依赖链，再公平测量

## ARM问题与前置

承接06的编译选项，复用04的一链/四链无符号累加。**同为A64的ADD循环，为什么一次计时不足以证明四链更快？** 本节5–10分钟：看真实寄存器依赖，理解计时边界和分布。工业背景是ROCK 5B/RK3588的CPU特征归约（Cortex-A76/A55对照），本机Mac只验证A64形态与测量方法，不证明Cortex吞吐。

## 数据怎样变化

| 版本 | 输入示例 | 寄存器中的状态演化 | 最后结果 |
| --- | --- | --- | --- |
| serial | 1,2,3,4 | 一条累加链：0→1→3→6→10 | 10 |
| four | 同上 | 四个独立累加器：1/2/3/4，再合并 | 10 |

这是示意；实际使用uint64按模2^64求和，N=4096、32KiB工作集。依赖链和ILP是通用CPU原理；下面的X寄存器、LDR/LDP及分支形态才是本课的AArch64具体证据。

## 代码与实际指令

[src/kernels.cpp](src/kernels.cpp)与计时主体独立编译、不启用LTO；关闭自动向量化和循环展开，避免编译器把对照变成另一种实验。[首次真实日志](results/initial.txt)展示：

```asm
; serial循环的实际输出节选
ldr x9, [x0], #8
add x8, x9, x8
subs x1, x1, #1
b.ne LBB0_1
; four循环的实际输出节选
ldp x14, x15, [x12, #-16]
add x8, x14, x8
add x10, x15, x10
ldp x14, x15, [x12], #32
add x11, x14, x11
add x9, x15, x9
```

`LDR`取8字节并后增指针，`ADD x8,...,x8`读取上轮x8，形成循环携带依赖；`SUBS`更新计数与条件标志。四链把累加依赖分在x8/x10/x11/x9，`LDP`每次取两个64位值；最后三个ADD合并。LDP存在不意味着一次周期取完，更不能凭它推算A55/A76速度。这里没有NEON算术，下一节才学习自动向量化。

## 已写好的公平对照

```sh
sh systems_practice/arm/2026-09-29/run.sh
```

脚本直接打印内核汇编并运行Release与Sanitizer。两版本同输入/精度/边界，20组预热，101组样本，每组128次调用，交替执行顺序；构造输入在计时外，批次结果写入volatile观察点。独立编译单元确保编译器不能把跨调用求和外提，仍需看实际汇编确认形态。墙钟计时包含调用与内核，不包括打印、输入生成、最后观察写入；线程CPU时间包住同一批次且多含两次读时钟开销，不能逐样本相减来精确测调度延迟。

首次Release实测serial墙钟P50/P95=1.73991/2.24088µs，four=0.679039/0.820969µs；线程CPU P50分别1.74121/0.680664µs。只说明本次Mac、热工作集、此编译结果的分布。格式化后的权威复测另存[final.txt](results/final.txt)，最终Release墙钟P50/P95：serial=1.74544/2.22298µs，four=0.663734/0.839195µs。数据可能因系统负载变化。Sanitizer时间不用于收益评价。1025种长度（含空输入/尾部/模溢出）两版本一致。

## 工程故障与岗位用途

频率/迁核、后台线程、缓存状态变化会令单次样本倒序；先保留编译参数、实际指令和P95，再在板端同一已识别核心上复测。实际目标命令：

```sh
cat /proc/device-tree/model
uname -a
cat /etc/os-release
lscpu -e
cat /proc/cpuinfo
# 读拓扑后由操作者选定实际CPU_ID；不假定编号对应大核。
: "${CPU_ID:?Choose a CPU after topology inspection}"
taskset -c "$CPU_ID" sh systems_practice/arm/2026-09-29/run.sh
```

以上需板端已安装clang，脚本不安装。先记录CPU型号、内核、频率/热状态；仅看`taskset`不能证明频率固定。岗位能力是把CPU热点、编译器产物与可复现测量连起来，为推理前后处理优化留下可审查证据。本课不涉及PMU事件，也不硬编码事件或流水线周期。

## 来源、验证与下一节

2026-09-29实际阅读[LLVM Auto-Vectorization](https://llvm.org/docs/Vectorizers.html)的Loop/SLP、禁用标志和归约说明；代码沿用本仓库[04课](../2026-09-25/README.md)独立实现，新增公平基准，不声称改编了未读的ggml/ncnn源码。基础基准课以官方编译器资料和实际生成指令为证据。Apple clang21，arm64-apple-darwin25.6.0，Mac Release/ASan/UBSan均通过；完整汇编[arm64.s](results/arm64.s)。未验证ROCK5B、A55/A76、Thor CPU或GPU/NPU性能，软件版本仅本机已核实。本地PDF目录主要是MMU/屏障，与本课无直接关系，本节不新增PDF阅读声称。

下一节08：自动向量化，用编译器诊断连接标量循环与NEON。
