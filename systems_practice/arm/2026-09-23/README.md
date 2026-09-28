# 2026-09-23 · ARM第02节：X/W与V寄存器

上一节区分了ISA、CPU和编译目标；今天只认识操作数。参照ROCK 5B/RK3588上CPU后处理：维护64位帧序号，同时对四个UINT32计数器做批量加法。Radxa[板卡介绍](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)今日核实为4×Cortex-A76+4×Cortex-A55；实际板上OS/核拓扑/SDK未取得。本机Mac用于检查A64语义，不代表这些Cortex核的性能。

X0–X30是64位通用寄存器；W0–W30是其低32位视图，写W会清零同编号X的高32位。V0–V31是另一组128位SIMD/浮点寄存器，`v0.4s`表示四个32位lane，`s0/d0/q0`是同一个寄存器的不同访问视图。不要把W误当独立于X的存储，也不要把lane数当CPU核心数。来源为Arm [Instruction Set Architecture Issue1.1 §6](https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20Instruction%20Set%20Architecture.pdf)及[AAPCS64 Machine Registers](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst)，读取2026-09-23。本课不延伸到完整ABI，Apple与Linux调用约定差异留后续课。

[registers.cpp](src/registers.cpp)是独立C++17例子：inline A64 `mov %w0,%w1`之后按64位返回；NEON `vaddq_u32`读取四lane并写出。前者避免只靠C++截断推断指令，后者让编译器分配向量寄存器。没有用截断后的整数构造真实地址。

```sh
./systems_practice/arm/2026-09-23/run.sh
# Linux AArch64板端：先记录实际平台，再原生编译运行。
uname -a
lscpu
cat /etc/os-release
CXX=g++ ./systems_practice/arm/2026-09-23/run.sh
```

Mac实际输出：[cpu.txt](results/cpu.txt)。`0xffff000012345678 → 0x12345678`，全1输入变成`0xffffffff`；向量结果`11,22,33,0`，最后一项是UINT32模2^32加法，不是饱和。3个X/W样本与4个lane检查通过。[真实汇编](results/registers.s)显示`mov w0,w0`与`add.4s`。误将64位帧号保存到W路径会丢高位；若是地址则可能破坏访问，诊断先看操作数宽度，不能只看十六进制低位相同。

未测性能、未运行RK3588/Jetson，未检查NPU或GPU；没有增加必做编码任务。下一节：**03 加载/存储、地址与stride**，将这些寄存器连接到图像/张量内存。来源与验证范围见下文。

## 来源与验证

来源读取于2026-09-23：上述Arm ISA文档Issue1.1（2020-07）§6.1/6.2、AAPCS64 main的通用/SIMD/浮点寄存器章节，以及Radxa产品规格。本例为独立实现，无上游代码复制。Mac C++17程序已编译运行，3个X/W样本及4个lane检查通过并生成汇编；未测性能，目标板OS/SDK及运行情况未验证。
