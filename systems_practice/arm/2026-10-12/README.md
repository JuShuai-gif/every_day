# 2026-10-12 ARM19：发布、复用与LSE原子路径

## 本节要解释的问题与速览

承接18课页跨度，今天转向多核共享输入：生产者填好一块传感器帧后，消费者看到ready是否必然看到帧？消费者读完后，生产者何时能复用？5分钟速览先看下面两条同步边，再运行现成例子。工作能力层为“硬件约束下写对并发”，不是性能优化验收。

板端参照ROCK 5B/RK3588的A76/A55 CPU；产品关系复用已核实[板卡表](../../docs/arm/BOARDS.md)，今天没有实际板卡/OS镜像或核拓扑记录。Mac arm64是本机证据。程序传送两个uint64字段，单槽、单生产者/消费者，基线seq_cst与候选release/acquire使用完全相同payload，测试0、1、10000轮。这里的候选减少语义约束，不承诺变快。

## 状态变化与机制推导

| 状态 | 独占方 | 操作 | 交接 |
| --- | --- | --- | --- |
| ready=0 | 生产者 | 写sequence/checksum | store(1,release) |
| ready=1 | 消费者 | load(acquire)观察1，读两字段 | store(0,release) |
| 再次ready=0 | 生产者 | load(acquire)观察0 | 下一轮才能覆盖 |

第一条同步边发布payload；第二条保证复用不会覆盖尚未读完的对象。只有ready是原子的，payload不用原子是因为严格交替所有权。不能把第一条边的正确性推广成整个可复用槽正确；也不能把relaxed RMW的原子性当作payload发布保证。

C++17保证来自release写被acquire读到形成的synchronizes-with，以及顺序程序中的先后关系。`std::thread`启动/合并也有同步保证，但这里每轮通信仍依赖ready。ARM是弱序架构，编译器选择指令映射；OS安排在哪个核运行，ISA不承诺等待公平性。线程长期未调度时忙等会拖慢整个管线。

## 代码到真实ARM证据

[src/main.cpp](src/main.cpp) 中 `observe/publish/ticket` 用noinline隔离观察。Apple Clang21 `-O2` 实际生成：[native.s](results/native.s)。

```asm
_observe:
    ldapr w0, [x0]
_publish:
    stlr w1, [x0]
_ticket:
    mov w8, #1
    ldadd w8, w0, [x0]
```

`x0`是原子对象地址；W寄存器对应32位int。`STLR`发布新flag；本机编译器选`LDAPR`读取acquire，而非教科书常见`LDAR`，这是目标特性/RCpc路径差别，不能把字面指令名当C++内存序证明。`LDADD`一次原子读改写并把旧值放w0；没有acquire/release后缀的计数器操作只提供本例要求的relaxed原子性。它并不自动发布另外的两个字段。

[atomic_probe.cpp](src/atomic_probe.cpp)是不依赖sysroot头文件的Clang扩展编译探针，Linux A64实际生成：[基线](results/linux-armv8a.s)与[LSE](results/linux-lse.s)。两者没有链接或板端执行。

```asm
// Linux armv8-a：probe_acquire为ldar；probe_release为stlr
// probe_ticket：失败状态不为0时重试
ldxr w8, [x0]
add w9, w8, #1
stxr w10, w9, [x0]
cbnz w10, .LBB2_1
// Linux armv8.1-a+lse的同一RMW：
mov w8, #1
ldadd w8, w0, [x0]
```

Exclusive monitor被干扰可令STXR失败；重试次数不是固定周期。LSE把RMW表示为单条指令，缓存行争用和互连传递仍存在，不能用指令数预测延迟。Linux v6.12 `atomic_lse.h`的`ATOMIC_FETCH_OPS(add,ldadd)`按relaxed/acquire/release添加空/a/l/al后缀；`atomic_ll_sc.h`保留exclusive重试，这是实际读到的内核实现对照，不是本机libc++代码。

## 已写好的观察步骤与结果

```sh
sh systems_practice/arm/2026-10-12/run.sh
cd systems_practice/arm/2026-10-12
clang++ -std=c++17 -O2 -S src/main.cpp -o build/native.s
clang++ -std=c++17 -target aarch64-linux-gnu -march=armv8-a -mno-outline-atomics -O2 -S src/atomic_probe.cpp -o build/base.s
clang++ -std=c++17 -target aarch64-linux-gnu -march=armv8.1-a+lse -mno-outline-atomics -O2 -S src/atomic_probe.cpp -o build/lse.s
```

