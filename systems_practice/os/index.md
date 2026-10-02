# 每日 OS 索引

每天一节、两个相关主题，估计阅读/观察10–15分钟，随既有北京时间08:30任务交付。[路线](../docs/os/README.md) · [28节/56主题课程表](curriculum.json) · [进度与待补](progress.json)。

| 日期 | 节次与两主题 | 已验证 | 待验证 |
| --- | --- | --- | --- |
| [2026-09-28](2026-09-28/README.md) | 01：系统调用边界 + FD共享状态 | 网页实现已读；Mac C++17 Release/ASan/UBSan五组检查通过 | 精确commit、xv6/QEMU、Linux与板端；[记录](2026-09-28/verification.json) |
| [2026-09-29](2026-09-29/README.md) | 02：fork状态复制 + exec映像替换 | Mac Release/ASan/UBSan成功/失败两路径通过；源码已读 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-29/verification.json) |
| [2026-09-30](2026-09-30/README.md) | 03：exit资源释放 + wait僵尸回收 | Mac Release/ASan/UBSan：exit37/SIGKILL9、EOF、WNOWAIT、ECHILD通过 | 精确commit、xv6/QEMU/Linux/板端；[记录](2026-09-30/verification.json) |
| [2026-10-01](2026-10-01/README.md) | 04：trapframe现场 + 系统调用返回 | 宿主状态模型/EBADF，Release/ASan/UBSan通过；xv6源码已读 | commit、xv6/QEMU/Linux/板端待验；[记录](2026-10-01/verification.json) |

下一课：**06 虚拟地址与页表**。

2026-10-02正式交付：[05 页分配器空闲链表与失败回滚](2026-10-02/session-02/README.md)。Mac Release/ASan/UBSan通过；源码已读，Linux/板端未验。[并发旧游标补充](2026-10-02/README.md)保留但不计新课。
