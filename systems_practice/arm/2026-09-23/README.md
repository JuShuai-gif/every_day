# 2026-09-23 · ARM第02节：X/W与V寄存器

> 2026-09-29 深度回补：下文新增机制推导与工作排障。原始源码、运行日期和日志保留；5–10分钟仅指前部速览，深入正文不受该篇幅限制。

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


## 工程深入：位宽、lane与计算合同

**工作目标**：审查一段计数/索引/向量代码时，分清截断、零扩展、符号解释与溢出策略。`write_w`的输入是64位，inline asm把操作数指定成W视图，输出变量仍是64位；因此观察的是一次真实W写入后X的内容，不仅是C++强转。`0xffff000012345678`写W后变成`0x0000000012345678`，高位丢失发生在指令语义层。不能把“低位数值相同”当作帧号或地址保持完整的证明。

位图按数值权重读，不是内存字节序图。W/X的重叠也不意味着V与X共享同一数据：通用寄存器与SIMD寄存器是不同组，跨组转移和类型数值转换是两个问题。先在汇编里读操作数名字，再判断宽度；看到`add`不能只按助记符推断是64位标量还是4×32位向量。

`add_lanes`输入各4个uint32，输出也4个uint32。第i个lane的合同是`out[i]=(x[i]+y[i]) mod 2^32`；lane之间没有进位传播。最后一个输入UINT32_MAX与1相加得到0，不是夹到最大值。若业务需要饱和，或需要精确统计值，就必须改合同：选择经过核实的饱和操作，或者先扩宽再计算，而不是先32位相加再转64位。先窄位相加丢掉的进位无法靠扩大输出变量补回。

### 为什么“四路”不等于“四倍快”

这段操作对4个输出进行4次整数加法，逻辑输入32字节、输出16字节，共48字节，算术强度按逻辑流量只有4/48次整数加法每字节。这个量是分析模型，不是DRAM总线实测；写分配、缓存复用和调用开销会改变真实代价。四lane减少的是表达这些加法所需的部分指令，端到端仍包含加载、存储和函数调用。实际生成代码需定位`add_lanes`而不是iostream附近的SIMD指令：

```sh
sh systems_practice/arm/2026-09-23/run.sh
sed -n '/^_add_lanes:/,/cfi_endproc/p' systems_practice/arm/2026-09-23/build/registers.s
sed -n '/^_write_w:/,/cfi_endproc/p' systems_practice/arm/2026-09-23/build/registers.s
```

以上函数标签适用于本机Darwin输出；Linux可能没有前导下划线。本例只有4元素功能观察，没有吞吐基准，不能从48字节模型推出速度。2026-09-29实际复核[Arm intrinsic表](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)中`vaddq_u32`→`ADD Vd.4S,Vn.4S,Vm.4S`，没有复制上游实现。

| 工作症状 | 先看哪条证据 | 修复和回归 |
| --- | --- | --- |
| 计数超过32位后突然归零 | W/X宽度、输入是否已被截断、上界样例 | 选择64位合同并检查全链路类型；本课不承诺更高性能 |
| 向量结果末项为0，被误判坏数据 | 用MAX+1检查是否模加法，与业务饱和语义比对 | 明确回绕/饱和/扩宽选择，重建正确性oracle |
| 换成3元素缓冲区后越界 | intrinsic每次仍读取4lane | 本接口要求完整4元素；通用尾部处理留09课，不能靠页内可读侥幸过关 |

### 迁移验收与读后能力

检查输入输出各有4个合法uint32对象、指针寿命覆盖调用、访问满足C++对象/对齐要求；“硬件可能容忍非对齐”不是随意把byte缓冲区转成对象指针的许可。现有测试验证3个位宽输入与4个lane，未覆盖一般重叠/尾部接口，也未测性能。上线替换应同时固定结果位宽、溢出语义与范围，不只验证一组正小数。

面试追问：1. 写W与只读W有何区别？2. 4s里的4与32位分别描述什么？3. uint64接收变量为何补不回已丢进位？4. 模加法与饱和加法适合什么业务？5. 为什么四lane不等于四倍吞吐？6. 固定4元素例子如何限制调用者的尾部行为？

### 2026-09-29深化复验

本机寄存器/NEON观察编译运行通过，未新增Sanitizer或性能验收。[本次完整输出](results/hpc-review-20260929.txt)。原有日志与源码保持原字节，本次只增补文档和新结果。为核对入口完整性，多个课程构建并行执行；07课此次输出中的时间受并行任务干扰，仅作正确性复验，不用于新的性能收益结论。未验证Linux perf、目标板、温控或实际业务E2E。
