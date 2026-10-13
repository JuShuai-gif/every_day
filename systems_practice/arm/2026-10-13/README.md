# 2026-10-13 ARM20：LDADD、多核计数与伪共享

## 1. 本节要学会解释的ARM问题

5–10分钟速览：接上节原子内存序，今天解释为什么相同relaxed原子加一，仅改变地址布局就可能改变多核耗时。工作参照ROCK 5B/RK3588（A76/A55），任务是相机worker统计帧数；实测在Apple Silicon Mac，未在板上运行。本课属于“正确性/约束→证据驱动优化”层，不把Mac吞吐外推Cortex。主机最终验收是总数正确、布局可追踪、实际A64指令可见；完整产品仍缺目标拓扑、长期负载、PMU与能耗。

## 2. 先看数据或状态如何变化

| 模式 | worker写地址（相对示意） | join后结果 | 要回答的问题 |
| --- | --- | --- | --- |
| packed | 0/8/16/24 | 各10万，总40万 | 不同对象共享一致性粒度是否拖慢 |
| pad64/128/256 | 0/S/2S/3S | 同上 | 布局改变是否改善；S不是通用缓存行常量 |
| true_shared | 所有人0 | 一个值40万 | 同一对象争用不能靠填充解决 |
| local | 各线程本地，末尾一次发布 | 总40万 | 仅join后可观察时是否值得减少原子频率 |

一致性以缓存行为单位并不提供C++对象生命周期或发布协议；relaxed保证原子修改序，不意味着没有一致性交互。地址相邻只是伪共享候选证据，具体物理核调度、缓存层次和采样事件仍要核查。

## 3. 最小实现怎样对应ARM机制

[src/main.cpp](src/main.cpp)的add_relaxed→实际[host.s](results/host.s)：

```asm
mov w8, #1
ldadd x8, x8, [x0]
ret
```

这是本机编译器真实生成：W8写入1并清高位，X8作为64位增量；X0指向uint64原子，LDADD执行原子读改写，旧值返回X8但调用者忽略。没有acquire/release后缀，对应本例relaxed；这不能替代上一课跨对象发布同步。LSE能力与运行CPU匹配由目标工具链/系统确认，移植不能把Mac默认指令序列直接复制到所有Armv8设备。无LSE实现可采用LL/SC或编译器outline atomics，具体以实际编译为准。

本课C++17 vector持有按alignas对齐的Cell；启动线程失败时已启动线程join后再抛出。退出后才读取计数，避免在运行中把普通local结果当实时监控值。local循环可被编译器折叠，这是减少发布次数后的合法结果，不是“同样次数LDADD更快”。

## 4. 已写好的对照与观察步骤

```sh
# 项目根；每种1/2/4线程，3次预热9次采样
sh systems_practice/arm/2026-10-13/run.sh release
sh systems_practice/arm/2026-10-13/run.sh sanitize
sh systems_practice/arm/2026-10-13/run.sh tsan
c++ -std=c++17 -O2 -S systems_practice/arm/2026-10-13/src/main.cpp -o systems_practice/arm/2026-10-13/build/observe.s
sed -n '/_add_relaxed:/,/cfi_endproc/p' systems_practice/arm/2026-10-13/build/observe.s
```

输入固定每worker10万次，计时从创建线程至全部join，包含调度/退出，不是每次原子指令延迟，也不是单请求P95。除local改变发布频率外，packed与pad使用同一个noinline原子函数。线程未绑核，运行顺序固定，频率/迁核可能混杂，不能把速度差全归因某一级cache。没有缓存事务实测前只提出一致性争用假设。

Release/ASan/UBSan/TSan均通过216整批总数与零worker拒绝。[首次日志](results/release.txt)、[格式化后日志](results/verified-release.txt)、[检查记录](results/verified-sanitize.txt)、[线程检查](results/verified-tsan.txt)。本次hw.cachelinesize查询不可用，仍展示真实地址及stride；不从计时反推出确定cache line大小。

最终独立Release复测：[原始日志](results/final-benchmark.txt)。4线程整批P50：packed 1.19892ms、pad64 0.207334ms、pad128 0.210459ms、pad256 0.20525ms、true_shared 3.40129ms、local 0.032458ms。仅宿主CPU微基准，未测GPU/NPU/端到端；9样本报告P50和max，不伪称稳定尾延迟。packed地址可能跨cache line，布局和调度均影响结果。

