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

[来源](source.json) · [验证](verification.json)
