# 2026-10-28 OS 第27节：长期运行与故障恢复

## 承接与边缘问题
当边缘推理服务运行数小时后卡死，通常同时涉及资源上界（FD、内存、队列）与错误注入后的有序关闭。今天的两个主题是有限资源合同和 stop/join 回收。

## 主题一
xv6-riscv `kernel/proc.c` 的 `allocproc/freeproc/kexit/kwait` 展示进程从 USED 到 ZOMBIE 再到 UNUSED 的生命周期；`proc.h` 的锁注释说明哪些字段需要 `p->lock` 或 `wait_lock`。本课把同样的“资源有上界、失败释放、终止可观察”改编成一个 C++ worker，不把改编代码说成内核实现。

## 主题二
worker 用 acquire/release stop 标志退出，主线程 join 后才能释放服务状态；拒绝计数和 jobs 计数让故障注入可检查。队列容量、FD 上限、内存上限应在 Linux 上用 `RLIMIT_NOFILE`、cgroup 和 procfs 观察，Mac 运行只验证语言层合同。

## 源码与平台差异
实际阅读 GitHub xv6-riscv riscv 分支上述文件（MIT，2026-10-28）；Linux 的进程/FD/内存限制与 xv6 不同，QEMU RISC-V 也不是 RK3588/Thor。保留生命周期与锁边界，省略真实 syscall、cgroup、FD 泄漏和板端 Runtime。

## 现成观察示例与命令
`sh systems_practice/os/2026-10-28/run.sh` 编译并运行 2 ms worker；边界是立即 stop、至少一个 job、拒绝一个新请求。目标 Linux 还应运行 `ulimit -n`、`cat /proc/$PID/fdinfo/*`、`cat /proc/$PID/status`，再注入 `SIGTERM`/分配失败。

## 实际结果与验证边界
Mac Release 实际通过并输出 `bounded_shutdown_pass`；xv6/QEMU、Linux 长稳、真实 FD/内存曲线、RK3588/Thor 未验证，无性能数字。

## 工业故障与迁移
FD 泄漏→数小时后 EMFILE→统计 `/proc/$pid/fd` 并用 RAII/close-on-exec 修复；worker 忽略 stop→关闭卡住→记录 join 超时并先停止接收再 drain；队列无上界→内存上涨→容量拒绝与背压。每条修复都要回归异常、重复 close、SIGTERM。

## 下一节
OS 第28节综合部署验收：有界采集到推理流水线与正确性/延迟/恢复联合验收。
