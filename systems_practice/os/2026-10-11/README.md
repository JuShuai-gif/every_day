# 2026-10-11 OS13：管道的有界背压与端点关闭

## 承接与边缘问题

承接12节调度状态；13a讲空/满与容量，13b讲最后端点关闭及唤醒。相机producer比推理consumer快时，队列必须有界；停止生产不等于所有写端都已关闭。现成代码观察真实POSIX管道，不额外布置作业。

## 主题一：满管道把吞吐差变成背压

本次实际阅读MIT [xv6-riscv/kernel/pipe.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/pipe.c)，riscv分支，2026-10-11，MIT许可证。`pipewrite`在持有pipe锁时检查 `nwrite==nread+PIPESIZE`；当前源码PIPESIZE=512。满时唤醒读者，再通过 `sleep_prepare` 登记等待，释放锁、sleep，返回后重新加锁查谓词。不是拿着spinlock睡眠，也不是收到通知就保证有空间。实际当前分支接口已不同于旧教材的 `sleep(chan,lock)`，不混用版本。

逻辑关系为 `occupancy=nwrite-nread`，环数组下标模capacity；计数器/锁负责区分满与空，单靠相等下标会有歧义。生产速率持续高于消费速率时，增大缓冲只延迟堵塞，不能创造长期吞吐；相机实时任务还须选择阻塞、丢旧帧或丢新帧政策。本例不把OS字节流假设为完整帧消息。

## 主题二：EOF由最后写引用决定

`piperead`在 `nread==nwrite && writeopen` 时等待；写端已关闭且无数据才返回0。`pipeclose`修改readopen/writeopen并唤醒对端。另读 [file.c::fileclose](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/file.c)：先减少共享file引用，只有归零才调用pipeclose。于是dup/fork遗留写引用可让读者永久等不到EOF。关读端则写者应失败；POSIX宿主默认可能收到SIGPIPE，xv6返回错误行为不能直接等同POSIX信号。

知识链：FD→共享file引用→pipe端点→锁下的占用/关闭谓词→登记等待→调度→重新检查。EOF与短读不同；一次write的内容也不对应一次read。可写就绪只代表允许尝试写，必须继续处理短写/EINTR/EAGAIN。

## 源码与平台差异

来源范围、SHA256和调用链见[source.json](source.json)。采用“共享引用决定关闭、谓词决定等待”的机制；本例独立使用宿主pipe/fcntl/dup，不拷贝xv6实现，没有移植RISC-V上下文切换，也没有QEMU运行。macOS/Linux容量由各自实现决定，不能硬编码512或本次测得的65536。许可证已读；分支读取日固定，精确commit未固定，已列待补。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-11/run.sh release
sh systems_practice/os/2026-10-11/run.sh sanitize
```

[src/main.cpp](src/main.cpp)设两端O_NONBLOCK，写4096B块直至EAGAIN，逐字节核对drain数据并检查总量。EINTR重试，其他负值/意外EOF拒绝；64MiB上界阻止异常实现导致无限填充。之后dup写端、关闭原写端，要求空读仍是EAGAIN；最后dup也关闭，要求read返回0。独立pipe关读端并临时忽略SIGPIPE，检查EPIPE，RAII恢复信号政策。真实宿主容量不当作规范保证。没有并发C++共享内存，本课不靠TSan证明内核锁。

## 实际结果与验证边界

[release.txt](results/release.txt) / [sanitize.txt](results/sanitize.txt)：填入/读出65536B，EAGAIN、重复写端、EOF、EPIPE检查均通过，ASan/UBSan退出0。未计时，不宣称吞吐；无xv6编译/QEMU、Linux/ARM板端结果，见[verification.json](verification.json)。这次示例用非阻塞路径安全观察满/空，不声称实际跑过xv6睡眠唤醒。

目标xv6准备好对应工具链后可在忽略缓存固定源码，`make TOOLPREFIX=riscv64-unknown-elf- qemu`，运行其usertests；本课宿主程序含POSIX库不能直接作为xv6用户程序。目标Linux可直接用本课build.sh，再以 `strace -e trace=pipe,pipe2,read,write,close,dup,fcntl ./build/example` 观察系统调用（Mac没有执行）。

## 工业故障与迁移

- 停机时consumer卡住→先找是否仍有dup/fork后的写引用→用fd清单/系统调用跟踪确认最后close→收紧父子进程FD关闭协议；仅发一个“停机消息”不能替代EOF合同。
- producer CPU满载→循环忽略EAGAIN→统计失败重试和成功字节→转poll/epoll或有界阻塞协议，代价是等待与超时管理；不靠无限增大队列掩盖吞吐不足。
- 半帧被解析→把一次read误当完整消息→记录返回长度与帧长度头→累积读取并设最大消息长度；PIPE_BUF原子写边界不是read分帧承诺。

迁移验收：不同chunk大小/短读写、close顺序、子进程重复FD、超时退出、队列上界；SIGPIPE政策局部化；采集与推理阶段分开测量，长期慢消费者决定丢帧策略。Google/知乎检索未找到适合引用的本版本案例，仅以真实上游实现/POSIX宿主结果做结论。

追问：1. 环下标相同为什么不一定为空？2. EOF与EAGAIN的条件分别是什么？3. dup如何推迟EOF？4. 登记等待为何必须和谓词检查衔接？5. PIPE_BUF能保证完整帧读取吗？6. 增加容量为什么不能解决持续过载？

## 下一节

14：自旋锁/睡眠锁分工与嵌套锁死锁；从今天“满队列需要等待”转到哪些锁允许持有到等待点。
