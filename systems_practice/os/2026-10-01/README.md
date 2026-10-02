# 2026-10-01 OS04：异常入口与返回

## 承接与边缘问题

承接03 exit资源释放与wait僵尸回收，今日04a trapframe保存现场与04b系统调用返回用户态。边缘推理进程的read失败应成为可处理返回值；进程被信号终止则走另一诊断路线。10–15分钟速览调用链，下文保留源码与迁移边界。

## 主题一：现场保存

`user/usys.pl entry → a7=syscall号 → ecall → trampoline.S uservec → trap.c usertrap`。RISC-V ecall使硬件记录异常控制状态，但不会替软件保存所有通用寄存器。uservec先借sscratch保存用户a0，再用TRAPFRAME地址保存寄存器，取kernel_satp/kernel_sp/kernel_trap，切换页表并sfence.vma后跳入内核。不能在尚未保存时把用户a0当临时变量随意覆盖。

| 状态 | epc | a0 | a7 |
| --- | --- | --- | --- |
| 用户调用前 | ecall地址 | 参数0 | 系统调用号 |
| 已保存现场 | ecall地址存trapframe | 原参数 | 供syscall分派 |
| 正常系统调用后 | 加4 | 返回值 | 按保存值恢复 |

## 主题二：返回路径

usertrap识别用户ecall，将epc加4后调用syscall；后者按a7选择函数，将结果写回trapframe.a0。未知号写-1。当前riscv分支用`prepare_return`设置返回状态，usertrap返回用户satp，trampoline的userret切换页表、恢复寄存器并sret。它不是历史教材里同名usertrapret的逐行副本。sret负责特权级/控制状态恢复，不等于普通C函数ret。

系统调用失败无需杀死进程；意外异常的killed路径和正常错误返回要区分。xv6的-1约定与POSIX libc的-1/errno不能混为同一实现。真实ARM Linux异常入口、寄存器名称和ABI另有规范，不能把RISC-V a7/a0直接当AArch64接口。

## 源码与平台差异

2026-10-01实际读[MIT xv6-riscv/riscv](https://github.com/mit-pdos/xv6-riscv/tree/riscv)的kernel/trap.c:usertrap/prepare_return、kernel/trampoline.S:uservec/userret、user/usys.pl:entry、kernel/syscall.c:syscall/argraw及LICENSE（MIT）。[source.json](source.json)列逐文件链接，分支+日期已记录，精确commit未固定。

本课独立C++状态模型保留PC推进、参数/返回寄存器覆盖与其余槽位保存，省略真实CSR、页表、中断、调度、汇编和特权级。x0只是数组槽位，不模拟硬连线寄存器。另用宿主POSIX调用观察错误返回；不是移植xv6内核。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-01/run.sh
```

工作目录EveryDay根，Apple clang21 C++17，Release及ASan/UBSan。代码用[Frame和model_ecall](src/example.cpp)检查epc+4、a0替换、其余31槽不变、未知号及PC溢出拒绝；getpid返回正数；read(-1)实际-1/EBADF并继续运行，不执行非法指针来演示崩溃。

目标QEMU观察方案（工具预装、当前在已核实的xv6 checkout中）：`make qemu-gdb`，另终端`riscv64-unknown-elf-gdb kernel/kernel`，使用构建生成的.gdbinit端口设置，`break usertrap`、`break syscall`、`break prepare_return`，比较同一进程trapframe.epc/a0/a7。入口频繁，应按进程/系统调用号过滤；断点改变时序，因此不用于延迟测量。未自动克隆、安装或修改内核，尚未执行此目标方案；版本固定后才能把源码行号和二进制对应。

## 实际结果与验证边界

[初测](results/initial.txt)、[最终日志](results/final.txt)、[verification.json](verification.json)：宿主模型Release和ASan/UBSan均通过；read(-1) errno=9（本机值，代码使用EBADF宏不硬编码）。已读源码，未固定commit、未构建xv6、未运行QEMU/Linux/目标板。没有测CPU/等待/I/O/设备或E2E性能，错误返回不是吞吐证据。

## 工业故障与迁移

故障链一：系统调用重复执行→检查返回PC与ecall地址→漏加4→修正系统调用分支推进并回归非ecall路径；不能对所有异常一律加4。故障链二：调用后参数/临时值乱→对比trapframe保存和恢复偏移→现场被提前覆盖或a0返回值未回写→核对汇编结构布局并验证所有寄存器；仅检查返回值会漏掉现场损坏。故障链三：把read错误当崩溃重启→先查进程退出状态与errno→分别处理资源错误和信号，避免重启掩盖FD寿命问题。

迁移验收：固定源码/工具链；同版本内核和gdb符号；保存与恢复偏移一致；正常/未知syscall都回归；宿主POSIX仅作行为对照；ARM Linux/板端另验证信号、strace和SDK错误传播。Google直连检索Internal Error、知乎未获得可核查相关文章，未声称阅读。追问：1.ecall硬件自动保存什么？2.a0为何先借sscratch？3.为何epc只在调用分支加4？4.返回值如何穿过trapframe？5.错误返回与进程终止怎样区别？6.QEMU调试为何不是板端时延？

## 下一节

05a物理页空闲链表、05b分配失败与释放责任，连接模型加载峰值内存和失败回滚。
