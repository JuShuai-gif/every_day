# 2026-10-14 ARM21：同一NEON内核的任务粒度与大小核迁移

## 1. 本节要学会解释的ARM问题

5–10分钟速览：延续ARM20的共享竞争，今天问“NEON内核相同，为什么更多worker或更粗任务仍会慢？”工作输入257行×1025 FP32，对每行计算平方和，准备给ROCK5B/RK3588 A76/A55上的CPU特征评分阶段使用。主能力层为硬件约束与证据优化，不含NPU/GPU性能。Mac提供同ISA机制和宿主调度证据，板端大小核亲和性未验；Thor Neoverse-V3AE不套用RK3588大小核分组。

## 2. 先看数据或状态如何变化

|阶段|对象|状态/成本|
|---|---|---|
|提交批次|257×1025 FP32输入|已分配，所有任务同一提交时间|
|worker取块|atomic next|grain1有257个任务，grain128仅3个|
|执行一行|q1/q2加载、v0累加|一次4个FP32，1025包含1个尾元素|
|完成批次|remaining归零|最后worker唤醒主线程，包含尾部不均衡|

一行读取两个逻辑操作数共8200B，但本例a=b，实际cache/DRAM流量不能按双倍推断。计算约2050个浮点操作。粗grain减少取任务次数，却可能只剩3个任务让4worker无法均分；异构核速度不同会进一步放大尾部。Linux capacity还受频率影响，单一capacity指标不等同某个NEON循环的真实吞吐。

## 3. 最小实现怎样对应ARM机制

[src/main.cpp](src/main.cpp) `dot`使用AArch64 Advanced SIMD `vfmaq_f32`与`vaddvq_f32`。实际Apple clang21生成[host.s](results/host.s)中：

```asm
ldr q1, [x11], #16
ldr q2, [x9], #16
fmla.4s v0, v2, v1
faddp.4s v0, v0, v0
faddp.2s s0, v0
```

