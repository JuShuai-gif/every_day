# 2026-10-09 OS 12：可运行/运行/睡眠状态与上下文切换

边缘流水线中 camera 线程等待帧、inference 线程就绪时，调度器只能挑选 RUNNABLE，而非把 SLEEPING 当作可运行任务。实际阅读 xv6-riscv `kernel/proc.c` 的 `scheduler`、`sched`、`yield`（2026-10-09，riscv 分支；MIT）：`scheduler` 扫描 RUNNABLE 任务并在持有任务锁时切换，`sched` 保存/恢复上下文，sleep/wakeup 的锁与状态转换共同避免丢失唤醒。本课的 `schedule` 是独立 C++17 状态模型，保留选择合同，省略锁、CPU-local、内核栈与真正 `swtch`，绝不冒充 xv6/QEMU。

`sh run.sh` 已在 Mac 编译运行：验证 sleeping 被跳过、runnable 变 running、无 runnable 进入 idle。故障链：把阻塞 I/O 标为 runnable 会空转；未在锁下转换状态会丢失 wakeup；把 host 模型成功称为 Linux/板端调度验证是错误的。Linux/ARM/xv6-QEMU 均未验证；下一课是有界队列的空/满与端点关闭。
