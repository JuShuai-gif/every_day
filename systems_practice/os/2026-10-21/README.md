# 2026-10-21 OS 第21课：谓词等待与Linux futex边界

## 承接与边缘问题

承接第20课运行队列观测。本节21a是C++谓词等待，21b是Linux阻塞路径和关闭排空。推理请求已从队列移走，但还在使用输入；管理线程看到队列空，不能立即释放缓冲。10–15分钟现成例子，无额外作业。

## 主题一

[Worker::loop/wait_idle](src/main.cpp)在同一mutex下读写queue、closed、active。工作谓词是closed或queue非空；排空谓词是queue空且active=0。`notify`只是促使复查，不保存任务、不保证调度、不表示任务成功。任务在锁外执行，异常必须仍归还active并累计failures。wait_until只设一次steady_clock绝对截止时间，避免无关唤醒不断延长总预算。

状态：`queued → active++/pop → 锁外执行 → active--/finished++ → notify idle`。关闭禁止新提交，保留已接受任务直至全部完成；工作线程观察closed且queue空才退出，析构join覆盖资源寿命。容量4是等待队列上界，不含唯一在途任务；峰值已接受未完成数可为5。

## 主题二

实际读取libc++的`condition_variable::wait → __libcpp_condvar_wait`；这是平台抽象，C++不要求futex。另读glibc2.41 `__pthread_cond_wait_common`：先登记wseq/wrefs，再解锁mutex，检查组内signal，必要时调用`__futex_abstimed_wait_cancelable64`，返回后重新锁mutex。glibc有组和取消协议，不是把业务bool地址直接传给futex。

Linux6.12 `kernel/futex/waitwake.c`开头的等待/唤醒排序说明：wait端加等待计数、屏障、锁桶并重新比较用户值；wake端更新值、屏障、检查等待者再唤醒，避免同时漏掉“值已变”和“等待者入队”。这解释期望值比较的作用，但不能用它代替业务层mutex和谓词。macOS本次C++运行没有证明Linux走了哪些futex系统调用。

## 源码与平台差异

[source.json](source.json)：[libc++20.1.8](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/condition_variable.cpp)，Apache-2.0 WITH LLVM-exception；[glibc2.41](https://github.com/bminor/glibc/blob/glibc-2.41/nptl/pthread_cond_wait.c)，LGPL-2.1-or-later；[Linux6.12](https://github.com/torvalds/linux/blob/v6.12/kernel/futex/waitwake.c)，GPL-2.0-or-later。阅读范围分别wait/notify、330–470行、1–110行排序注释。独立教学Worker保留谓词/退出语义，省略glibc内核内部实现、取消与多worker公平性。xv6没有本课的Linux futex接口；不伪造xv6补丁。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-21/run.sh
MODE=sanitize sh systems_practice/os/2026-10-21/run.sh
MODE=tsan sh systems_practice/os/2026-10-21/run.sh
# 以下仅Linux目标，尚未执行；从项目根目录运行
strace -f -e trace=futex -o systems_practice/os/2026-10-21/build/futex.txt systems_practice/os/2026-10-21/build/release
```

固定门闩让首任务进入active而queue空，额外notify后wait_idle仍超时；再排入4个抛异常任务，验证满队列拒绝、幂等close、close后拒绝、释放门闩后全部结束。RAII门闩避免测试断言抛异常导致测试自身join死锁。对象不能在其自身worker中析构，提交者必须在对象析构前停止调用；示例不支持取消一个永不返回的用户任务。

## 实际结果与验证边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[TSan](results/tsan.txt)通过40轮、200完成、160预期异常、40在途超时，以及空任务拒绝/空关闭。这里1ms超时是状态验收，不是性能指标。没有Linux strace、xv6构建、QEMU或板端证据；[verification.json](verification.json)逐项标记。

## 工业故障与迁移

1. 关闭时释放输入后worker崩溃→只检查queue.empty忽略active→门闩强制“空但在途”现场→以queue空且active0为完成合同，join后回收。代价是关闭延迟包含最慢已接受任务。
2. 偶发一直等→异常分支未减少active或遗漏唤醒→注入抛异常任务检查finished/failures→统一完成计数；不能吞异常后不记失败。
3. 唤醒后空队列pop→使用if替代while/谓词→noise通知复现→返回后重新持锁检查。Linux futex的无丢唤醒保证不会使业务谓词自动成立。

迁移验收：先测状态和退出，再在目标libc/kernel上strace；记录EAGAIN、超时、唤醒次数与排队时延，系统调用数不是请求数。硬件加速任务还需设备完成事件，active减到0不能早于真实完成。

追问：①notify会存储信号吗？②队列空与空闲有何差别？③绝对截止时间解决什么？④glibc为何先登记再解锁？⑤futex期望值比较避免哪种竞态？⑥close、drain与cancel分别承诺什么？

实际检索日期2026-10-21。Google直访 `https://www.google.com/search?q=ncnn+float2int8+NEON+rounding+pmr+futex` 与知乎 `https://www.zhihu.com/search?type=content&q=NEON%20float2int8` 被网页工具拒绝访问；搜索引擎查询未取得可核查的知乎原文，因此不声称读过知乎案例。技术依据来自下面实际读取的GitHub实现与官方资料。

## 下一节

第22课epoll就绪与短读写状态机：被唤醒不代表一次处理已经完成。
