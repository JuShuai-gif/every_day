# 2026-09-30 ARM08：普通循环怎样自动向量化，以及为什么要保留重叠语义

## 5–10分钟速览与工作目标

承接07的公平计时，本课解决ROCK 5B/RK3588采集数据整理的一类问题：连续UINT32样本做`dst[i]=3*src[i]+1`，为什么同一个循环有时走NEON、有时必须逐项执行。算术为模2^32，n=0有效，可同数组重叠；这是示范整数传感器处理合同，不是图像色彩算法。

主要能力层为**第三层：证据驱动优化**，以第二层正确性合同为前置，并提供第一层Linux部署检查。工作证据是地址依赖反例、两种编译策略的功能/速度对照、实际A64与编译诊断。产品级长期负载、功耗与板端验收尚未完成。四层规则见[ARM工作路线](../../docs/arm/README.md#工作落地的四层能力2026-09-30)。NEON是否值得采用由合同和测量决定。

## 输入状态与依赖

单步示意：数组初始`[1,2,3,4,5]`，src=base、dst=base+1、n=4。

| i | 本步src值 | 写入dst | 原因 |
| --- | --- | --- | --- |
| 0 | 1 | 元素1=4 | 正常读写 |
| 1 | 4 | 元素2=13 | 上一步已经改了下次输入 |
| 2 | 13 | 元素3=40 | 循环携带依赖继续 |
| 3 | 40 | 元素4=121 | 逐项合同结果 |

如果先把旧src四个元素整体加载再计算，会得到4/7/10/13，改变程序语义。这个反例完全在已分配数组内，无越界/有符号溢出/假restrict，不用UB作实验。src=dst则每元素自更新，没有同样的前向依赖；编译器仍可能保守回退。通用别名分析不是ARM独有，**实际生成的A64 NEON及其分派**是本课ARM证据。

## 上游源码怎样解释当前选择

2026-09-30实际读[LLVM main的LoopVectorize.cpp](https://github.com/llvm/llvm-project/blob/main/llvm/lib/Transforms/Vectorize/LoopVectorize.cpp)：`GeneratedRTChecks::create`读取`LoopAccessInfo::getRuntimePointerChecking()`，按条件构造`vector.memcheck`并调用`addDiffRuntimeChecks`/`addRuntimeChecks`，其后成本模型考虑runtime check与trip count。还读[官方Vectorizers文档](https://llvm.org/docs/Vectorizers.html)的Runtime Checks of Pointers、Diagnostics、unknown trip count。许可证Apache-2.0 WITH LLVM-exception；精确main提交未固定。若干猜测的runtime-check测试文件URL返回Internal Error，未声称读到它们。

上游是编译器合法性/成本分析，本课`kernel.cpp`为独立普通C++循环，没有复制LLVM实现，也没有编译LLVM。Apple clang21是本机编译器，不等同所读main提交；原理关系可解释现象，不能声称源码版本完全一致。Google查询与知乎限定查询没获得可核验正文，仅采用一手源码/官方文档，详见主课[source.json](../../daily/2026-09-30/source.json)。本地ARM PDF资料目录主要覆盖MMU/中断/屏障，已读使用规则，本课不采用不相关PDF或沿用未核验结论。

## 从关键代码到真实A64

`src/kernel.cpp`同一循环编译两次：O3默认向量化与O3关闭loop/SLP向量化，跨翻译单元且无LTO，输入、输出和语义完全一致。编译诊断实际报告向量宽度4、interleave4。以下摘自[真实运行文本](results/run.txt)，不是预期汇编：

```asm
sub x9, x0, x1
cmp x9, #63
b.ls LBB0_12
ldp q1, q2, [x9, #-32]
movi.4s v5, #1
mla.4s v5, v1, v0
stp q5, q1, [x10, #-32]
```

这些行分别来自不同基本块，须按完整日志理解；第一组x9是地址差，进入向量块后x9被重用为源游标。x0/x1/x2按本机ABI传dst/src/n；`b.ls`是无符号比较，检查危险的较小正向地址差。q寄存器承载128位、`.4s`按4个32位lane计算；v0已装3，v5先装1，mla得到`1+src*3`。主向量循环每轮16元素，另有4元素向量尾段，最后`ldr w11`、两次add、`str w11`处理标量尾部。n=0由cbz直接返回。

64B阈值来自本次编译器的向量宽度/展开与合法性策略，**不是从此汇编测出了cache line大小**。q加载的存在证明向量路径生成，不证明每次调用走它；重叠输入可能走标量路径。没有使用SVE/SVE2或可选dot-product。

## 现成对照与真实结果

从本课目录运行`sh run.sh`：自动构建Release/Sanitizer，运行完整检查并打印实际目标函数及诊断。`build.sh`保留完整编译参数。4104重叠组合：n=0..1025、偏移0/+1/-1/+8；另1026个不重叠长度，包含极大UINT32与尾部。Release和ASan/UBSan均通过。Sanitizer只检查正确性，其耗时不参与基准。

格式化后的[复验日志](results/final-run.txt)仍通过全部功能检查；下表保留首次实测，不把复验当新收益。原始[run.txt](results/run.txt)记录Apple clang21/macOS arm64一次测量：20预热、101样本，每样本128次调用均值，先scalar后auto，未控制温度/频率，数据驻留重复使用。

| n | scalar P50/P95 us | auto P50/P95 us |
| --- | --- | --- |
| 16 | 0.0107422 / 0.0110703 | 0.00292969 / 0.00325781 |
| 4096 | 1.92578 / 2.50033 | 0.196289 / 0.198242 |
| 262144 | 70.6273 / 72.0941 | 15.6816 / 16.1621 |

这是**CPU批均值分布**，不是单请求尾延迟，不是RK3588/Thor CPU结果。固定测量顺序与系统噪声仍可能影响比值；只用于本机候选依据。每元素逻辑读4B写4B，n4096的逻辑流量32768B；它不等于DRAM事务量，cache与write allocation、预取未测。乘加是整数操作，不用GFLOP/s命名。更大数据可能受带宽限制，重叠或小n可能回退且不获益；不能保证向量化在任何任务都更快。

## 排障链与采用取舍

1. 加了无别名承诺后ROI结果错误：先用上述+1偏移手算输入检查语义，再看接口是否允许重叠。修复是保留runtime check/标量路径，或明确要求独立缓冲并在调用端保证；额外复制虽能打破依赖，但增加内存和时延，必须计入E2E。回归包含n=0、W±1、正负偏移与全数组哨兵。
2. 板端没有预期收益：先读目标三元组、-O等级和诊断，再查看真正运行函数是否包含NEON/回退分支，之后对比相同shape的线程位置与频率。原因可为重叠回退、不同编译器、带宽饱和或核迁移；不能直接怪A55“没有NEON”。保留正确标量路径，任务粒度/布局改变须重新验收。
3. Mac产物上Linux报格式/加载错误：`file`区分Mach-O与ELF，`readelf -l/-d`核对interpreter与NEEDED，检查sysroot/GLIBC版本。重新为aarch64-linux-gnu目标构建；同为arm64不保证ABI、OS库、动态加载器兼容。

## Linux/目标板完整验收入口

以下是未执行的现成部署方案。在已备好工具链和**目标rootfs sysroot**的Linux构建机运行；不会自动安装或传输。`TARGET_SYSROOT`由实际板端镜像指定，不能填Mac SDK：

```sh
export TARGET_SYSROOT=/path/to/matching-target-sysroot
mkdir -p build/linux
# 两个对象使用同一sysroot和基础AArch64目标，不强加可选扩展。
aarch64-linux-gnu-g++ --sysroot="$TARGET_SYSROOT" -std=c++17 -O3 -fno-tree-vectorize -DNAME=transform_scalar -c src/kernel.cpp -o build/linux/scalar.o
aarch64-linux-gnu-g++ --sysroot="$TARGET_SYSROOT" -std=c++17 -O3 -fopt-info-vec-all=build/linux/vector.txt -c src/kernel.cpp -o build/linux/auto.o
aarch64-linux-gnu-g++ --sysroot="$TARGET_SYSROOT" -std=c++17 -O3 -g src/example.cpp build/linux/scalar.o build/linux/auto.o -o build/linux/example
file build/linux/example
aarch64-linux-gnu-readelf -l -d build/linux/example
aarch64-linux-gnu-objdump -d -C build/linux/example > build/linux/disassembly.txt
```

在目标板已部署的独立练习目录运行`uname -a`、`cat /etc/os-release`、`lscpu -e`、`ldd ./example`（只对本课受信产物）、`./example`及`gdb --args ./example`。Radxa[ROCK5B产品文档](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)对应RK3588 A76/A55；**本次未读取板上OS/拓扑，CPU ID和频率不硬编码**。记录编译器、sysroot来源、加载器、依赖版本、实际核心、温度/频率、Sanitizer、代表数据和长跑。先按观测选择亲和性，再`taskset -c <已核实CPU号> ./example`，不能把占位CPU号当命令已验证。

上线判据：重叠/尾部与原合同一致；产物能在目标OS加载；相同输入下处理阶段延迟改善且应用P95不退化；无资源增长/关闭故障；无收益时回退。当前仅完成Mac功能/诊断/基准，没有完成交叉构建、部署、板端性能或产品闭环。

## 面试追问与下一节

1. 为什么同一数组内重叠会产生循环依赖？2. `.4s`与q寄存器是什么关系？3. 地址差63检查为什么不是cache line测量？4. SIMD路径存在为什么不能证明本次输入用了它？5. 为什么批均值P95不能当请求P95？6. 同为arm64为何Linux无法加载Mac产物？

下一节09：NEON向量加载与尾部处理，把本课编译器自动选择的边界显式写进intrinsics合同。
