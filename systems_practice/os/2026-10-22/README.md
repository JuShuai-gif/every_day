# 2026-10-22 OS22：就绪通知与非阻塞I/O

## 承接与边缘问题

承接21课的谓词等待与关闭协议，今天是22a epoll就绪含义、22b短读写与帧解析。机器人上游传来2字节大端长度头+最多32字节payload；一次read不保证收到完整头，更不保证完整帧。已有实现为现成附加材料，不增加作业。

## 主题一

Linux v6.12 `fs/eventpoll.c`的`ep_poll_callback`将对象加入ready list并唤醒等待者；`ep_send_events`再次调用底层poll判定就绪，交付事件。LT对象在非ONESHOT情况下重新进入ready list，ET不会因当前仍可读而走这个重入分支。通知描述的是当时可进行I/O的状态，既不是消息数，也不是一次read完成整帧的承诺。多个消费者还可能在通知后抢先读走数据。

## 主题二

[src/main.cpp](src/main.cpp)的Parser保存header进度、长度和已有payload。read>0逐字节推进；EINTR重试；EAGAIN返回事件循环并保存状态；0是EOF，半帧EOF拒绝。长度大于32在分配payload前拒绝，空帧合法。write只按真实返回正字节数移动offset，EAGAIN保留未发送尾部。大流量服务还需要独立发送状态和EPOLLOUT订阅，这里用受控小消息与填满管道例子验证边界，不假称实现完整网络服务。

ET通常应读到EAGAIN；若为公平性限制单轮预算，需要把仍有工作可能的FD留在用户态ready队列，不能直接等下一次边缘。LT也需要非阻塞设计才能避免慢FD堵塞整个事件循环。

## 源码与平台差异

2026-10-22实际读[Linux v6.12 eventpoll.c](https://github.com/torvalds/linux/blob/v6.12/fs/eventpoll.c)的`ep_poll_callback`与`ep_send_events`，GPL-2.0-or-later；[source.json](source.json)保留下载hash/版本/调用链。练习是受其启发的独立用户态实现，未移植内核代码。原场景是Linux多FD事件分发，本例只保留pipe与ET/LT差异，省略socket连接、线程竞争和网络协议。

知乎刘子龙的[原作者回答](https://www.zhihu.com/en/answer/130228057)中“读半个管道后再等待”的例子作为案例线索，已用上述源码核对，未采用其效率概括。Google直访失败与查询见[研究记录](../../daily/2026-10-22/results/research.json)。xv6不具备本课epoll；macOS分支用pipe/poll验证字节流与解析，明确不冒充Linux epoll。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-22/run.sh
sh systems_practice/os/2026-10-22/run.sh sanitize
```

在Linux/Thor主机执行同一入口会额外运行`epoll_case(false/true)`：写5字节，收初始事件，只读1字节，再以timeout=0查询。孤立单生产者测试预期LT返回1、ET返回0；随后主动drain剩余4字节，直到EAGAIN，再写空帧验证新通知。其他线程可产生新事件，不能把这个孤立结果泛化为ET永不再次通知。

需要排障时在Linux本课目录执行`strace -tt -e epoll_ctl,epoll_wait,read,write,poll build/check-release`，只观察系统调用与返回长度，不把strace耗时作为未干扰延迟。Mac没有执行此命令。

## 实际结果与验证边界

[Release](results/release.txt)、[Sanitizers](results/sanitize.txt)验证3帧、oversize/半帧2拒绝，真实管道写到65536B后EAGAIN并无损读回；这是当次管道容量观察，不是通用上限。实际收到1字节头时parser尚无完整消息。Linux ET/LT、QEMU/xv6、板端均未运行，[verification.json](verification.json)明确拆分。没有性能数据。

## 工业故障与迁移

| 触发→症状 | 诊断→修复→代价/回归 |
| --- | --- |
| ET只读一次后尾帧停住 | trace显示第一次read后仍有字节但没有新数据边缘→drain到EAGAIN或用户态重排→多FD预算公平性与分段头回归 |
| 就绪后阻塞等待剩余payload | read长度小于帧长，代码坚持一次补齐→非阻塞Parser跨事件保留状态→每连接有界状态与EOF验证 |
| 出口背压后字节重复/丢失 | write返回短长度，offset却按请求长度更新→只推进返回值→保留发送队列并限制总字节 |

迁移验收：实际Linux两模式通过；检查O_NONBLOCK与FD关闭；输入1字节/空帧/最大32/33非法/半帧EOF；模拟慢消费者；不把EAGAIN当断开；真实长连接验证资源上限与公平性。

面试追问：①就绪与完成有什么区别？②ET/LT在ready list上的差异是什么？③为什么需要保留半个头？④EAGAIN、EINTR与EOF各如何转移？⑤限制每轮读取预算时怎样避免ET饿死？⑥FD复用会怎样影响事件携带的用户标识？

## 下一节

23课：CPU地址、物理地址与DMA地址；方向、同步和所有权。
