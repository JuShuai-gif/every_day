# 2026-09-29 OS 02：fork复制状态与exec替换映像

## 承接与边缘问题

承接01的FD共享，今天两主题为02a/fork与02b/exec，阅读观察约10–15分钟。启动推理worker时，需要分清“创建新进程”和“在已有进程加载程序”；否则会把父进程堆变量当作exec后的配置入口。现成示例不增加必做作业。

## 主题一：fork复制哪些状态

实际阅读xv6-riscv `kernel/proc.c::kfork`：先allocproc，uvmcopy建立子地址空间，复制trapframe、把子返回寄存器a0设成0，对文件和cwd增加引用，最后设为RUNNABLE。子得到不同PID；文件对象引用共享不意味着普通用户变量共享。例子在fork后把子全局变量7改成99，父仍为7。`uvmcopy`的内部实现未在本课展开，不能把Linux常见COW策略直接当成本版本xv6的实现证据。

## 主题二：exec替换什么

`kernel/exec.c::kexec`先验证ELF、在新页表装入段和用户栈、复制argv；成功后才切换页表、入口PC和SP并释放旧地址空间，失败走清理路径。exec不是创建新PID；旧程序的全局/堆状态不能继续直接访问，配置应放argv/环境/明确继承的FD。`user/sh.c::runcmd`的EXEC路径调用exec，失败后打印并退出，把加载失败和父shell生存分开。这里的RISC-V trapframe不是A64寄存器约定。

## 源码与平台差异

[MIT xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支，读取日期2026-09-29，MIT许可证；精确commit因git ls-remote DNS失败待补。已读文件/范围和失败见[source.json](source.json)。原场景是教学shell和内核进程管理，本课是受机制启发的独立POSIX C++17观察，不修改或复制xv6内核。macOS/Linux具有各自VM、线程、装载器及FD_CLOEXEC语义，运行宿主例子不证明xv6内部路径执行过。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-09-29/run.sh
```

[src/example.cpp](src/example.cpp)以同一可执行文件的`--worker`分支观察exec前后状态：子经管道报告PID/99，成功exec后同PID报告重新初始化的7；故意exec不存在路径则报告ENOENT/99并_exit(127)。父验证自己仍为7、退出码和消息长度。FD由RAII回收，父用waitpid回收子；读取/写入处理EINTR和短传输，移动/复制FD被禁止。例子单线程，在fork前准备argv，子失败用_exit防止重复缓冲输出。

可选xv6原生观察入口（仅在已有工具链时，不自动安装）：

```sh
# 仓库根目录；git成功后先记录rev-parse HEAD并复核同版本符号。
git clone --depth 1 --branch riscv https://github.com/mit-pdos/xv6-riscv.git systems_practice/.tmp/xv6-os02
cd systems_practice/.tmp/xv6-os02
git rev-parse HEAD
make qemu
# xv6 shell内运行：echo worker
```

这是原生shell的fork/exec观察候选，非自动化内核回归测试，不包含未验证补丁。实际例子在宿主已有工具链直接运行，无需QEMU。

## 实际结果与验证边界

[首次日志](results/initial.txt)和[格式化后复测](results/final.txt)：Release/ASan/UBSan均通过成功与失败两路径；例如首次父48928、子48940在exec前99/后7，同一PID保持不变；失败子48941为ENOENT=2、状态仍99，父始终7。PID只对这次运行有效。没有性能测量。源码网页已读，精确版本未固定；宿主已编译运行，xv6编译、QEMU、Linux和板端均未验证，见[verification.json](verification.json)。

## 工业故障与迁移

触发：父在fork后用堆变量传worker配置，随后子exec；信号：worker回到默认参数；根因：映像替换；诊断：打印PID、argv和初始化值；修复：显式argv/配置FD并验证解析。另一个工程边界是无意继承FD让管道迟迟不EOF：生产应默认CLOEXEC，只保留明确协议需要的FD。本例有意继承单个报告FD，未假称已实现完整worker服务。多线程服务fork之后应只执行允许的安全操作或用适当spawn路径，不能照搬教学例子的全局状态假设。

## 下一节

03：exit资源回收与wait/僵尸进程，继续解释worker失败后的父进程责任。
