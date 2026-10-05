# 2026-10-05 OS08：地址空间增长与首次触页

## 承接与边缘问题

承接copyin/copyout，今日08a地址空间增长、08b首次触页与延迟分配。机器人加载模型时“分配很快、第一帧慢”可能涉及缺页，不能直接断言是模型计算。现成宿主模型把逻辑size、驻留页与失败时刻分开；没有修改xv6内核，不增加作业。

## 主题一：请求成功不等于物理内存到位

2026-10-05读取的xv6-riscv `riscv`分支`sys_sbrk`已有第二参数策略：eager或负增长走`growproc`，lazy正增长先检查溢出和TRAPFRAME边界再修改`p->sz`。因此不能沿用“xv6主分支一定没有lazy”的旧教程结论。只扩size尚未分配物理页，后续访问才可能OOM。宿主`Heap::grow`对应地址上界检查，`resident`是模型内map元素个数，并非OS RSS。

## 主题二：缺页、零填充与失败回滚

已读`usertrap`对RISC-V load/store page fault（13/15）调用`vmfault`；成功后返回重试故障指令，失败进入进程终止路径。`vmfault`检查地址、已映射状态、kalloc、memset零页、mappages，映射失败kfree。`copyin/out`也可能需要触发补页（承接上一课），不能只处理用户态load/store入口。

状态链：`size=0,resident=0 → grow(3页+1字节) → size增加,resident=0 → 首触页0 → resident=1 → 超预算首触 → OOM但size不回退`。缩堆必须允许未驻留的洞；非整页缩小的部分页仍可能保留原内容，不承诺在同页重新增长后自动清零。本例只对释放整页后重新分配验证零填充。上游返回物理地址0表示失败；这里用异常表达，不能混用返回协议。

## 源码与平台差异

仓库https://github.com/mit-pdos/xv6-riscv，riscv，读取2026-10-05，精确commit未固定，MIT；实际路径[sysproc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/sysproc.c)、[trap.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/trap.c)、[vm.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/vm.c)。符号`sys_sbrk → usertrap → vmfault → kalloc/mappages`（kalloc内部本期未新读）。原场景是教学进程地址空间；本例独立C++模型保留延迟资源消耗与回滚，省略真实页表、TLB、并发、fork和信号。Linux overcommit、共享零页、THP、文件映射与macOS VM各有策略，不能从模型驻留数推断真实minor-fault数量。

本地辅助资料复读`ARM-MMU/MMUAdvanced/MMU-Chapter 05 PAGE TABLE LEVELS AND DESCRIPTOR FORMATS.pdf`物理页1（沿用已渲染图，重新核对SHA256 `9f5d73354fd147afe02a5101fb3e7a313da2aa8465635fac1ffa1fc87d63e187`）。原页只说多级转换的层数依赖granule和VA规模，与本课“地址与物理资源分离”可衔接，不提供lazy策略或xv6实现依据。许可未确认，不复制原文；历史四项勘误仍适用，不能把ARM描述符用于RISC-V。详见[source.json](source.json)。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-05/run.sh release
sh systems_practice/os/2026-10-05/run.sh sanitize
```

[src/main.cpp](src/main.cpp)：4KB教学页，16页地址上限，2页驻留预算；注入映射失败，unique_ptr负责未提交页回收。若已有xv6仓库，在固定当前commit后`make qemu`并运行其`usertests`；当前分支源码会变化，必须先核对`sbrk`策略参数，不能把旧lab补丁直接贴入新分支。没有QEMU/交叉工具链，未执行该命令。

## 实际结果与验证边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)通过4098种size及延迟OOM、映射回滚、洞/缩堆、精确末尾拒绝和整数溢出。没有测性能，没有实际触发OS缺页，没有xv6/QEMU/Linux/板端结果；[verification.json](verification.json)分别记录。

## 工业故障与迁移

- 首帧慢而后续快→候选原因有缺页/文件I/O/JIT/设备初始化→Linux先按阶段记录`perf stat -e page-faults,minor-faults,major-faults`和应用时间→只对必用页预热，避免额外驻留挤压推理内存；需实板复验。
- 分配成功后进程被杀→逻辑增长延后了资源失败→核对内存限额、OOM日志与首次写入范围→预留资源、分块加载或提前触页验收；代价是启动时间，不能用“malloc成功”担保实时请求成功。

追问：size与RSS是什么关系？首次读和写一定分配同样资源吗？映射失败如何回收新页？缩堆为什么要处理洞？为什么缺页成功后不能跳过原指令？预热为什么可能伤害系统？

## 下一节

09：写时复制扩展，继续把共享页、写故障和资源回收串起来；先核实教学实验分支。
