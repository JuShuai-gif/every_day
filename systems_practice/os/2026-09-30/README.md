# 2026-09-30 OS03：exit资源回收与wait僵尸进程回收

## 承接与边缘问题

接02 fork/exec：推理worker失败后，管理进程必须取得失败原因并回收内核退出记录。03a讲退出释放资源，03b讲父进程回收；10–15分钟速览加现成源码观察，不增加作业。

## 主题一：退出不是所有状态立即消失

2026-09-30读[xv6-riscv riscv/kernel/proc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/proc.c) `kexit`：关闭ofile、释放cwd引用、在wait_lock保护下reparent并唤醒父进程、保存xstate、置ZOMBIE、sched离开。退出的任务不再执行，但父进程仍需读取pid/状态等元数据。这里是教学RISC-V内核，不是Linux实现。

## 主题二：wait保留可辨别的完成状态

同文件`kwait`扫描子进程；持有子锁检查ZOMBIE，copyout成功后freeproc；若无已退出子进程但仍有子进程则准备睡眠、释放wait_lock并睡眠，再回环检查。读取版本使用sleep_prepare/sleep拆分，不照搬旧版`sleep(chan,lock)`文本。上层含义是**检查与等待登记不能留下丢失唤醒窗口**，不是看到wake调用就保证安全。

Linux/macOS的waitid/waitpid接口与xv6的kwait不同。现成例子先WEXITED|WNOWAIT观察退出记录，随后waitpid消费；Linux接口语义核对[wait(2)官方手册](https://man7.org/linux/man-pages/man2/waitpid.2.html)。不要对未WIFEXITED的状态读WEXITSTATUS。

## 源码与平台差异

原仓库[mit-pdos/xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支/2026-09-30，MIT许可；具体kexit→fileclose/iput/reparent/wakeup/sched及kwait→copyout/freeproc的调用位置已读，本次只展开proc.c中的实现，不假称已审完fileclose/VM内部。精确commit未固定。[source.json](source.json)。代码为独立POSIX观察，不移植或改编内核函数；无xv6补丁，也不以Mac通过代表QEMU已跑。

## 现成观察示例与命令

本课目录`sh run.sh`。父子共享pipe：子写一字节后正常_exit(37)或向自身发送SIGKILL；父关闭自己的写端，读取字节再得到EOF，然后waitid WNOWAIT、waitpid、再次waitpid得到ECHILD。

| 观察 | 能证明 | 不能证明 |
| --- | --- | --- |
| EOF出现在reap之前 | 所有pipe写端引用已关闭 | 整个内核进程元数据已释放 |
| waitid WNOWAIT给状态 | 退出状态可观察且保留 | 已完成最终回收 |
| waitpid后ECHILD | 此pid已被当前父进程回收 | 其他worker/设备资源均正常 |

子进程_exit不会调用C++自动对象析构；OS仍关闭其FD。父进程有Fd和Child RAII，异常展开也等待自己创建的子进程，EINTR重试。仅操作本练习派生进程，不触碰系统其他进程。SIGKILL路径不产生core dump。

## 实际结果与验证边界

Mac arm64 Apple clang21 Release/ASan/UBSan均通过：正常状态37、signal9、EOF、WNOWAIT保留、ECHILD，原始PID见[run.txt](results/run.txt)，补全Child析构错误报告后[最终复验](results/final-run.txt)仍通过。[verification.json](verification.json)分开记录源码/版本/宿主/xv6/Linux/板端。未做性能测量，未运行RISC-V/QEMU或Linux；xv6实际环境准备需匹配riscv分支工具链，不能从宿主ABI推断内核执行。

在已有Linux板上复制本课源码，`c++ -std=c++17 -O2 -g src/example.cpp -o build/example && ./build/example`（先mkdir -p build），可加`strace -f -e trace=process,read,write,close,wait4,waitid ./build/example`观察本程序。这些目标命令未执行；wait实现/trace syscall名称取决于libc与平台。不开生产worker做实验。

## 工业故障与迁移

1. worker已退出、管理器却卡在pipe read：先查管理器/兄弟是否仍持写端，EOF取决于全部引用，不取决于某个进程死亡。修复fork后立刻关闭无用端、明确FD继承；回归正常退出和信号退出。不能用固定sleep“等EOF”。
2. 服务长跑进程表耗尽：worker退出但未reap；用目标ps/进程状态与wait日志区分活进程泄漏和僵尸。集中reaper且明确哪个线程拥有wait责任，EINTR重试；信号处理器与管理线程竞争wait会造成ECHILD，不能一律当内核错。
3. 以退出码37覆盖SIGKILL原因：统一读status的低位会误诊。先WIFEXITED/WIFSIGNALED分流，保留原始status与worker请求ID；异常恢复策略与资源重启分开。GPU/NPU上下文失败仍须各自SDK验收，OS回收不等于任务成功。

迁移验收：固定板OS/libc、上限并发、正常/信号/exec失败、pipe全部端点、关闭排空、重复启停后FD与僵尸不增长；慢worker超时与终止策略本例未实现，生产不能无限等待。

追问：1. 为什么有僵尸？2. EOF与wait哪个先发生？3. _exit是否执行自动析构？4. WNOWAIT改变什么？5. wait为什么要重查谓词？6. 多线程reaper如何避免争抢？

## 下一节

04：trapframe保存现场与系统调用返回用户态，解释这次用户接口怎样进入内核并返回。