## 5. 工作场景排障与优化取舍

故障链一：worker从1增到4后计数变慢→packed对象地址相邻但算法独立→比较同LDADD、不同stride并在板端看peer snoop→隔离字段或分片；代价是每计数器从8B增至128/256B，缓存/TLB工作集更大，小线程无收益需保留。

故障链二：pad256仍慢→所有worker实际写cells[0]真共享→打印目标地址、保留true_shared对照→改变聚合协议，填充无效。local只保证join后准确，若监控要中途读，需设计有界刷新间隔，不能用陈旧值冒充即时统计。

故障链三：Mac更快而A55退化→指令支持/outline atomics/迁核/功耗限制不同→先核对反汇编、core topology与实际调度→使用板端编译与同口径计时，不修改内存属性尝试“关闭一致性”。

## 6. 来源、结果与下一节

2026-10-13实际读取[facebook/folly main](https://github.com/facebook/folly/blob/main/folly/lang/Align.h)中hardware_destructive_interference_size、cacheline_align_v和fallback说明，Apache-2.0；原场景是库布局常量，保留按地址减少争用的思想，独立实现线程实验，不复制库算法。注意该分支fallback对Arm使用64，不能据此推论所有Arm缓存行都是64。文件SHA256见下文，main commit未固定，读取日期/文件哈希固定内容。

一手[Arm false-sharing/SPE教程](https://learn.arm.com/learning-paths/servers-and-cloud-computing/false-sharing-arm-spe/how-to-1/)实际读到地址对照和一致性争用说明；[Arm实现依赖说明](https://learn.arm.com/learning-paths/servers-and-cloud-computing/java-detect-false-sharing/1_understand/)明确行大小由实现决定；[LSE介绍](https://learn.arm.com/learning-paths/servers-and-cloud-computing/lse/intro/)仅作能力入口。本机已生成LDADD，未执行Linux SPE。

本地补充实际读《MMU-Chapter 16 SHAREABILITY AND COHERENCY.pdf》物理页1–3（首页渲染核对），SHA256 `69439d1103179f949b9c2d675673f350b24f43ea57000abbf48aab34e8bf6987`。原文将Non-shareable简化为“memory is private to a core”；该说法不能作为C++私有对象或访问权限保证，本课不采用其属性配置建议。官方Shareability直链访问失败，详细SH/MAIR结论待核验；仅保留本次实际可证的地址、原子与共享状态，不复制PDF全文/图片。

Google组合查询成功但无采用的已核验作者案例；知乎组合搜索得到无关结果，未以其作为技术证据。对应缓存、页表属性教程仍应按[本地勘误规则](../../docs/arm/LOCAL_LIBRARY.md)使用。下一节21：大小核调度与线程亲和性，继续辨别本次未控制的调度因素。

## 7. 迁移验收与面试追问

目标板先读设备树型号、`uname -a`、`lscpu -e`与`/sys/devices/system/cpu/cpu*/cache/index*/coherency_line_size`，不硬编码A76/A55 CPU编号。已有Linux工具链下从课程目录运行：

```sh
CXX=g++ sh run.sh release
perf list
perf stat -e cycles,instructions,context-switches,cpu-migrations build/release
# 只有perf/SPE配置确认支持时才采；未支持不能写“零伪共享”
perf c2c record -- build/release
perf c2c report --stdio
```

SPE/PMU需要硬件/内核/权限支持；ROCK 5B不保证有SPE。Mac Mach-O不能当Linux ELF部署。验收记录每线程地址、CPU归属、频率温度、所有线程总数、相同时间口径；布局提高内存占用或目标P95退化则回滚。

追问：①relaxed是否消除一致性流量？②LDADD和锁保护复合不变量有什么区别？③为何alignas64不保证所有设备隔离？④真共享如何用地址确认？⑤local改变了哪种可观察语义？⑥为何一次stride测速无法推导cache line大小？

Folly Align.h实际读取字节SHA256：`09ea148632ad1ef9d96507a45188bcbb6bc2a8e3c3a6744c00e300188fcdc5d6`。
