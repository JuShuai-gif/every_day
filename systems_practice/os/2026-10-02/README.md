> 2026-10-02并发游标纠正：本页是补充材料，不计本日正式课程、不增加必做作业；请从[正式OS第05课](session-02/README.md)开始。旧源码、来源与日志全部保留。

# 2026-10-02 OS04：trapframe保存现场与返回用户态

## 承接与边缘问题

承接exit/wait，今天主题04a是trapframe保存，04b是系统调用返回。边缘服务遇到`read`失败，究竟是一次可恢复错误还是进程异常终止？先区分语言/库返回值、内核入口与指令异常。10–15分钟速览状态表，深入阅读源码路径与平台边界。现成例子不增加作业。

## 主题一：保存的到底是什么

实际读xv6-riscv `uservec`：入口时仍使用用户页表，借助sscratch临时保存a0，再以TRAPFRAME地址保存其他寄存器并补存a0；随后取kernel_sp/kernel_satp/kernel_trap并切换页表。x0恒零，不需要保存。普通函数只按ABI保存部分寄存器，异常入口则必须保住被打断代码需要恢复的现场；两者不是同一种栈帧。

## 主题二：返回位置与结果

当前riscv分支是`uservec→usertrap→syscall→prepare_return→userret`，**不是凭旧教材猜usertrapret**。ecall路径把epc加4，syscall返回值写trapframe的a0；prepare_return设置sepc与sstatus，userret切回用户页表、恢复寄存器、sret。外部中断不能无条件epc+4，否则会跳过用户指令。

| 阶段 | PC/结果 | 解释 |
| --- | --- | --- |
| ecall保存 | epc指向ecall，a7为调用号 | 异常原因先分类 |
| syscall | epc+4，a0替换 | 本例getpid模型返回123，仅教学值 |
| 返回 | 其他30个可写寄存器恢复，x0仍0 | 教学Frame不是内核结构的字节布局 |
| 非法调用号 | 模型a0为uint64(-1) | 不声称xv6会替用户设置POSIX errno |

## 源码与平台差异

2026-10-02实际读取[MIT xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支，MIT许可；[kernel/trap.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/trap.c) usertrap/prepare_return与[kernel/trampoline.S](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/trampoline.S) uservec/userret全文。精确commit未取得，来源记录在[source.json](source.json)。原场景是RISC-V教学内核；示例独立模拟寄存器状态，不复制内核或称为xv6实跑。

macOS测试通过libc调用read/getpid；Linux AArch64系统调用使用其独立ABI与陷入路径，不能把RISC-V的a0/a7/ecall套成ARM指令。Mac底层syscall入口也不由这个C++日志证明。Linux上用`strace -e read,getpid ./build/example`可观察实际调用，但getpid等库实现是否真的陷入须看工具输出。

## 现成观察示例与命令

```sh
sh run.sh
# 仅在已准备Linux开发环境运行，不自动安装strace
strace -e read,getpid ./build/example
```

[src/example.cpp](src/example.cpp)的Frame复制是教学状态机：保持其他寄存器、替换a0、epc+4、非法调用号、PC溢出拒绝；实际POSIX `read(-1)`返回-1/EBADF后进程继续，安全地产生失败路径。没有故意读空指针制造C++ UB，也没有把模型PC当实机PC。

若已有xv6/QEMU环境，在固定实际读版本后`make qemu`，另终端`make qemu-gdb`按该版本调试工作流设置uservec/usertrap/userret断点，观察sepc/scause/trapframe；先检查Makefile的QEMU_GDB参数与生成.gdbinit，不混用版本。今天没有修改内核，未提供或执行假想补丁。缺QEMU/RISC-V工具链，目标运行保持未验证。

## 实际结果与验证边界

[host.txt](results/host.txt)：Release/ASan/UBSan通过状态不变量；真实read(-1)=-1，errno=9=EBADF，进程继续。验证只证明宿主POSIX包装与独立模型，不证明xv6保存汇编、TLB或ARM返回状态正确。[verification.json](verification.json)分开列出源码、宿主、xv6/QEMU/Linux/板端。基础机制课不测性能。

## 工业故障与迁移

1. 调用返回后重复执行或跳过指令→怀疑保存PC/原因分类→断点比较scause/sepc及epc修改位置→仅ecall走+4，设备中断保留PC→回归syscall与定时中断两条路径；宿主模型只覆盖前者。
2. 服务将read返回-1当“内核崩溃”并重启→检查返回与errno、进程存活、日志信号→区分EBADF配置错误与EINTR重试等具体语义→错误分类后决定恢复，不盲目重试非法FD。
3. 用户返回即page fault→候选是页表/栈/现场破坏→核对satp切换、TRAMPOLINE双映射与trapframe地址→对照实际版本汇编和QEMU寄存器→不能用C++状态机PASS排除内核问题。

迁移验收：固定源码版本与工具链、观察正常与失败路径、保留scause/epc、核实具体OS/ABI、再做板端错误注入。当前缺目标证据，不能宣传完整内核调试闭环。追问：①trapframe与函数栈帧区别？②a0为何先放sscratch？③为什么ecall才+4？④errno由谁设置？⑤页表切换后trampoline为何仍可执行？⑥C++模型哪些结论不能证明？

## 下一节

OS05继续页分配器空闲链表与分配失败/释放责任，按课程表前置进入内存机制，不重复推进。
