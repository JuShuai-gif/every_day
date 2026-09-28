# ARM 03：加载/存储、地址与 stride

上一节看了 X/W 寄存器；今天把寄存器中的地址连接到 ROCK 5B 的摄像头深度帧。教学输入为 UINT16 `[H,W]`，物理行长 `stride` 个元素。读取位置是 `base + 2*(row*stride+col)` 字节。行尾 padding 不是像素，不能把 H×W 当成连续缓冲区扫完。

选定教学板为 Radxa ROCK 5B/RK3588。[官方产品页](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction) 当日读取，CPU 为 Cortex-A76/A55；实际板端 OS、内核、核拓扑与 SDK 未采集，Mac 编译结果不代表这些核的性能。接板后先运行 `cat /etc/os-release`、`uname -a`、`lscpu -e`、`clang++ --version`，不预设核编号。

[Arm A64 ISA Guide 1.2 Issue02](https://documentation-service.arm.com/static/674d8b61c7fc0d1f211dc776?token=) 的 §15–18（印刷页30–37）解释传输宽度、零/符号扩展与地址模式。`LDRH` 从内存取16位零扩展；后索引先用旧地址，再推进基址。它本身不知道二维 Shape。C++ 指针下标按元素缩放，汇编偏移按字节，接口若以字节提供 stride，必须先验证可整除元素宽度。本例是独立教学代码，不声称改编某开源 kernel。

在 EveryDay 根目录：

```sh
sh systems_practice/arm/2026-09-28/run.sh
```

[源码](src/stride.cpp) 为 C++17，vector 管理内存；先验证 stride、容量和乘法溢出，再遍历逻辑元素。36 组含零行/零列、奇数列与 poison padding；4 种非法描述分别拒绝。Mac Release 与 ASan/UBSan 均实际通过：[输出](results/cpu.txt)。本节不测速度、不使用 NEON，没有第二个作业。

[真实编译汇编](results/stride-arm64.s) 中 `sum_rows` 先将 stride 左移一位形成字节行距，内层出现 `ldrh w13, [x11], #2`，然后累加到 X 寄存器；外层按字节行距前进。编译参数 `-O2 -fno-vectorize -fno-slp-vectorize`、Apple clang21；这是 Mac arm64 编译器产物，不是 RK3588 反汇编，也不是 GPU SASS。编译器可以换寄存器和循环形态，不应依赖这些寄存器编号。

页、cache miss、访存合并和内存屏障尚未进入本节；正确地址也不意味着缓存友好。下一节 **04：循环、依赖链与指令级并行**，从连续求和为何形成依赖链讲起，联系 Cortex-A55/A76。

## 这个例子具体观察什么 ARM 机制

C++的二维stride并非ARM独有知识。本节要观察的是它如何落到A64的**半字加载、W/X宽度和后索引寻址**。执行run.sh后会直接打印本次生成的sum_rows汇编；程序PASS只证明求和正确，下面的指令才是ARM观察内容。

在[已归档汇编](results/stride-arm64.s)的sum_rows函数中，逐项对应源码：

| C++位置 | 本次A64指令 | 观察结论 |
| --- | --- | --- |
| 外层按stride个uint16前进行 | `lsl x10, x3, #1`、`add x0, x0, x10` | 元素行距乘2转换成字节行距 |
| 内层读取一个uint16 | `ldrh w13, [x11], #2` | 先取旧地址的16位无符号值，再将地址加2；结果零扩展到W，写W也清零X高32位 |
| uint64累加 | `add x8, x8, x13` | 加载宽度16位与累加宽度64位分开 |
| 内层计数与回跳 | `subs x12, x12, #1`、`b.ne` | SUBS更新条件标志，B.NE依据Z标志继续循环 |

观察现成36组数据中的有padding输入：内层只推进cols次，下一行从原行首加`2*stride`，因此不会累加poison padding。仅看最终和无法解释寻址方式，要同时沿x11的列指针和x0的行指针看。寄存器编号是该次编译器分配，重新编译可能变化；这些是Mac的A64指令观察，不能证明Cortex-A76的访存延迟。

## 来源与验证

上述Arm指南版本为102374_0102_02_en（1.2 Issue02，2024-12-02），实际读取2026-09-28的§15–18及Radxa板卡规格；本例为独立实现。首次访问[章节地址](https://developer.arm.com/documentation/102374/latest/Loads-and-stores---addressing)报tool internal error；PDF无查询参数地址报400 timeout，正文所链带查询参数地址读取成功。

实际运行时间2026-09-28T01:36:46.095597+00:00，Apple clang21.0.0，目标 `arm64-apple-darwin25.6.0`。Release与ASan/UBSan验证36组有效输入和4种非法描述通过，已生成汇编；未测性能，缺ROCK5B/Jetson设备，板端OS/SDK/拓扑及执行未验证。

2026-09-28新增观察入口实际复验：Release、ASan/UBSan均通过，目标函数的AArch64汇编已直接输出；[本次完整输出](results/arm-observation-20260928.txt)。本次未测性能或验证目标板。
本次重新核对上述Arm ISA Guide §18后索引寻址；§19的成对加载说明用于第04节。