前两条每次取128位并把指针加16字节；FMLA在4个32位浮点lane上累计；两条FADDP完成横向归约。v0跨迭代有依赖，更多worker是把不同的行放到核上，不能解除单行累加依赖。尾部由标量合同处理，不能把生成文件中其他可能向量化分支误作本shape实际执行。C++ mutex/cv发布任务，relaxed next只分配不重叠任务；它不承担输入发布，发布由mutex保证。NEON intrinsic与指令对应查过[ACLE](https://arm-software.github.io/acle/neon_intrinsics/advsimd.html)，具体微架构延迟未测。

## 4. 已写好的对照与观察步骤

```sh
sh systems_practice/arm/2026-10-14/run.sh
SANITIZE=1 sh systems_practice/arm/2026-10-14/run.sh
SANITIZE=thread sh systems_practice/arm/2026-10-14/run.sh
clang++ -std=c++17 -O2 -S systems_practice/arm/2026-10-14/src/main.cpp -o systems_practice/arm/2026-10-14/build/inspect.s
```

同输入、同NEON函数比较worker1/2/4与grain1/16/128，持久worker不把线程创建混入batch计时。每组合3次预热15批，double标量oracle检查所有行。任务queue是统一批提交到该任务开始的等待，exec是该任务整个chunk执行；统计跨15批的任务样本，不是单帧服务P95。batch含唤醒、争用、执行与完成通知。计时插桩对小grain干扰更明显，必须保留这个混杂因素。

首次[真实结果](results/first-release.txt)4worker grain1/16/128 batch P50为42.208/31.583/44.25µs；grain128退化保留。最终格式化后、避开其他本次测试进程的复测[release.txt](results/release.txt)为40.834/31.625/47.25µs，仍保留退化；中间并行验证日志另存release-concurrent.txt，不能据不同运行频率混算收益。未验证board、PMU、温控和能耗，不把Mac核数当Cortex拓扑。

Linux板端现成流程（Mac未运行）：

```sh
cat /proc/device-tree/model
uname -a
lscpu -e=CPU,CORE,SOCKET,ONLINE,MAXMHZ
cat /proc/self/status
# 查看Cpus_allowed_list，并查每核topology、cpu_capacity与cpufreq；没有字段就保留缺项
CXX=g++ sh systems_practice/arm/2026-10-14/build.sh
: "${CPU_LIST:?填入实际允许且核型已核实的核组}"
taskset -c "$CPU_LIST" systems_practice/arm/2026-10-14/build/main
```

taskset为进程及继承线程限制可用核集合，不是把每个worker固定到唯一核。程序Linux分支记录每任务开始/结束的`sched_getcpu`，只能发现端点变化，中间迁移仍可能漏报；Mac输出observed=0表示未观测，不是0次迁移。

## 5. 工作场景排障与优化取舍

①worker增加但exec差不多、queue升高→候选是嵌套线程池、CPU配额或唤醒竞争→查线程数/cpuset/上下文切换，同时固定内部BLAS线程→限制并行层级→回归同一批次的queue和batch，不能仅看内核平均。

②大grain批次尾部拖长→候选是任务太少或弱核处理重块→核对任务数与端点CPU、先同核组对照→改为动态小块或控制重任务核组，代价是更多原子/调度→以热稳态P95及功耗决定。这里只实测粒度退化，未实测弱核因果。

## 6. 来源、结果与下一节

实际读取[ncnn src/cpu.cpp](https://github.com/Tencent/ncnn/blob/master/src/cpu.cpp)，master/2026-10-14：`set_cpu_powersave → get_cpu_thread_affinity_mask → set_cpu_thread_affinity → set_sched_affinity`，Linux路径调用sched_setaffinity，OpenMP分支为worker应用策略，Apple另走实现。BSD-3-Clause LICENSE.txt已读。源用于解释平台亲和性接口，本例线程池和NEON评分是独立实现，没有复制ncnn线程池或声称运行其库。源码快照SHA256见本页末尾实际记录。

官方[Linux capacity文档](https://docs.kernel.org/scheduler/sched-capacity.html)§1–3说明微架构/频率及task utilization，已读；[ROCK5B产品说明](https://docs.radxa.com/en/rock5/rock5b/getting-started/introduction)核对RK3588 A76/A55。本机未获取板端镜像/SDK/拓扑。按本地资料规则审查了适用性：当节重点调度与任务粒度，未选MMU/屏障PDF，不宣称新读本地PDF。

宿主Release、ASan/UBSan、TSan与汇编状态见results真实日志；目标Linux/板端仍待验。没有新增ARM日期JSON。下一节ARM22：GEMV与小Batch GEMM，把本节调度开销纳入算子选择。

## 7. 迁移验收与面试追问

验收核型/可用核/频率、C++17 Linux ABI和动态库、相同输入oracle、单核组与跨核组、线程数/粒度扫描、热稳定和业务E2E；收益消失时回退低并行度。追问：①相同FMLA为何不代表相同吞吐？②queue与exec怎样划界？③grain128为何可能闲置worker？④relaxed next为何不负责发布输入？⑤taskset与单worker绑核有何不同？⑥端点CPU相同能证明未迁移吗？

## 8. 工作能力与部署闭环

本课留下NEON→真实A64→正确性→粒度测量这段证据，能够帮助定位CPU评分阶段。完整板端部署还需要AArch64 Linux工具链/sysroot、ELF加载器和依赖检查、真实核拓扑、采集到推理的时序及长时运行；Mac Mach-O不能直接部署为Linux二进制。无板卡时不标完整闭环。

源码快照：ncnn cpu.cpp SHA256 `d906c15835cfd281de69905e04e75586bea126f39853ba19de4c08a5d604c305`；读取2026-10-14/master；实际汇编host.s仅保留dot函数片段，完整再生于build。
