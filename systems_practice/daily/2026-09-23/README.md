# 2026-09-23 ARM SIMD / NEON：INT8 分块点积与扩宽累加

## 工业场景

机器人 CPU 动作头读取已量化特征，计算 `x[1,1027] × W[64,1027]^T → y[1,64]`。输入为有符号 INT8，每32元素分别使用 x/W 的非负 FP32 scale；W 按输出行连续存储，最后3元素是逻辑尾块。目标是降低 CPU 小矩阵调用延迟，保持结果与同一量化张量的标量参考一致。演示不包含量化搜索、相机传输、GPU/NPU 推理；结果不能作为模型精度或整机控制频率承诺。

## 概念回顾

低位推理的点积首先是数据契约问题：整数编码、分组边界和缩放位置必须一致。这里每三十二个有符号八位数构成一个块，块内计算精确整数点积，块外乘两个缩放系数后累加浮点输出。相邻块的缩放可能不同，因此不能先把整行整数和相加再乘最后一个系数。尾块也有自己的系数，不能为了凑向量长度读过数组末端。我们用独立双精度逐元素参考检查这个合同，再要求所有实现按同一顺序应用缩放，使优化没有偷偷改变数学含义。

向量化的耦合机制是中间位宽与归约顺序。基础NEON一次加载十六个整数，先把乘积扩宽到十六位，再立即成对扩宽到三十二位累加。单个负一百二十八相乘得到一万六千三百八十四，能放进十六位，但两个这样的乘积相加已经超过有符号十六位上限；若先做窄加法再扩宽，错误已经发生，最后用三十二位也救不回来。块长度上限让三十二位整数和有可证明的安全余量。可选点积指令把若干乘积直接累加到三十二位通道，仍然受分组和累加范围约束，不能因指令更短就省略边界分析。

真实程序还受编译目标影响。基础向量扩宽、可选点积扩展和编译器自动向量化是三件不同的事。标量基线单独关闭自动向量化，向量版本保留正常优化，随后检查生成汇编，确认实际走过哪条路径。函数调用、缩放检查和归约都可能占用小矩阵时间，所以对照必须包含相同工作并交错采样。当前结果只来自本机苹果芯片；移到大小核板卡时，应重新识别扩展、编译并测量，不能从同属ARM推断吞吐相同。

## 知识图谱

`INT8[32] + 每块scale → vmull扩宽乘积 → vpadal扩宽归约 → INT32块和 → FP32块缩放 → 行输出`。

| 耦合点 | 代码连接 | 前提与易混概念 |
| --- | --- | --- |
| 分组布局/数学语义 | `scaled_dot`每32个元素取一组sx/sy | 本课FP32独立scale数组，不是ggml的FP16块结构或GGUF文件 |
| 扩宽/溢出 | `neon_dot`的两次`vpadalq_s16` | INT16乘积安全不意味着INT16加法安全 |
| 指令/编译目标 | `optional_dot`和`BASE_ARM` | 宏描述编译目标；不是通用运行时分派器 |
| 尾部/内存安全 | 仅当`i+16<=n`才向量加载 | RAII vector所有权与裸指针借用期；调用方保证实际数组长度 |

