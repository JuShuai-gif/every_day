# 2026-10-06 OS09：共享只读页与写故障引用计数

## 承接与边缘问题

承接延迟分配，今天09a共享只读页、09b写故障与引用计数。边缘服务fork多个模型worker时，不能把虚拟地址空间大小乘进程数直接当作物理页成本。这里用现成C++17状态模型观察共享、写时分裂和释放；不是修改xv6，不增加作业。

## 主题一：共享只读页

已读[MIT 2025 COW实验](https://pdos.csail.mit.edu/6.1810/2025/labs/cow.html)。它要求扩展xv6；并非默认上游已有COW。实际读[vm.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/vm.c)的uvmcopy：逐页kalloc→memmove→mappages，失败uvmunmap回滚，故当前是立即复制。调用链fork的地址空间复制→uvmcopy→页分配。COW改变复制策略，但不能把真正只读text页当作可写COW页。

| 状态示意 | parent | child | 物理页引用 |
| --- | --- | --- | --- |
| fork前 | W=1,COW=0→P | 无 | P:1 |
| fork后 | W=0,COW=1→P | W=0,COW=1→P | P:2 |
| child写成功 | 同上 | W=1,COW=0→Q | P:1,Q:1 |
| parent再写 | W=1,COW=0→P | 同上 | 无需复制 |

## 主题二：写故障与引用计数

写失败不能先抹掉旧映射：先分配/复制候选，再提交映射与权限，最后释放旧引用。本模型用shared_ptr表示物理页引用，vector表示映射；fork先构造子容器成功再降父权限。`Space::write`同时服务“用户写”与“内核copyout式写”的模型入口，避免只有一条路径触发分裂。真正内核必须改页表、同步引用计数、处理TLB失效及并发fault；shared_ptr线程安全引用计数不能替代这些协议。

MIT实验还要求copyout处理COW。已读上游copyout检查PTE_W，vmfault仅为lazy allocation，不能把这个函数当前实现称为COW。OOM实验要求终止fault进程；本模型抛异常保留旧状态，方便观察，不声称异常策略等同真实内核kill。

## 源码与平台差异

仓库https://github.com/mit-pdos/xv6-riscv，riscv分支，2026-10-06阅读，MIT许可证；完整commit未固定。具体uvmcopy/copyout/vmfault与COW实验步骤1–4已读。[来源](source.json)。独立启发的宿主模型，页大小4096只是模型合同，RISC-V PTE位不能直接移植ARM。无xv6补丁或内核运行声明。

辅助本地资料：`/Users/guhaoran/书籍资料/ARM/VivekPublicRepo/ARM-MMU/MMUAdvanced/MMU-Chapter 05 PAGE TABLE LEVELS AND DESCRIPTOR FORMATS.pdf`物理第1页已渲染阅读；SHA256 `9f5d73354fd147afe02a5101fb3e7a313da2aa8465635fac1ffa1fc87d63e187`。该页仅介绍页表层级与granule/VA宽度有关，不能作为COW实现来源；本课未采用未经核验的descriptor位图。许可未确认，不复制原文/PDF；既有四处勘误继续有效。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-06/run.sh release
sh systems_practice/os/2026-10-06/run.sh sanitize
```

[代码](src/main.cpp)覆盖4096个页内偏移，逐次故障注入、复制后隔离、独占页取消COW、真只读拒写、多代fork、weak_ptr最后引用释放。边界地址4096拒绝。没有通过执行越界或真实只读页写入证明错误。

若已有匹配MIT2025实验checkout与RISC-V工具链，可在其工作目录先确认分支/提交后`make qemu`，在xv6内执行`cowtest`、`usertests -q`，退出后`make grade`。这些是未来真实补丁的验收命令，当前未交付内核补丁，未经修改的上游预期不通过cowtest；不自动克隆或安装。

## 实际结果与验证边界

[Release](results/verified-release.txt)和[ASan/UBSan](results/verified-sanitize.txt)通过4096 offsets与4096 OOM rollback，以及只读/越界/多代/释放检查。[验证](verification.json)。无性能计时、实际页fault计数、xv6/QEMU/Linux/板端验证。模拟复制次数不是RSS/USS或物理内存测量。

## 工业故障与迁移

- fork后父写污染子→仅子页清W→同时写父子同偏移区分→两端权限降级并标COW；真实内核还需TLB维护。
- 内核read向用户buffer写时污染共享页→copyout绕过fault→测试管道/文件读取进入COW页→统一分裂入口，不能只改用户trap。
- OOM后丢数据或页过早释放→提交顺序/引用错误→注入分配失败并核对映射与引用→分配成功后提交，失败保留旧页，付出错误路径管理成本。

真实Linux迁移先用`/proc/PID/smaps_rollup`与minor-fault统计区分共享/脏页，禁止仅看RSS相加；目标权限/工具可用性待验。追问：原始只读与COW只读如何区分？最后一个引用何时释放？只有一个引用为什么可不复制？copyout为什么不能等待用户trap？父进程权限修改何时需要TLB维护？分配失败谁终止、谁回滚？

## 下一节

OS10：原子互斥与可见性、关中断与嵌套状态；从单线程状态模型进入真实锁协议。
