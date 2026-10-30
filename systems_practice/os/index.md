# 每日 OS 索引

每天一节、两个相关主题，估计阅读/观察10–15分钟，随既有北京时间08:30任务交付。[路线](../docs/os/README.md) · [28节/56主题课程表](curriculum.json) · [进度与待补](progress.json)。

| 日期 | 节次与两主题 | 已验证 | 待验证 |
| --- | --- | --- | --- |
| [2026-09-28](2026-09-28/README.md) | 01：系统调用边界 + FD共享状态 | 网页实现已读；Mac C++17 Release/ASan/UBSan五组检查通过 | 精确commit、xv6/QEMU、Linux与板端；[记录](2026-09-28/verification.json) |
| [2026-09-29](2026-09-29/README.md) | 02：fork状态复制 + exec映像替换 | Mac Release/ASan/UBSan成功/失败两路径通过；源码已读 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-29/verification.json) |
| [2026-09-30](2026-09-30/README.md) | 03：exit资源释放 + wait僵尸回收 | Mac Release/ASan/UBSan：exit37/SIGKILL9、EOF、WNOWAIT、ECHILD通过 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-30/verification.json) |
| [2026-10-01](2026-10-01/README.md) | 04：trapframe现场 + 系统调用返回 | 宿主状态模型/EBADF，Release/ASan/UBSan通过；xv6源码已读 | commit、xv6/QEMU/Linux/板端待验；[记录](2026-10-01/verification.json) |
| [2026-10-03](2026-10-03/README.md) | 06：walk多级索引 + 映射权限与解除映射 | C++17 Release/ASan/UBSan，手算地址、1025跨叶映射与失败边界通过；本地PDF页5勘误核实 | xv6/QEMU/Linux/板端与精确commit待验；[记录](2026-10-03/verification.json) |

下一节：**26**（按progress.json继续）。

2026-10-09：[第12课：可运行/运行/睡眠状态与上下文切换](2026-10-09/README.md)。Mac 状态模型通过；xv6 源码已读，QEMU/Linux/板端未验证。

2026-10-02正式交付：[05 页分配器空闲链表与失败回滚](2026-10-02/session-02/README.md)。Mac Release/ASan/UBSan通过；源码已读，Linux/板端未验。[并发旧游标补充](2026-10-02/README.md)保留但不计新课。

2026-10-04正式交付：[07 copyin/copyout＋跨页边界](2026-10-04/README.md)。Release/ASan/UBSan 2450区间/部分复制/事务回滚通过；xv6源码与本地PDF页1已读；QEMU/Linux/板端未验。

2026-10-05正式交付：[08 地址空间增长＋首次触页；4098 size、deferred OOM、映射回滚/洞/缩堆通过；xv6真实lazy源码已读，QEMU/Linux/板端待验。](2026-10-05/README.md) Release/ASan/UBSan通过。

2026-10-06：[OS09 共享只读页与COW引用计数](2026-10-06/README.md)。4096偏移/注入OOM与多代回收通过，Release/ASan/UBSan；独立宿主模型，COW为MIT实验扩展，非xv6默认实现，QEMU/Linux/板端未验。

2026-10-07：[OS10 原子互斥与嵌套关中断：40000更新/异常释放/两初始状态，Release/ASan/UBSan/TSan通过；中断只是宿主模型，xv6/QEMU/板端未验。](2026-10-07/README.md)

2026-10-08：[第11课：谓词等待与丢失唤醒](2026-10-08/README.md)。Mac C++17 Release/ASan/UBSan/TSan通过；实现已读，目标板未验证。20000有序传递、噪声通知及关闭排空通过；xv6/QEMU未运行。

2026-10-11：[第13课：管道背压与端点关闭](2026-10-11/README.md)。真实Mac pipe填满/排空65536B，EAGAIN/dup阻止EOF/最后关闭EOF/EPIPE，Release/ASan/UBSan通过；xv6/QEMU/Linux/板端待验。

