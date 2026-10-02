> 2026-10-02并发游标纠正：本页是补充材料，不计本日正式课程、不增加必做作业；请从[正式ARM第10课](session-02/README.md)开始。旧源码、来源与日志全部保留。

# 2026-10-02 ARM09：NEON向量宽度与安全尾部

## 1. 本节要解释的ARM问题

承接08自动向量化：当相机一行只有17个字节时，128位NEON最后一次load到底读哪些地址？5–10分钟先看下面地址图和真实汇编，再读排障与迁移。任务为每个uint8元素加1，按模256回绕，不是饱和加。源/目标不重叠或完全原地可用，**部分重叠不在合同内**。本例使用独立缓冲进行公平对照；板端输入可是一行图像，跨行stride需调用方逐行处理。

能力层3（证据驱动优化）同时涉及层2边界正确性。目标场景是ROCK5B/RK3588的帧处理前段；本机仅Apple arm64，不是A76/A55板端吞吐证明，也不改变CUDA固定Thor规则。

## 2. 数据如何变化

n=17的示意，s表示起始字节地址：

| 阶段 | 地址范围 | 操作 | 下一索引 |
| --- | --- | --- | --- |
| i=0，剩余17 | s+0..s+15 | vld1q_u8→16 lanes加1→vst1q_u8 | 16 |
| i=16，剩余1 | s+16 | 标量ldrb/add/strb | 17 |
| 退出 | s+17不读取 | n-i=0 | 完成 |

n=15时不进入向量循环。循环条件`n-i>=16`在不变量i≤n下安全，避免`i+16`溢出。16字节lane图是内存到V寄存器的视图，不是16个CPU线程。分配内padding、页内可访问和C++对象有效范围是不同边界；即使读了合法映射的下一个字节，也不代表属于当前输入。

## 3. 实现与真实指令对应

[src/example.cpp](src/example.cpp)中的neon与scalar数学一致；`checked`拒绝容量不足、非零长度空指针。RAII Guard用mmap/mprotect制造紧靠不可访问页的输入，**只执行正确实现**，不运行越界坏代码。

[本机实际汇编](results/host-arm64.s)的`_neon`核心：

```asm
ldr q1, [x0, x8]
add.16b v1, v1, v0
str q1, [x1, x8]
```

q1一次加载128bit，`add.16b`在16个8bit lane内回绕加法；x8每次加16。尾部实际出现`ldrb w11,[x8],#1`和`strb w11,[x10],#1`，每次仅一字节。`cmp x9,#15`与条件分支保证不足16走尾部。不是预期汇编摘抄；由Apple clang21 `-O2 -fno-vectorize -fno-slp-vectorize`本轮生成。禁自动向量化使scalar成为明确基线；不声称它代表优化过的系统memcpy。

## 4. 已写好的对照与运行

```sh
# 本课目录，无依赖安装
sh run.sh
```

Release和ASan/UBSan各检查4128种长度/offset（0..257 × 0..15），目标两端哨兵；8种guard-page尾部；非法容量拒绝。精确源分配配合ASan抓对象尾超读，guard page另抓跨页访问；两者互补，不互相替代。偏移改变自然对齐但仍访问普通内存，不代表Device memory可任意非对齐。

单线程4097B热数据，20组预热100组采样，每组128次，输出是**每组均值的P50/P95**，不是单请求尾延迟。真实结果见[host.txt](results/host.txt)。本轮初次Release scalar/neon P50为0.963547/0.0686797微秒；该运行和其他CPU检查同批进行，故仅作功能/观察证据，不作为隔离性能结论。最终格式化后复测另存日志。逻辑每次读写2n=8194B，不是实测DRAM流量；工作集热缓存，禁止计算后称外部内存带宽。

## 5. 排障与取舍

故障一：随机小宽度在页边界崩溃→怀疑末尾仍做16B load→检查n=15/17和精确分配→限制完整向量循环后逐字节尾部→多最多15次标量操作，回归guard page与ASan。故障二：将255变成255而不是0→把vaddq换成vqaddq饱和加→对照输入250..255及标量模256语义→统一合同→不要通过放大容差掩盖整数语义错误。

故障三：借用memcpy头尾重叠加载技巧做**原地加1**，重叠部分加了两遍→跟踪17B的头16/尾16地址集合→操作非幂等，不能机械照搬copy重叠写入→保留不重叠tile加scalar尾；性能可能略低但语义明确。小n的启动与分支可能使NEON无收益，不以大n单点外推。

## 6. 来源与验证

2026-10-02实际阅读[Arm optimized-routines](https://github.com/ARM-software/optimized-routines) master：[string/aarch64/memcpy.S](https://github.com/ARM-software/optimized-routines/blob/master/string/aarch64/memcpy.S)的`__memcpy_aarch64`、copy16/copy8/copy4、copy_long/copy64_from_end。许可证MIT OR Apache-2.0 WITH LLVM-exception，精确commit未获取。它按size选择合法头尾读取，原文件主要是通用X寄存器装载，不应叫NEON kernel。本例是独立NEON变换，借鉴边界分派思想，省略memmove方向判断/64B流水，未复制源码或复现其性能。

Google/知乎检索未取得可采用的对应全文，不声称博客已读；AArch64行为以已读源码和本机实际指令为据。先前本地ARM PDF主要VA/cache提纲与本节无直接对应，不引用或宣称新读PDF。日期目录不生成JSON，来源/验证均在此及文本日志。

## 7. 迁移验收与追问

ROCK5B板端先执行`uname -a; lscpu; clang++ --version`确认OS、核拓扑和工具链；在已准备AArch64 Linux环境用同一build.sh运行，检查实际`-target`/sysroot及动态依赖，Mac Mach-O不能拷过去运行。按可用CPU亲和性分A76/A55分别测，核ID从现场查询；监测温度频率，保留尾部/对齐/哨兵/ASan回归，若真实端到端无收益则采用scalar或已有库。当前Linux/ROCK5B部署、热稳态、功耗和PMU均未验证，绝不标完整产品闭环。

追问：①q寄存器宽度与lane宽度的区别？②为何n-i写法仍需i≤n不变量？③ASan与guard page各抓什么？④头尾重叠copy为何不能直接变成原地加法？⑤普通内存非对齐与Device memory区别？⑥批均值P95能否当帧P95？

## 8. 下一节

ARM10进入浮点FMA与归约顺序：从今天位精确整数合同过渡到有舍入的浮点合同，不提前推进10。本节证据为正确性、实际指令和宿主有限测量；部署/测量/长期稳定的板端环节仍缺失。
