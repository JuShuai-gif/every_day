# 2026-10-01 ARM09：NEON加载/存储与安全尾部

## 5–10分钟速览与工作合同

承接08自动向量化，本节目标是看懂128位加载何时合法。机器人相机在ROCK 5B/RK3588上处理任意长度字节片段：`dst[i]=(src[i]+1) mod 256`，输入只保证n字节有效，不能借用allocator padding。标量与NEON处理相同输入；长度0允许不访问内存，非0必须容量足够且指针有效。要求源/目标不重叠，示例不处理DMA并发所有权。

主能力层3：以证据决定采用NEON；层2贡献安全尾部合同。实际验证设备仅Apple Silicon Mac，未取得ROCK 5B、AGX Thor/T5000的板型/OS/拓扑/SDK现场信息。RK3588的A76/A55、Thor的Neoverse-V3AE均需分别测量，不能复制Mac耗时。GPU/NPU未参与。

## 两个耦合机制与数据流

`连续字节 → 16 lane向量 → 8位模加 → 16字节写回 → 0..15字节标量尾部`。

| n=17时阶段 | 合法输入 | 生成指令对应 | 不变量 |
| --- | --- | --- | --- |
| i=0，剩17 | src[0..15] | ldr q1 / add.16b / str q1 | 16个8位lane，256回绕 |
| i=16，剩1 | src[16] | ldrb / add / strb | 不触碰src[17] |
| i=17 | 无 | ret | 读写均恰好n字节 |

`n-i>=16`比`i+16<=n`避免加法溢出；前提i始终≤n。NEON非对齐地址在本合同的普通内存上可用，但不代表越界或设备内存访问合法。页仍映射不能证明C++对象边界有效；保护页测试和ASan对象边界测试互补。n=15若做一次16字节load再只写15字节，写边界虽正确，读仍越界，因此本例不执行此错误方案。

## 源码研究与保留边界

2026-10-01实际读[Arm optimized-routines master/string/aarch64/memcpy.S](https://github.com/ARM-software/optimized-routines/blob/master/string/aarch64/memcpy.S)的`__memcpy_aarch64`及copy16/copy8/copy4小尺寸分支：原场景是libc内存复制，头尾加载保证读取位于有效区间。该文件小块路径使用通用寄存器，不能称为NEON实现。本课只借鉴精确尺寸与边界分派原则，独立实现byte变换并用标量尾部；不复制memcpy大块流水与重叠语义。源码SPDX为MIT OR Apache-2.0 WITH LLVM-exception；读取分支/日期已记录，精确commit未固定。

另实际读[Arm ACLE Advanced SIMD参考](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)的vld1q_u8/vaddq_u8/vst1q_u8定义，核对lane与非饱和加法。Google请求Internal Error；知乎定向检索未取得可核查原文，未采用博客性能。本节不依赖本地PDF集合，不声称新增PDF阅读。

## 已写好的对照与观察命令

工作目录EveryDay根；Apple clang21.0.0，C++17，O2。`-fno-vectorize -fno-slp-vectorize`关闭自动向量化，明确intrinsics仍保留；只比较标量基线与手写向量。运行会先Release，再ASan/UBSan，并显示目标函数的真实汇编。

```sh
sh systems_practice/arm/2026-10-01/run.sh
```

[源码](src/example.cpp)的scalar/neon做同一运算；Guard用mmap/mprotect创建无访问保护页，析构检查munmap。输入n=0..257、offset=0..15共4128组；8种页边界尾部；输出哨兵与独立scalar逐字节相等；拒绝容量不足。全部是现成例子，无新增作业。

[实际汇编](results/host-arm64.s)中的核心摘录：

```asm
ldr q1, [x0, x8]
add.16b v1, v1, v0
str q1, [x1, x8]
```

q1指128位向量寄存器，add.16b选16个字节lane，v0由movi.16b填1；x8每轮增加16。随后`ldrb w11`/`strb w11`逐字节处理尾部。`cmp x9,#15; b.hi`为无符号剩余量判断，不能把它读成“第15个元素”。这是编译生成的A64文本，不是手写预期汇编；Mac Mach-O符号带下划线，Linux符号/ABI要另看。

## 性能模型、真实证据与限制

逻辑流量为n字节读+n字节写；4097字节共8194字节/调用，NEON 256轮向量+1字节尾部。模型只算算法流量，不能推导DRAM流量或CPU周期。数据热驻留、无分配计入、单线程，20批预热+100批采样，每批128次，报告每批总时间/128。P95是批均值P95，不是请求P95。checksum防删除；两路径顺序运行仍有频率/缓存混杂，应在板端交换顺序复测。

[首次原始日志](results/initial.txt)Release scalar P50/P95=2.06445/2.60188us，NEON=0.116859/0.128906us；这是Mac该次热数据观察，不外推板端。格式化后[最终日志](results/final.txt)另存，ASan数值不能用于优化收益。小n时向量入口和尾部分支可能无收益；大型跨缓存输入、stride、DMA同步成本都未测。没有PMU证据，不断言是DRAM瓶颈。

## 故障链路与板端验收

1. 帧尾偶发崩溃→可能超读或错误stride→用n15/17保护页和ASan区分→保证剩余量≥16才向量读→回归4128组与真实stride。修复代价为最多15次标量操作。
2. Mac快而RK3588慢→可能运行在A55、冷缓存或搬运占主导→记录核拓扑/亲和性、工作集及独立kernel和E2E→选择目标核/按长度分派→热稳态回归，不能简单增加线程。
3. 输出在255附近不同→饱和加和模加合同混淆→0/254/255输入对照→根据业务选vadd或vqadd并同步参考，不能偷偷更换语义。

部署层：Linux arm64现场执行`uname -m; lscpu`核实机器；用板端C++17编译器构建而非拷贝Mach-O。可在本课目录执行：

```sh
c++ -std=c++17 -O2 -fno-tree-vectorize src/example.cpp -o build/linux-example
file build/linux-example
readelf -l build/linux-example
ldd build/linux-example
./build/linux-example
```

上述为已具备GCC与目录的Linux候选命令，未执行；交叉编译须显式选匹配sysroot/toolchain，不虚构路径。先核对ELF加载器与动态库，再运行边界；Linux perf统计instructions/cycles/cache事件前查询`perf list`和权限，计量整个程序包含测试不得当纯kernel数据。生产层还需真实帧分布、长期负载、错误恢复与端到端预算；若候选尾延迟无改善则保留标量路径。当前只完成宿主证据，板端闭环未完成。

验收清单：源码合同与编译参数存档；边界/保护页/ASan通过；目标生成指令核对；目标核与频率温度记录；同输入热冷工作集及E2E对照；未达预算可回滚。面试追问：1.地址映射与对象边界有何区别？2.不对齐为什么不等于越界？3.q1和v1.16b如何对应？4.尾部为何不做掩码前超读？5.批均值P95可以说明什么？6.为何关闭自动向量化仍有NEON？

## 下一节

第10节FP32 FMA、横向归约与浮点误差：从本节精确整数逐字节相等，转向融合和归约顺序的容限合同。交付09，板端验证仍待补，不额外自测。
