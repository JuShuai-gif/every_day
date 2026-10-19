# 2026-10-19 OS 第20课：亲和性与调度证据

## 承接与边缘问题

承接19的首次触页。今天20a亲和性与核拓扑，20b上下文切换和运行队列。RK3588预处理worker增多却尾延迟恶化：先验证允许在哪些核运行，再观察CPU时间、等待和调度事件。10–15分钟速览；附加现成例子不新增作业。

## 主题一

Linux线程的允许CPU集合由用户掩码、cpuset与在线状态共同约束。读`kernel/sched/syscalls.c`中`SYSCALL_DEFINE3(sched_setaffinity)`→`sched_setaffinity`→`__sched_setaffinity`：用户mask复制、任务/权限校验、与cpuset相交、设置后再检查并发cpuset变化。亲和性允许集合不等于CPU独占，不会阻止中断/抢占。`pid=0`针对调用线程；新线程继承创建者mask，所以示例先限制主线程，再创建worker，退出恢复原mask。

## 主题二

Linux `core.c::__schedule`从本CPU的rq取prev，通过状态与抢占原因选择nvcsw/nivcsw路径，选next，记录`trace_sched_switch`再`context_switch`。计数不是运行队列等待时间，更不是每次切换的成本。`getrusage(RUSAGE_SELF)`给进程累计CPU/切换计数；wall包括线程启动/排队/join，CPU跨核求和，数值可大于wall。

xv6 `proc.c::scheduler/sched/yield`扫描RUNNABLE进程并swtch；是教学状态迁移对照，不包含Linux cpuset/异构容量策略/EEVDF。Mac对应的rusage是宿主观察，不宣称采用相同Linux调度路径。

## 源码与平台差异

实际读[Linux v6.12 syscalls.c](https://github.com/torvalds/linux/blob/v6.12/kernel/sched/syscalls.c)亲和性实现和[core.c](https://github.com/torvalds/linux/blob/v6.12/kernel/sched/core.c)`__schedule`选段（GPL-2.0-only）；[xv6-riscv riscv分支proc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/proc.c)400–530行（MIT，读取2026-10-19，commit未固定）。[source.json](source.json)记blob。独立C++观察例，不复制内核代码、不修改xv6。

## 现成观察示例与命令

[src/main.cpp](src/main.cpp)：固定200000份整数工作，每份32次无符号混合；1/2/4/8线程分片，sum与串行oracle比较。0工作、4线程分3份和0线程拒绝。RAII join保证部分创建失败时已建线程仍回收；每线程只写自己的结果槽，没有共享累加数据竞争。

```sh
sh systems_practice/os/2026-10-19/run.sh
MODE=sanitize sh systems_practice/os/2026-10-19/run.sh
MODE=tsan sh systems_practice/os/2026-10-19/run.sh
# 以下只在Linux目标板运行，先查询，不预设哪个CPU是A76
uname -a
lscpu -e=CPU,ONLINE,CORE,SOCKET
cat /proc/self/status
for f in /sys/devices/system/cpu/cpu*/cpu_capacity; do test ! -f "$f" || cat "$f"; done
CXX=g++ sh systems_practice/os/2026-10-19/run.sh --pin
```

`--pin`选当前allowed中的第一个，**只用于人为制造竞争**，不是择优大小核算法。固定cpu_set_t仅支持CPU_SETSIZE范围；更大内核mask会返回错误，升级CPU_ALLOC接口后再部署。Mac明确拒绝--pin。

Linux进一步：`perf list`→`perf stat -e context-switches,cpu-migrations,task-clock -- build/release/practice --pin`；需更长负载后用`perf sched record -- build/release/practice --pin`、`perf sched timehist`看每个TID等待/运行片段。权限失败记原错误。核实`/proc/PID/task/TID/status`的允许集合，结合`/proc/PID/schedstat`时长（要求内核支持），不可把nvcsw差值解释为runqueue长度。命令应在本课目录执行。

## 实际结果与验证边界

[release](results/release.txt)、[sanitize](results/sanitize.txt)实际校验通过；TSan见[记录](results/tsan.txt)。Mac没有Linux affinity接口；`--pin`拒绝日志在[negative.txt](results/negative.txt)。计时是一组观察，含启动/join与系统噪声，不提供P95/收益结论。编译、运行、源码阅读已做；Linux/板端、QEMU/xv6编译未做。[verification.json](verification.json)。

## 工业故障与迁移

1. 写死CPU4后启动失败→容器cpuset不允许或核离线→先读allowed集合和errno，再读核拓扑→选交集/保守回退；绑定减少调度自由度，应回归热态和服务E2E。
2. 增线程后CPU利用率高但响应差→运行队列竞争、内存瓶颈或小任务启动成本→固定总工作量，对照1线程/单核多线程并看timehist与PMU→降低线程数或复用池；不要仅看context-switches就下因果结论。

迁移验收：实际板型/OS/kernel、allowed/capacity、线程范围、checksum、错误退出、CPU和wall边界、热稳定与请求分布。追问：affinity为什么不独占？cpuset变化如何与设置竞争？进程CPU为何可能超过wall？自愿切换是否等于锁等待？runqueue延迟如何采集？为何xv6策略不能代表Linux？

## 下一节

21：C++谓词等待与Linux阻塞/退出协议，承接调度观察到应用关闭边界。