源码依据：实际读取 [ggml](https://github.com/ggml-org/ggml) 的 [src/ggml-cpu/arch/arm/quants.c](https://github.com/ggml-org/ggml/blob/master/src/ggml-cpu/arch/arm/quants.c)，`ggml_vec_dot_q8_0_q8_0` 的 NEON 分支与剩余块循环，master，读取日期2026-09-23（未固定commit）。原场景为量化张量点积：整数块和乘双方块scale，多个累加器再归约。本课是**受其启发的独立实现**，保留块缩放合同；省略ggml张量调度、FP16块头、SVE/i8mm、多行接口，并新增任意逻辑尾部。本课未复制上游代码，也未构建ggml。具体符号和来源记录见 [source.json](source.json)。扩宽/归约intrinsics语义核对 [Arm NEON Reference](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)。

## 编码练习

**唯一必做练习，25分钟：将块内归约从逐个INT8标量加法改为安全NEON扩宽归约。**

1. 5分钟：运行标量/NEON完整对照，读`scalar_dot`，手算全`-128`的32元素结果524288。
2. 12分钟：在`neon_dot`工作副本中实现16元素加载、低/高半部乘法、立即扩宽到INT32；每块只做一次水平归约，保留尾部循环。
3. 8分钟：用现成测试验收并读汇编，对照已交付的最终实现；记录相同输入下P50/P95与编译标志。

完整最终实现已交付：默认命令比较`scalar_dot`、`neon_dot`与`optional_dot`。基础NEON为可移植选择；本机可选SDOT更快。不要把练习扩展成第二个量化训练任务。

## 文件说明

- [src/dot.hpp](src/dot.hpp)、[scalar.cpp](src/scalar.cpp)、[neon.cpp](src/neon.cpp)：接口、标量与完整向量实现。
- [main.cpp](src/main.cpp)：独立oracle、边界/非法输入与同口径CPU微基准。
- [run.sh](run.sh)、[CMakeLists.txt](CMakeLists.txt)：C++17构建；[verification.json](results/verification.json)记录边界。
- [每日HQQ](../../quantization/2026-09-23/hqq/README.md)：已核验原生API示例，无额外必做作业。
- [ARM第02节](../../arm/2026-09-23/README.md)：X/W/V寄存器；[今日两篇论文](../../paper/2026-09-23/README.md)。

## 编译与运行

在仓库根目录执行：

```sh
./systems_practice/daily/2026-09-23/run.sh release
./systems_practice/daily/2026-09-23/run.sh sanitize
./systems_practice/daily/2026-09-23/run.sh base
```

AppleClang21、CMake、C++17、arm64已实际运行。`base`指定`-march=armv8-a`，宏报告dotprod=0，本机验证真实NEON回退。非AArch64只会用标量回退，不算SIMD验证。发布到Linux板卡应在板上重编译，不复制Mac二进制：

```sh
uname -a
lscpu
cat /etc/os-release
# 查明板型、核拓扑和Features后，先构建基础Armv8-A路径。
CXX=g++ ./systems_practice/daily/2026-09-23/run.sh base
```

需要dot-product的独立部署构建必须先核实每个可调度核心的支持情况，再选择编译目标；本课不自动假定RK3588所有核/OS都暴露同一特性。不安装依赖。

## 正确性验证

Release、ASan/UBSan与base均实际通过1218比较及10非法输入；规模0–32、起点偏移0/1/3、全零/极端值/随机值；长行覆盖0/1/17/31/32/33/63/64/65/1027，包含不同块scale。整数结果与INT64 oracle逐项一致；scaled SIMD与scaled scalar精确一致，独立double oracle容差为`1e-4+1e-6*abs(ref)`。输入没有隐含可读padding。异常覆盖超长块、空指针、空函数、NaN和负scale。调用方须保证数组长度及合理数值范围，极大scale导致的FP32溢出不属于本课支持输入。

## 性能分析

只计CPU GEMV形态调用（含块函数间接调用、scale检查和输出存储），排除量化、内存分配与I/O。固定同一数据，20预热、100采样，轮转三种版本顺序，无profiler；报告最近秩P50/P95。缓存为重复热工作集，未绑核/锁频，没有PMU证据，不能据此认定已达到带宽或算力上限。

真实编译汇编：[neon.s](results/neon.s)与[scalar.s](results/scalar.s)。生成命令：

```sh
cd systems_practice/daily/2026-09-23
clang++ -std=c++17 -O3 -ffp-contract=off -S src/neon.cpp -o build/neon.s
clang++ -std=c++17 -O3 -fno-vectorize -fno-slp-vectorize -S src/scalar.cpp -o build/scalar.s
rg -n 'smull|sadalp|sdot|addv|madd' build/*.s
```

`neon_dot`主块路径出现`smull/smull2 → saddlp/sadalp → addv`，对应乘积扩宽、INT32累加、水平归约；`optional_dot`主块出现`sdot`。Clang也可能把普通尾部循环自动向量化，所以不要仅搜索整个文件的sdot数量就判定主循环策略。`scalar_dot`出现标量`madd w...`，其独立翻译单元禁止自动向量化。汇编是实际编译器输出，未声称已测单条指令周期。Linux可先`perf list`核实事件，再用`perf stat`对较长重复运行观察cycles/instructions/cache事件；权限或PMU不可用须保留错误。今天不涉及CUDA kernel，不生成无关ncu/SASS，也不推进GPU架构对照轮换。

## 实际运行结果

| Mac CPU实现 | P50 / P95（us） | 状态 |
| --- | --- | --- |
| 标量 | 36.458 / 39.583 | 实测 |
| 基础NEON扩宽 | 9.541 / 10.917 | 实测 |
| 可选dot-product | 8.833 / 10.375 | 本机dotprod=1，实测 |

原始 [CPU日志](results/cpu.txt)、[sanitize](results/sanitize.txt)、[base](results/base.txt)。Darwin25.6.0 arm64，AppleClang21。仅该数据/机器/编译的CPU结果；RK3588、Thor CPU、GPU、NPU、端到端及功耗均未测。

## 工程注意事项

用std::vector管理数据，kernel只借用只读指针，无裸new/delete，无并发访问。非饱和整数点积不应擅自替换成饱和窄化。分块32保持INT32安全，修改为全行累加必须重新证明上界。scale数组与量化值的生命周期、行stride和块编号需一起维护。

本机CPU代码不依赖CUDA。HQQ兼容性栏核实了Thor工具链资料，但没有从Python方法名或Blackwell品牌推断GPU后端可用。所有后续CUDA构建继续固定`sm_110`，本日无其他GPU执行目标。

## 工业故障与面试追问

以下是代码语义推导的故障链，极端/尾部用例实际覆盖；板端现象未实测。

| 触发 → 现象 | 根因 | 最小诊断 → 修复/取舍 |
| --- | --- | --- |
| 全-128 → 结果突然翻号 | INT16先加再扩宽 | 32元素oracle → 乘积立即扩宽归约 |
| K=33/1027 → 尾部错误或ASan越界 | 未检查整向量可读范围 | 精确长度分配 → 独立尾部循环 |
| 相邻组scale不同 → 整行偏差 | 跨组累加后只缩放一次 | 双精度逐元素参考 → 保留块边界 |
| 换板后非法指令 | 目标扩展与运行核心不匹配 | 编译宏+OS能力+实际汇编 → base或已核实运行时分派 |

面试追问：

1. 为什么INT8乘法扩宽到INT16仍不足以保证点积安全？
2. SDOT每个INT32 lane累加哪些输入元素？
3. 两个块的scale不同，哪些循环变换仍然合法？
4. 尾部使用零padding与标量处理各需什么内存契约？
5. 为什么编译宏不能替代动态异构核心能力检查？
6. 小GEMV中函数调用、归约、scale检查与算术吞吐如何区分？

## 自测问题

同事把块大小从32改成整行，保留一个INT32向量累加器，并在行末乘最后一组scale；随机小输入看似正确。请给出能区分“数学分组错误”与“整数溢出错误”的最小输入设计，并说明部署验收应补哪些检查？
