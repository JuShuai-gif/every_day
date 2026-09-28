# ARM 04：循环、依赖链与指令级并行

课程日期2026-09-25，实际补课2026-09-28。5–10分钟现成小课，不另布置作业。

RK3588摄像头统计连续UINT64计数；同样的求和，比较一条累加链与四条独立链。

串行每次add都读取上次结果；拆成四个独立累加器允许更多工作就绪，最后再合并。unsigned溢出按模运算定义，因此可改变分组；浮点不能直接套用同样的逐位等价保证。Cortex-A55和A76的调度资源不同，不猜测发射宽度和周期数，也不从Mac外推板端收益。

[一手依据](https://documentation-service.arm.com/static/674d8b61c7fc0d1f211dc776?token=)：Arm A64 ISA Guide 1.2：加载/算术与循环；实际汇编为本机编译观察。 板卡锚点为[ROCK5B/RK3588](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)，Cortex-A76/A55；实际板卡OS/SDK/核编号未知，先采集 `uname -a`、`cat /etc/os-release`、`lscpu -e` 和编译器版本。Thor CPU是另一个体系结构实例，不能把GPU的SM编号当CPU架构。

## 运行与观察

在EveryDay根目录：

```sh
bash systems_practice/arm/2026-09-25/run.sh
```

C++17、无外部依赖，输入在程序生成；[源码](src/example.cpp) · [真实输出](results/cpu.txt) · [真实汇编](results/native-arm64.s)。1025长度，覆盖0–1024、尾部与回绕。 实际Apple clang21、arm64，Release与ASan/UBSan通过。

在four中实际观察到两次ldp与四条不同目的寄存器的add；serial是同一目的寄存器链。

在板端使用已具备的C++17编译器运行同一源码并保存汇编，然后比较调用/地址/依赖形态；Linux交叉编译需配套aarch64-linux-gnu sysroot和目标标准库，本机没有，不声称已经交叉编译成功。GPU/NPU未参与，未测性能/PMU，不将少几条指令直接当加速。

## 边界与接续

现成例子只验证数值及编译器实际生成内容；输入长度边界、unsigned算术与对象寿命明确。若看到与文档不同的寄存器编号，先定位函数及工具链，寄存器分配并非源码合同。下一节05，从当前机制继续按课程表推进。

[来源](source.json) · [验证](verification.json)
