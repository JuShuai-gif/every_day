# 2026-10-19 ARM 第25课：编译特性与运行时能力分派

## 1. 5–10分钟速览

承接24图像融合，今天解决“同一CPU算子包能否安全部署到不同AArch64板”。工作能力层为部署及正确性：编译器接受SDOT不等于当前OS允许执行；必须把带扩展的函数单独编译，再由基础代码查询能力、选择路径。示例比较INT8点积的标量、NEON扩宽、DotProd三条实际路径，不以机器品牌推断指令能力。i8mm/SVE/SVE2只查询和说明，未交付相应矩阵/可伸缩向量内核。

## 2. 板端问题、输入与机制

部署参照ROCK 5B/RK3588的A76/A55、Orin的A78AE与Thor T5000的Neoverse-V3AE；对应关系承接[已核实板卡说明](../../docs/arm/BOARDS.md)，今天没有连接板卡，OS/SDK/实际HWCAP均未知。CUDA的sm_110与CPU扩展是两套命名，不能混为一谈。

工作输入是两个等长INT8向量，N=0..65536；返回精确int64点积。NEON/DotProd内部int32累加，最坏总值65536×128×128=2^30，所以归约也安全。超过上界拒绝，而不是等溢出发生。实际服务更长K应分段累加到int64，并重新测量。

| 编译/运行/实现三要素 | 示例动作 | 缺失时 |
| --- | --- | --- |
| 基础对象仅armv8-a | main.cpp与分派器不启用dotprod | 避免检测前已执行扩展 |
| 可选对象单独armv8.2-a+dotprod | dot.cpp包含真实vdotq_s32 | 若编译器不支持则构建失败；不伪造回退 |
| OS允许能力 | Linux getauxval；Mac sysctlbyname | 查询失败保守false并记录errno |
| 对应内核存在 | 只为neon/dot注册函数指针 | i8mm=true也不能选不存在的实现 |

Linux使用AT_HWCAP的ASIMD/ASIMDDP/SVE与AT_HWCAP2的I8MM/SVE2；头文件没有新宏意味着本程序没有该查询实现，并不证明硬件缺能力。SVE还需匹配向量长度与调用约定，SVE2不等于i8mm；这两个能力不是一个层层递增的简单等级。

## 3. 代码、指令与状态变化

[src/main.cpp](src/main.cpp)的`capabilities→choose→run`分别负责查询、纯策略和shape/累加界限；假的Caps只用于检查choose返回指针，绝不据此调用扩展。`choose(c,true)`为强制标量；真实c支持时执行对应路径。独立dot翻译单元不使用LTO，防止扩展跨边界传播。基础标量循环关闭自动向量化，NEON为真实intrinsics。

已生成[base-kernels.s](results/base-kernels.s)、[dot.s](results/dot.s)，来自Apple clang21、Release参数，与手写示意不同：

```asm
smull.8h  v3, v1, v2
sadalp.4s v0, v3
smull2.8h v1, v1, v2
sadalp.4s v0, v1
```

先把16个s8乘积分低/高8项扩为s16，再成对扩为s32累计，避免s16总和溢出。dot对象实际出现：

```asm
sdot.4s v0, v1, v2
addv.4s s0, v0
```

每条SDOT把16个乘积分为四组，每组4项加到一个s32 lane；ADDV最终归约。长度17时前16进入向量，最后1进入标量，不读越界。SMULL/SADALP与SDOT指令条数不同，但没有实测吞吐/周期，不据此承诺加速。

## 4. 现成对照与观察命令

```sh
sh systems_practice/arm/2026-10-19/run.sh
MODE=sanitize sh systems_practice/arm/2026-10-19/run.sh
# 工作目录切到本课后查看生成代码
rg -n 'sdot|smull|sadalp|addv' build/release/base.s build/release/dot.s
# Linux AArch64实际目标，clang++和目标头文件须已存在
CXX=clang++ sh systems_practice/arm/2026-10-19/run.sh
```

16组输入：0/1/15/16/17/31/33/65536，各含确定性混合值与全-128；标量是独立oracle，支持路径逐项精确一致。2条拒绝覆盖异长/超长；3个纯分派判断覆盖全缺、仅NEON、强制基础。`hw.optional.neon`本机沙箱查询errno1，而DotProd和I8MM可查为1；真实DotProd意味着具备NEON执行基础，因此同批也核对显式NEON。**查询不可用与硬件不存在必须区分**。本例不测性能，以兼容性证据为主。

## 5. 工作场景排障与优化取舍

1. 通用包启动即SIGILL→整文件/第三方库用了高-march或LTO跨界→先反汇编入口/初始化器，再核对OS能力日志与编译命令→扩展独立TU并保留基础实现；代价是更多对象和分派，回归缺扩展设备。不能依赖捕获SIGILL来可靠探测所有功能，Linux官方明确此法不保证可靠。
2. 宿主能跑但板上崩溃/无法加载→可能是扩展、ELF/Mach-O、libstdc++/libc++或动态库问题→`file`、`readelf -h -d`、`ldd`先区分ABI/依赖，再看HWCAP→为Linux目标用其sysroot重建；Mac arm64成功不是Linux二进制兼容证据。
3. 点积长度增长后负数异常→累加溢出而非分派失败→全-128+长K检测→保留上界或分段int64；增加归约成本，不能以减少检查掩盖错误。

## 6. 来源、结果与下一节

实际读[Tencent/ncnn src/cpu.cpp](https://github.com/Tencent/ncnn/blob/master/src/cpu.cpp)，2026-10-19 master，git blob `e693947c49b46825bb480c6cc417ff709b17c86a`（不是commit）。符号：`get_hw_capability`、`initialize_global_cpu_info`相关Apple查询、`cpu_support_arm_asimddp/i8mm/sve/sve2`；原场景是ncnn多ISA分派，BSD-3-Clause。本课独立实现，保留OS查询→函数选择，省略ncnn旧Apple CPU型号补偿表、多平台全局初始化、线程池与算子注册。Linux查询返回mask，Apple查询sysctl；不能把各个平台的实现混成C++保证。

一手资料实际读[Linux v6.12 elf_hwcaps.rst](https://github.com/torvalds/linux/blob/v6.12/Documentation/arch/arm64/elf_hwcaps.rst)引言、能力语义、ASIMDDP/I8MM/SVE/SVE2条目；它规定用auxv查询可用功能，而非尝试执行来探测。Google查询页与知乎正文获取失败已在主课来源日志记录，未引用搜索摘要为技术结论。本地ARM PDF集合偏MMU/屏障，不作为今天能力接口的依据，不声称新读PDF。

[最终Release](results/final-release.txt)、[最终ASan/UBSan](results/final-sanitize.txt)实际通过；[初始记录](results/initial-release.txt)保留。真实汇编确认两种内核指令存在；没有RK3588/Orin/Thor CPU执行、Linux查询、PMU或热态吞吐验收。日期目录不生成JSON。下一节26为CPU–GPU/NPU流水线与同步边界。

## 7. 迁移验收与追问

先记录板型、uname、lscpu、auxv查询、目标三元组和动态库；同一输入对标量/可用内核、尾部/极端值/超长拒绝；缺扩展时真正执行基础路径；最后再测不同K的函数分派成本、内核与E2E，确认无收益时保留基础路径。

追问：编译宏为什么不能证明OS能力？HWCAP与CPU ID寄存器是什么关系？DotProd/i8mm/SVE2为什么不能按单一等级选择？为什么可选内核要独立TU？何时NEON的int32归约会溢出？Mac arm64产物为何不能直接拷到Linux？
