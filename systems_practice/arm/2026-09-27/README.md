# ARM 06：编译目标、优化选项与反汇编

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