Mac Release/ASan/UBSan/TSan均通过；传输20002次、两个零轮次、1000个旧值检查、负数批次拒绝；`lock_free=1`仅针对本机int对象。真实日志：[release](results/release.txt)、[sanitize](results/sanitize.txt)、[TSan](results/tsan.txt)。初次只给Apple目标加`-march=armv8-a`仍生成LDAPR/LDADD，原输出保留[armv8a.s](results/armv8a.s)；改用明确Linux目标的无头文件探针后获得LL/SC对照。这一失败对照说明“看命令行猜指令”不可靠。

运行时负数批次会被拒绝；非原子payload配合relaxed flag的错误方案仅作语义分析，不实际运行数据竞争来证明硬件弱序。TSan通过只覆盖本次执行，既不证明内存模型，也不证明无饥饿。未计时，无GPU/NPU/端到端数字。

## 故障链与工程取舍

1. 序号正确而checksum偶发旧值→可能发布边缺失或多个生产者破坏单槽合同→先核对读到的release写、线程角色和TSan→保留release/acquire并验证10000轮；真实多生产者应换经过证明的队列，不能仅把flag改atomic就交付。
2. 首次读正确、后续偶发覆盖→只有生产者发布，缺消费者归还同步→画第二条HB边，观察输入是否仍在读取→增加反向release/acquire；代价是每帧两次交接。
3. LSE版本没有更快→可能真共享缓存行、线程抢核、调度等待→先采板端拓扑/上下文切换与争用，别从LDADD推断收益→降低共享更新频率、批处理；改变统计延迟需产品允许。

## 来源、本地资料核验与迁移

本次实际读取：Linux v6.12 [atomic_lse.h](https://github.com/torvalds/linux/blob/v6.12/arch/arm64/include/asm/atomic_lse.h) 的`ATOMIC_FETCH_OPS`，以及 [atomic_ll_sc.h](https://github.com/torvalds/linux/blob/v6.12/arch/arm64/include/asm/atomic_ll_sc.h) 的`ATOMIC_OP/ATOMIC_FETCH_OP`；GPL-2.0-only，原场景是内核原子原语。本例独立实现，只保留发布/原子性的区分，没有复制内核代码。另读[Arm LSE官方教程](https://learn.arm.com/learning-paths/servers-and-cloud-computing/lse/intro/)“Introduction”和ISA支持段：LSE在Armv8.1-A引入，不能按品牌默认可用。教程性能叙述不能替代本课实测；它泛称返回更新值，本课fetch_add明确按C++合同返回旧值。官方LDAPR单页访问失败，未声称读过；本机映射仅为编译观察。

本地`Memory Barrier/ARM64 Memory Barriers..pdf`，SHA256 `570c3452d3e58e9258b86759f0bc3a76328e44e9fb5a5ffab3fae0dfd11c9776`：实际读物理页1–3目录/概述及页9第5.4节，并渲染检查页9。其CPU→CPU数据配方列`DC CVAC; DSB ISH`，不能当成本课普通一致性内存的C++跨线程发布方案；本例用语言原子和编译器映射，无需用户态手写缓存清理。该配方未定义同步变量/接收方合同，不足以证明HB。许可未确认，只记短摘要，不复制PDF；自修改代码/DMA亦不能套用到此例。

Google直接检索端点失败；知乎LSE查询未找到足够相关原作者实现，未采纳二手性能。迁移到板端先保存`uname -a`、`lscpu`与`/proc/cpuinfo`，检查`atomics`及每类核能力，用原生`c++ -std=c++17 -O2 -pthread`构建再反汇编。Apple Mach-O汇编不能直接部署Linux；无sysroot探针也不是完整ELF产品。验收应覆盖多次退出、异常、单生产/消费者合同、目标TSan支持和持续负载；发现退化保留seq_cst或更高层阻塞队列。

追问：原子性与可见性有什么区别？为什么必须有归还边？LSE返回哪个值？STXR为何可能失败？LDAPR与LDAR能否仅凭名称推断C++保证？TSan通过遗漏哪些风险？何时忙等应换阻塞等待？

下一节20：真共享与伪共享，把今天的原子访问接到缓存行争用分析；今天不提前推进。
