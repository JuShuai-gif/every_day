# 2026-10-11 ARM18：页跨度、地址翻译与依赖加载

## 要解释的工作问题

承接17预取：模型权重相同的有效读取量，散落在更多虚拟页上，为什么可能变慢？本课能力层是“证据驱动定位”。场景锚定ROCK5B/RK3588或Thor CPU模型元数据读取；Mac只提供AArch64宿主证据，不外推Cortex-A76/A55或Neoverse-V3AE性能。学习目标是把有效地址拆成页号与页内偏移，区分TLB翻译缓存、数据Cache与首次触页缺页。

速览：同样262144次串行依赖加载，比较64B步幅与宿主页步幅；预先触页后再测，记录minflt；实际汇编是依赖LDR，但没有TLB PMU数据，因此只能提出翻译/Cache共同候选，不能由计时宣布TLB容量。

## 数据与状态

| 状态 | 64B步幅、4096节点 | 宿主页步幅、4096节点 |
| --- | --- | --- |
| 有效节点内容 | 每节点8B下一个偏移，共32768B | 相同 |
| 宿主页大小 | 16384B | 16384B |
| 覆盖虚拟页/保留地址空间 | 16页 / 262144B | 4096页 / 67108864B |
| 首次写入minor faults | 本次16 | 本次4096 |
| 稳态采样minor faults | 本次0 | 本次0 |

地址 `VA=VPN*page_size+offset` 是解释模型，不等于实际查询物理地址。Linux AArch64页表项8B，4KiB granule每表512项、索引9bit；16KiB每表2048项、索引11bit。层数由VA范围/配置决定，不能把Mac的16KiB套给RK3588内核，更不能把页数直接当TLB miss次数。

## 最小实现与真实ARM证据

[src/main.cpp](src/main.cpp) 的 `chase` 从 `p+offset` 读取下一个偏移。`memcpy`表达合法字节访问，编译器在这次arm64宿主上生成[host.s](results/host.s)中的：

```asm
ldr x1, [x0, x1]
subs x2, x2, #1
b.ne LBB1_1
```

X0为基址，X1既是本次地址偏移，又接收下一次偏移；因此后一地址依赖前一次load结果。X2为剩余次数，SUBS设置条件供B.NE回跳。这证明生成了串行依赖链，不能证明访问哪一级缓存。地址翻译失败可能触发页表遍历，PTE也受缓存影响；TLB不保存模型数据，minor fault是OS事件，两者不是同一计数器。

来源已读Linux v6.12：[pgtable-hwdef.h](https://github.com/torvalds/linux/blob/v6.12/arch/arm64/include/asm/pgtable-hwdef.h) 的 `PTRS_PER_PTE/ARM64_HW_PGTABLE_LEVEL_SHIFT/ARM64_HW_PGTABLE_LEVELS`（GPL-2.0-only），以及[Memory Layout on AArch64 Linux](https://github.com/torvalds/linux/blob/v6.12/Documentation/arch/arm64/memory.rst)的4K/64K布局与TTBR范围。2026-10-11实际获取阅读；本例为独立观察程序，不改编Linux内核，不执行特权寄存器指令。该旧文档部分描述止于旧架构，不能用其“最多4级”覆盖新扩展，代码中的条件宏也体现不同配置。

## 对照与运行

```sh
sh systems_practice/arm/2026-10-11/run.sh release
sh systems_practice/arm/2026-10-11/run.sh sanitize
c++ -std=c++17 -O2 -S systems_practice/arm/2026-10-11/src/main.cpp -o systems_practice/arm/2026-10-11/build/observe.s
```

节点数量1/16/256/4096，每种比较两步幅；相同seed的随机环、相同输入语义、同加载次数，先检查完整环，再预热2圈，11个采样。每样本262144次，P50/P95是每样本平均ns/load的分位数。编译器无法把依赖链自动向量化；volatile sink防止结果消除。实际逻辑读取量是每样本2MiB，不是DRAM流量。Sanitizer会改变时延，其日志只验内存正确性。

[release.txt](results/release.txt)显示4096节点64B/page步幅P50=3.18686/30.2445ns/load；不能算成板端提速。首次触页不在稳态计时内，但data Cache set冲突、工作集、页表Cache、频率仍混杂；特别页步幅固定低位可能造成set冲突。保留这个混杂作为诊断内容，没有强行给出TLB归因。n=0明确拒绝，8个环/ASan/UBSan均通过。格式化后[复验](results/verified-release.txt)相同口径P50为3.438/28.3025ns/load；初次日志保留，不择优报告。

## 排障与优化取舍

1. 首帧高、后续低→先查看minor/major faults和resident变化→如果预触页后下降，先解决按需分配/文件I/O；代价是提前驻留和启动成本，不直接加prefetch。本例触页后稳态minflt=0只排除本轮新增软缺页，不能排除TLB miss。
2. 页步幅变慢→同样数量Cache line也可能set冲突→增加页内偏移扰动、查可用L1D/DTLB事件并固定核→只有翻译事件随页数增长且Cache条件可控才支持TLB假设。用紧凑metadata减页数可能有益，但会增加packing成本。
3. 请求THP后无改善→请求不保证落实，文件/权限/内核策略均可能影响→查看Linuxsmaps中KernelPageSize/MMUPageSize/AnonHugePages，按实得状态报告；不能用madvise返回0当“大页已生效”。

## 迁移验收、来源与边界

板端先运行 `uname -a`、`getconf PAGESIZE`、`lscpu`；用本机实际安装的 `c++ -std=c++17 -O2 src/main.cpp -o build/example` 构建Linux ELF，不复制Mac Mach-O。`perf list`中查 `dTLB`、`tlb`、cache、page-faults可用事件，先以 `perf stat -e page-faults,minor-faults,major-faults ./build/example` 记录进程范围，再按真实PMU支持增补事件。若要归因一个trial，将输入参数化并隔离初始化；整进程stat不能直接贴到单个loop。PMU权限/核拓扑/thermal均未验证，无raw事件号猜测。

采用前检查：代表性工作集和零边界；实际page size；首次触页与稳态分开；固定核/频率策略并保留权限失败；增加页内offset对照消除set混杂；PMU和端到端实测无收益就保留原布局。今日没有板端部署、功耗或NPU/GPU结果。检索Google/知乎未筛得可信同条件ARM实例，见主课研究记录；不采信通用x86 TLB文章作为ARM实测。

追问：1. VA的page offset由谁定义？2. TLB与data Cache分别缓存什么？3. minor fault为零能证明TLB命中吗？4. 为何固定页步幅可能引入Cache冲突？5. 连续依赖LDR限制哪类并行性？6. 大页请求成功与实际映射有何差异？

下一节19：原子与LSE，连接语言发布规则与真实A64指令。今日只推进18。
