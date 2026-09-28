# ARM 05：函数调用、ABI与寄存器保存

课程日期2026-09-26，实际补课2026-09-28。5–10分钟现成小课，不另布置作业。

ROCK5B用户态C++采集模块调用另一翻译单元的九参数函数。

ABI是跨编译单元约定：AAPCS64的x0–x7承担常规整数参数，剩余参数按规则落栈；x19–x28是callee-saved。调用者仍须保护自己的caller-saved活值。例子禁LTO并noinline，保证存在真实调用。Mac用Darwin ABI，不能把本机布局断言为Linux所有类型的规则，尤其变参和小整数另有差异。

[一手依据](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst)：AAPCS64通用寄存器表和参数传递章节，main读取2026-09-28；独立C++例子。 板卡锚点为[ROCK5B/RK3588](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)，Cortex-A76/A55；实际板卡OS/SDK/核编号未知，先采集 `uname -a`、`cat /etc/os-release`、`lscpu -e` 和编译器版本。Thor CPU是另一个体系结构实例，不能把GPU的SM编号当CPU架构。

## 运行与观察

在EveryDay根目录：

```sh
bash systems_practice/arm/2026-09-26/run.sh
```

C++17、无外部依赖，输入在程序生成；[源码](src/example.cpp) · [真实输出](results/cpu.txt) · [真实汇编](results/native-arm64.s)。1000个seed的九参数加权和与跨调用活值比较。 实际Apple clang21、arm64，Release与ASan/UBSan通过。

caller出现bl _combine；x19/x20承载跨调用活值，stp保存、ldp恢复，另一个参数写到栈；这是真实编译文本，不是手写示意。

在板端使用已具备的C++17编译器运行同一源码并保存汇编，然后比较调用/地址/依赖形态；Linux交叉编译需配套aarch64-linux-gnu sysroot和目标标准库，本机没有，不声称已经交叉编译成功。GPU/NPU未参与，未测性能/PMU，不将少几条指令直接当加速。

## 边界与接续

现成例子只验证数值及编译器实际生成内容；输入长度边界、unsigned算术与对象寿命明确。若看到与文档不同的寄存器编号，先定位函数及工具链，寄存器分配并非源码合同。下一节06，从当前机制继续按课程表推进。

[来源](source.json) · [验证](verification.json)
