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

## 来源与验证

上述Arm指南版本为102374_0102_02_en（1.2 Issue02，2024-12-02），实际读取2026-09-28的§15–18及Radxa板卡规格；本例为独立实现。首次访问[章节地址](https://developer.arm.com/documentation/102374/latest/Loads-and-stores---addressing)报tool internal error；PDF无查询参数地址报400 timeout，正文所链带查询参数地址读取成功。

实际运行时间2026-09-28T01:36:46.095597+00:00，Apple clang21.0.0，目标 `arm64-apple-darwin25.6.0`。Release与ASan/UBSan验证36组有效输入和4种非法描述通过，已生成汇编；未测性能，缺ROCK5B/Jetson设备，板端OS/SDK/拓扑及执行未验证。
