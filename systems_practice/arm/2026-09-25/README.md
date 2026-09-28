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

## 这个例子具体观察什么 ARM 机制

**多累加器和指令级并行属于通用CPU原理**。本课的ARM部分是把C++循环映射到真实A64寄存器依赖和成对加载；没有测出A55/A76的流水线宽度或速度收益。run.sh现在直接打印serial和four的本次生成汇编。

在[已归档汇编](results/native-arm64.s)中：

- serial的`ldr x9, [x0], #8`加载一个64位元素；`add x8, x9, x8`每轮读写x8，形成跨迭代依赖。
- four的两条`ldp x14, x15, ...`每条读取两个64位值；四条ADD分别更新x8、x10、x11、x9。沿目的寄存器向上一轮追踪，就能看到四条分开的累加依赖链；x14/x15是重复使用的加载临时寄存器。
- 主循环每轮地址推进32字节，尾部仍用`ldr ... #8`；退出后用ADD合并四个累加器。1025个长度验证覆盖尾部和uint64回绕。

可先并排看两个函数，再用笔连出x8跨迭代的读写边；four中再分别连出四个目的寄存器。这是依赖图观察，不是“出现LDP就快两倍”或“四个ADD同时执行”的证明。下一步板端性能课才在指定核、相同输入与计时条件下测量。

## 来源与验证

一手资料实际读取于2026-09-28，范围为上述Arm A64 ISA Guide 1.2的加载、算术与循环；本例为独立教学实现。Mac实际编译、运行及ASan/UBSan通过；格式化后重新验证通过，见[输出](results/formatted-cpu.txt)。均为2026-09-28的验证，目标板未验证。

2026-09-28新增观察入口实际复验：Release、ASan/UBSan均通过，目标函数的AArch64汇编已直接输出；[本次完整输出](results/arm-observation-20260928.txt)。本次未测性能或验证目标板。
本次额外核对上述Arm ISA Guide §19的LDP/STP说明；寄存器依赖来自本机真实编译输出。
