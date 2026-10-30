# OS26：端到端延迟归因的计算/等待分段与分位数边界

边缘推理的设备 kernel 时间稳定而 P95 变差时，先把计算、等待、复制分段，再比较带跟踪与无跟踪的分位数。主机时钟只覆盖当前示例 CPU 计算，不等于设备时间；尾延迟需要固定输入、预热和足够样本，不能用单次均值替代。

实际阅读 [xv6-riscv kernel/sysproc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/sysproc.c)，2026-10-30，关注 `sys_uptime`/`argint` 的系统调用边界；宿主示例为独立 C++17 分段基线。`sh run.sh` 已运行，Linux perf、xv6/QEMU、RK3588/Jetson 未验证。生产验收应记录 CPU、设备、传输、排队四段及 P50/P95/P99。
