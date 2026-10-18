# 2026-10-18 OS19：mmap驻留与首次触页

## 承接与边缘问题

承接设备提交/完成的分离，本课两个主题为19a映射与驻留、19b首次触页与预热。模型服务分配了输入arena，不代表每页都已建立可访问的驻留映射；“构造耗时很短”不等于首帧不会承担缺页成本。现成程序申请2048页匿名私有内存，依次只读、逐页写、再次写，查询驻留与进程缺页计数。本课不实现模型文件加载，不涉及GPU虚拟内存。

## 主题一：映射与驻留

`mmap`建立地址空间合同，`mincore`报告调用时的驻留快照；驻留不是锁页承诺，也不等于页表/TLB/CPU cache都已热。指针合法、页面驻留、设备能访问是三个不同条件。`Mapping`拥有映射，析构检查munmap错误；0字节在接口和实际系统调用两层验证拒绝。页大小用sysconf读取，不写死4KiB。

## 主题二：首次触页和预热

Linux v6.12 `do_anonymous_page`对合适的只读匿名缺页可建立特殊零页PTE；写缺页则申请私有folio并安装可写PTE。预读不一定预付全部首次写成本，且THP/mTHP等使“一个访问一次fault”不可靠。xv6的`vmfault`检查范围、分配、清零并映射，失败回收；它没有复现Linux零页、回收、NUMA和复杂folio策略。

我们观察的是宿主内核，不能要求Mac按Linux分支执行。程序逐页访问一个字节而非完整内存带宽测试；`volatile`保证访问发生，不提供线程同步。`getrusage(RUSAGE_SELF)`的minor/major为进程累计差分，可能包含日志/运行库活动；墙钟含被调度等待，进程CPU时间按平台分辨率累计。Sanitizer运行会扰动fault/地址空间，不能用其数字作性能结论。

## 源码与平台差异

今日实际读[Linux v6.12 mm/memory.c](https://github.com/torvalds/linux/blob/v6.12/mm/memory.c) `do_anonymous_page`的读零页、分配folio、安装PTE和OOM分支；GPL-2.0-only内核，不复制实现。另读[xv6-riscv riscv/kernel/vm.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/vm.c) `vmfault/ismapped`（2026-10-18分支快照，精确commit未固定，MIT）。独立POSIX观察程序，非内核补丁。[mmap](https://man7.org/linux/man-pages/man2/mmap.2.html)和[mincore](https://man7.org/linux/man-pages/man2/mincore.2.html)官方接口手册已读；getrusage网页请求失败，实际宿主调用/头文件可编译不替代Linux运行证据。

按本地资料规则，用pypdf只读`MMU-Chapter 26 Debugging Tools, Tracing & Instrumentation.pdf`物理第1页（18页中1页），SHA256 `08f5044cf5d890eca5d746d85887aeed505000d58aebd2c0919f5203764bb0b5`。该页自称RTOS/QNX风格MMU调试提纲，未给出本课Linux计数器语义；不把它当Linux接口说明。缺pdftoppm/fitz，未渲染，未声称读完整章。书籍原文没有改动/复制进仓库。详见[source.json](source.json)。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-18/run.sh release
sh systems_practice/os/2026-10-18/run.sh sanitize
# Linux/ARM板端候选，先确认perf事件/权限：
CXX=g++ sh systems_practice/os/2026-10-18/build.sh release
perf stat -e page-faults,minor-faults,major-faults systems_practice/os/2026-10-18/build/release
```

Linux命令未运行。不要为测冷启动全局清page cache；独立新映射已经定义了本例初始条件，但不能保证系统其余状态相同。要建立分位数须多次新进程/新映射并固定系统负载；本次三个phase是观察样本而非统计基准。

## 实际结果与验证边界

Mac页16384B，2048页共32MiB：初始resident=0；读后resident=2048且minor增2048；两个写阶段minor增0，checksum均261120。Release原始墙钟读1499.71µs、首次写340.417µs、再次写13.042µs，仅是一次运行，不能归因全部差异为缺页（写阶段缺页都为0）。[results/release.txt](results/release.txt)保留CPU时间和major=0；[ASan/UBSan](results/sanitize.txt)通过。源码阅读/固定版本/宿主/目标分别见[verification.json](verification.json)。xv6/QEMU/Linux/ROCK 5B均未运行。

## 工业故障与迁移

1. 首帧慢、后续正常→页错误、cache、模型初始化均是候选→分段计时加minor/major差分判别→把所需读/写预热放在接流量前；代价是启动时延和驻留内存提前支付，不能只做一次mmap。
2. 映射成功后仍OOM/被终止→虚拟承诺不等于物理保证→在受控小规模观察首次写、OS内存压力/限制→设arena/在途上界、逐步接纳流量；不要在生产用超大分配证明OOM。
3. mincore=resident仍有延迟尖峰→驻留与TLB/cache/调度混淆→独立记录CPU时间、墙钟和故障计数→按证据选择预热/调度；mlock有权限和系统预算成本，本课未调用。

迁移验收：实际页大小和THP策略、内存限制、NUMA/核亲和性、模型读取路径、首帧/稳态分段；记录counter权限而非把不可用当0。

追问：mmap成功保证什么？mincore为何不是锁页？读预热和写预热是否等价？minor/major区别是什么？为什么Mac结果不能验证Linux零页？墙钟与进程CPU时间何时相差很大？如何在不清系统缓存的情况下重复冷映射观察？

## 下一节

20：亲和性/核拓扑与上下文切换/运行队列，接着解释缺页不多但尾延迟仍高的情况。