2026-10-12：[第14课：睡眠锁与锁顺序；真实读新版sleep_prepare调用链，C++租约20000更新/ref=0、反向锁拒绝与异常释放，Release/ASan/UBSan/TSan通过；xv6/QEMU/Linux/板端未验。](2026-10-12/README.md)

2026-10-13:[第15课：FD/file/inode与名字/引用寿命。真实Mac dup偏移、rename旧句柄、unlink后读及原地写反例，Release/ASan/UBSan通过；xv6/QEMU/Linux/板端未验](2026-10-13/README.md)。

2026-10-14：[OS16：缓存身份pin与每块内容锁](2026-10-14/README.md)。等待者ref、耗尽/复用、20000更新、Release/ASan/UBSan/TSan通过；xv6 bio.c已读，QEMU/Linux/板端未验。

2026-10-15：[OS17：日志事务与崩溃恢复](2026-10-15/README.md)。7崩溃点/恢复幂等/错误写序与坏header，Release/ASan/UBSan通过；教学状态模型，真实持久性及xv6/QEMU/Linux/板端未验。下一节18。

2026-10-17：[第18课](2026-10-17/README.md)。virtio提交与中断完成：2000复用/4拒绝与失败/关闭，Release/ASan/UBSan/TSan通过；xv6源码已读，QEMU/Linux/板端未验。下一节19。

2026-10-18：[第19课](2026-10-18/README.md)。mmap驻留/首次触页；Mac2048页初读minor2048、之后两轮写minor0，checksum通过；Release/ASan/UBSan通过。Linux源码已读，Linux/xv6/板端未验；一次观察不是性能分布。下一节20。

2026-10-19：[第20课](2026-10-19/README.md)。亲和性/核拓扑与切换/运行队列；固定工作量1/2/4/8线程checksum、空/不均匀/拒绝，Release+ASan/UBSan/TSan通过；Mac观测不是Linux因果或P95，Linux/板端待验。下一节21。

2026-10-21：[第21课：等待谓词与futex丢失唤醒边界](2026-10-21/README.md)。40轮、200完成/160预期异常，空队列仍有在途任务/关闭排空/拒绝边界；Release/ASan/UBSan/TSan通过。Linux futex/xv6/板端未验。 下一节22。

2026-10-22：[第22课](2026-10-22/README.md)。epoll就绪/字节流状态机；Mac3帧、2拒绝、65536B背压验证通过Release/ASan/UBSan；Linux ET/LT未验。 下一节23。

2026-10-23：[第23课：DMA地址与同步所有权](2026-10-23/README.md)。Linuxv6.12映射/同步源码已读；独立合同模型1001周期/6拒绝/live0通过Release+ASan/UBSan；非真实DMA、Linux内核或板端验证。下一节24。

2026-10-24：[第24课：异步完成与租约回收](2026-10-24/README.md)。CUDA Samples v13.0源码已读；1000周期/5099拒绝，400交付、600放弃/失败，Release+ASan/UBSan通过。Thor SDK缺nvcc未验；下一25，实际核验10月25。

2026-10-26：[OS25：映射/读取选择与文件更新寿命](2026-10-26/README.md)。Linuxv6.12 VMA引用与rename选段已读；旧/新映射、unlink存活、空文件拒绝和ENOENT通过Release/ASan/UBSan。无性能、断电/Linux/板端验证，下一26。

2026-10-27：[OS26：端到端延迟归因](2026-10-27/README.md)。Linux v6.12 perf-stat/hrtimer 与 xv6 trap 路径已读；宿主分段观察 Release/ASan/UBSan 通过，不报告P95或Linux/板端结果；下一课按索引继续。


2026-10-28：[OS27：长期运行与故障恢复](2026-10-28/README.md)。xv6-riscv proc.c/proc.h 实际阅读；C++ bounded shutdown Release 通过，Linux 长稳/QEMU/板端未验，下一28。

2026-10-30：[OS26：端到端延迟归因](2026-10-30/README.md)。计算/等待分段与分位数边界阅读完成；宿主 C++17 运行通过，Linux perf/xv6/QEMU/板端待验。
