# ARM 06：编译目标、优化选项与反汇编

> 2026-09-29 深度回补：下文新增机制推导与工作排障。原始源码、运行日期和日志保留；5–10分钟仅指前部速览，深入正文不受该篇幅限制。

课程日期2026-09-27，实际补课2026-09-28。5–10分钟现成小课，不另布置作业。

同一ROCK5B校验和程序，在Mac观察O2禁向量化和O3自动向量化。

target triple确定架构、系统和ABI，mcpu/march决定可生成的指令，sysroot决定目标头文件与库。预处理宏只说明编译目标能力，不能当运行时CPU检测。只给Cortex-A76编译选项不等于生成Linux可执行文件，更不保证能在A55核上安全运行。跨板部署需以共同能力集或运行时分派为前提。

[一手依据](https://clang.llvm.org/docs/CrossCompilation.html)：Clang官方Target Triple、Toolchain Options、Target-Specific Libraries，读取2026-09-28。 板卡锚点为[ROCK5B/RK3588](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)，Cortex-A76/A55；实际板卡OS/SDK/核编号未知，先采集 `uname -a`、`cat /etc/os-release`、`lscpu -e` 和编译器版本。Thor CPU是另一个体系结构实例，不能把GPU的SM编号当CPU架构。

## 运行与观察

在EveryDay根目录：

```sh
bash systems_practice/arm/2026-09-27/run.sh
```

C++17、无外部依赖，输入在程序生成；[源码](src/example.cpp) · [真实输出](results/cpu.txt) · [真实汇编](results/native-arm64.s)。1025长度；O2、ASan/UBSan、O3均验证一致。 实际Apple clang21、arm64，Release与ASan/UBSan通过。

保存native-arm64.s和vectorized-arm64.s；前者禁向量化，后者由当前编译器决定是否自动向量化。不要预先假设所有循环都会SIMD。

在板端使用已具备的C++17编译器运行同一源码并保存汇编，然后比较调用/地址/依赖形态；Linux交叉编译需配套aarch64-linux-gnu sysroot和目标标准库，本机没有，不声称已经交叉编译成功。GPU/NPU未参与，未测性能/PMU，不将少几条指令直接当加速。

## 边界与接续

现成例子只验证数值及编译器实际生成内容；输入长度边界、unsigned算术与对象寿命明确。若看到与文档不同的寄存器编号，先定位函数及工具链，寄存器分配并非源码合同。下一节07，从当前机制继续按课程表推进。

## 这个例子具体观察什么 ARM 机制

编译选项属于通用工具链知识；本课用它观察**同一C++求和在AArch64通用寄存器与NEON寄存器中的不同实现**。脚本现在会打印禁向量化与O3两份checksum函数体，不再只打印PASS和宏名。

| 对照 | 本次真实指令 | 要看什么 |
| --- | --- | --- |
| [O2禁向量化](results/native-arm64.s) | `ldr w9, [x0], #4`、`add w8, w9, w8` | 一次取一个uint32，W寄存器标量累加 |
| [O3向量主循环](results/vectorized-arm64.s) | `ldp q4, q5`、`ldp q6, q7`及四条`add.4s` | Q是128位视图，4s表示四个32位lane；该循环共处理16个元素 |
| O3归约 | `addv.4s s0, v0`、`fmov w8, s0` | 横向归约后把结果位从SIMD/FP寄存器转移到通用寄存器，不是浮点数值转换 |
| O3尾部 | `ldr w11, [x9], #4`、`add w8, w11, w8` | 剩余不足向量宽度的元素走标量路径 |

观察时从checksum标签开始，避免把main或iostream中的向量指令误认成目标循环。比较的是两组实际编译参数的生成结果，不能仅凭宏存在断言执行了NEON，也不能将向量化或O3自动等同于提速。完整自动向量化机制留到第08节；[LLVM向量化文档](https://llvm.org/docs/Vectorizers.html)的诊断与reduction说明为后续阅读依据（2026-09-28读取）。

## 来源与验证

上述Clang官方文档实际读取于2026-09-28，范围为Target Triple、Toolchain Options、Target-Specific Libraries；本例为独立教学实现。Mac实际编译、运行及ASan/UBSan通过；格式化后重新验证通过，见[输出](results/formatted-cpu.txt)。均为2026-09-28的验证，目标板未验证。

2026-09-28新增观察入口实际复验：Release、ASan/UBSan均通过，目标函数的AArch64汇编已直接输出；[本次完整输出](results/arm-observation-20260928.txt)。第06节另包含O3运行与向量汇编，其他课不据此新增性能结论。


## 工程深入：编译器优化必须有证据链

**工作目标**：同一循环换编译器/flags后表现变化时，能说清“源码允许什么、编译器做了什么、执行是否正确、是否更快”。target triple解决架构/系统/ABI层面的目标选择，sysroot和目标库解决编译链接所需环境；优化级别是另一维。`-O3`不会自动补齐Linux sysroot，也不代表实际部署CPU支持所有生成指令。

本课checksum的数学合同是uint32模2^32求和，循环只有读输入和更新本地sum，因此编译器可以把归约拆成向量lane再合并。真实向量循环用4个Q寄存器批量装入16个uint32，通过4组`add.4s`维护独立累加，最后横向合并并用`fmov w8,s0`把结果位搬回通用寄存器。这里的s0名字不表示算法变成浮点；要结合ADDV和FMOV的操作语义看。尾部仍处理剩余元素，主循环是否进入取决于长度和编译器阈值；在二进制中找到NEON也不等于每次短输入都执行向量路径。

### 从“为什么没向量化”到可执行定位

2026-09-29复核[LLVM向量化文档](https://llvm.org/docs/Vectorizers.html)中的诊断、reduction和代价模型说明。可在本课目录用已有Clang输出诊断与目标函数；命令不安装依赖，不改变归档旧汇编：

```sh
cd systems_practice/arm/2026-09-27
clang++ -std=c++17 -O3 -Rpass=loop-vectorize \
  -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize \
  -S src/example.cpp -o build/hpc-vectorized.s 2> build/hpc-vectorizer.txt
cat build/hpc-vectorizer.txt
sed -n '/^__Z8checksum/,/cfi_endproc/p' build/hpc-vectorized.s
```

按顺序检查：是否定位到checksum的源行；编译选项是否确实生效；合法性是否受依赖/调用/数值合同限制；编译器是否认为收益不足；真实汇编是否包含该目标循环的向量主路径和尾部。诊断报告“成功”还需汇编核对；没有报告也不要直接猜具体原因，保留工具版本与命令。本课固定uint32归约，不能据此断言任意FP32归约都允许同样重排。

### 对照设计与上线代价

已有O2禁向量化和O3对照改变了不止一个因素，因此适合展示两种生成形态，不能把任何未来时间差全部归因于NEON。归因实验需要保持优化级别等条件一致，再开关相关向量化选项，并检查展开因子、别名检查及尾部是否也变化。所有变体仍需相同输入语义；不能通过fast-math放宽误差而将结果称作原合同下的公平提速。

| 症状 | 先收集证据 | 修复与限制 |
| --- | --- | --- |
| 宏显示NEON但循环仍标量 | checksum本体与向量化诊断 | 根据具体失败原因处理；宏不是代码生成证明 |
| O3正确但小请求更慢 | 实际进入哪条分支、长度分布、计时是否含调用 | 按业务shape比较，小N可能保留标量；本课还没有性能证据 |
| 本机优化后二进制在板端失败 | 目标格式、扩展、库、实际指令 | 重新匹配工具链/运行能力，不能以本机PASS放行 |

### 验收与追问

当前1025个长度验证输入全17，覆盖尾部长度，但不是充分的数值分布测试；生产替换需补全0、极值、混合值、随机种子、业务数据与同一oracle。生成向量汇编和数值通过是两个验收项，公平性能与目标运行仍是另外两项。完整自动向量化课在08继续，本节不提前标为完成。

面试追问：1. reduction怎样从串行变量变成lane？2. fmov为什么不一定进行浮点转换？3. 发现NEON指令能证明短输入使用向量路径吗？4. O2和O3对照为什么不能独立归因？5. 合法性判断与代价判断如何区分？6. 固定值测试会遗漏哪些错误？

### 2026-09-29深化复验

本机原有Release与ASan/UBSan入口均退出0；该结果不替代目标板验收。[本次完整输出](results/hpc-review-20260929.txt)。原有日志与源码保持原字节，本次只增补文档和新结果。为核对入口完整性，多个课程构建并行执行；07课此次输出中的时间受并行任务干扰，仅作正确性复验，不用于新的性能收益结论。未验证Linux perf、目标板、温控或实际业务E2E。

新增向量化诊断命令也实际退出0：[诊断记录](results/hpc-vectorizer-20260929.txt)。`src/example.cpp:7`报告vectorization width=4、interleaved count=4，对应4lane及4组交错；库头和main的其他未向量化诊断不是checksum失败，必须按函数与源行筛选。此记录不增加性能结论或推进08课。
