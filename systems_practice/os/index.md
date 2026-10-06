# 每日 OS 索引

每天一节、两个相关主题，估计阅读/观察10–15分钟，随既有北京时间08:30任务交付。[路线](../docs/os/README.md) · [28节/56主题课程表](curriculum.json) · [进度与待补](progress.json)。

| 日期 | 节次与两主题 | 已验证 | 待验证 |
| --- | --- | --- | --- |
| [2026-09-28](2026-09-28/README.md) | 01：系统调用边界 + FD共享状态 | 网页实现已读；Mac C++17 Release/ASan/UBSan五组检查通过 | 精确commit、xv6/QEMU、Linux与板端；[记录](2026-09-28/verification.json) |
| [2026-09-29](2026-09-29/README.md) | 02：fork状态复制 + exec映像替换 | Mac Release/ASan/UBSan成功/失败两路径通过；源码已读 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-29/verification.json) |
| [2026-09-30](2026-09-30/README.md) | 03：exit资源释放 + wait僵尸回收 | Mac Release/ASan/UBSan：exit37/SIGKILL9、EOF、WNOWAIT、ECHILD通过 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-30/verification.json) |
| [2026-10-01](2026-10-01/README.md) | 04：trapframe现场 + 系统调用返回 | 宿主状态模型/EBADF，Release/ASan/UBSan通过；xv6源码已读 | commit、xv6/QEMU/Linux/板端待验；[记录](2026-10-01/verification.json) |
| [2026-10-03](2026-10-03/README.md) | 06：walk多级索引 + 映射权限与解除映射 | C++17 Release/ASan/UBSan，手算地址、1025跨叶映射与失败边界通过；本地PDF页5勘误核实 | xv6/QEMU/Linux/板端与精确commit待验；[记录](2026-10-03/verification.json) |

下一课：**10 自旋锁与中断**。

2026-10-02正式交付：[05 页分配器空闲链表与失败回滚](2026-10-02/session-02/README.md)。Mac Release/ASan/UBSan通过；源码已读，Linux/板端未验。[并发旧游标补充](2026-10-02/README.md)保留但不计新课。

2026-10-04正式交付：[07 copyin/copyout＋跨页边界](2026-10-04/README.md)。Release/ASan/UBSan 2450区间/部分复制/事务回滚通过；xv6源码与本地PDF页1已读；QEMU/Linux/板端未验。

2026-10-05正式交付：[08 地址空间增长＋首次触页；4098 size、deferred OOM、映射回滚/洞/缩堆通过；xv6真实lazy源码已读，QEMU/Linux/板端待验。](2026-10-05/README.md) Release/ASan/UBSan通过。

2026-10-06：[OS09 共享只读页与COW引用计数](2026-10-06/README.md)。4096偏移/注入OOM与多代回收通过，Release/ASan/UBSan；独立宿主模型，COW为MIT实验扩展，非xv6默认实现，QEMU/Linux/板端未验。
