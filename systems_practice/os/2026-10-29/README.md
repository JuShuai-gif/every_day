# 2026-10-29 OS 第28节：采集到推理的有界流水线

综合部署验收把两个机制绑在一起：队列有界/背压，和关闭时错误恢复与排空。实际阅读 xv6-riscv `kernel/proc.c` 的 `allocproc/kexit/kwait/sleep_prepare` 与 `proc.h` 锁注释；本例独立改编为 C++17 单 worker，保留资源上界、close 通知、join 回收，省略页表/调度器。运行 `sh run.sh`，4 个任务完成总和10，关闭后提交被拒绝。Mac 仅验证语言层合同；Linux epoll、RKNN/TensorRT DMA、QEMU、板端时序未验证。故障链：提前关闭→任务丢失→close/drain 计数；worker 异常→未 join 造成资源泄漏→RAII/错误路径回归。追问：为什么 wait 需谓词？close 后队列非空如何处理？设备完成事件与 C++ join 有何边界？怎样记录端到端分段延迟？
