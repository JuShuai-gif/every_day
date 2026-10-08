# 2026-10-08 OS 第11节：登记等待与谓词复查

## 承接与边缘问题

承接第10节锁与中断嵌套。主题11a是登记等待到睡眠的原子关系，11b是谓词复查与丢失唤醒。相机采集线程向单槽交帧、推理线程取帧，关闭时必须唤醒阻塞双方并排空已交帧。10–15分钟速览，下面代码是现成材料。

## 主题一

**版本差异必须先看源码。**2026-10-08读到的xv6-riscv `riscv`分支不再使用旧教材常见的`sleep(chan, lock)`接口。`pipewrite/piperead`持pipe锁检查条件，调用`sleep_prepare(channel)`，再释放pipe锁，调用`sleep()`，返回后重新加锁。

`proc.c::sleep_prepare`在进程锁保护下登记chan。`wakeup`在相同进程锁下清chan，若已SLEEPING再置RUNNABLE；`sleep`拿进程锁后只在chan仍非零时睡眠。因此生产者在“登记之后、真正睡眠之前”唤醒，也会留下chan清零的事实。源码注释中有RUNNING用词，但实际赋值是RUNNABLE，以代码为准。这不是任意事件永久存档：在登记之前发送的通知仍可能没有接收者，所以登记和条件检查还必须由外层条件锁串起来。

## 主题二

唤醒只说明条件可能改变，不保证槽仍有数据：另一消费者可能先取走，关闭/中断也能导致返回。上游pipe路径重新进入循环检查；本例condition_variable的predicate wait等价地循环复查`full || closed`，所有谓词和数据在同一mutex内。C++保证等待的释放锁与阻塞关系，不能推断实现就是xv6的chan扫描；macOS和Linux的底层等待机制不同。

| 时序模型 | 结果 |
| --- | --- |
| wake→prepare→sleep | 错误协议可能睡住，模型安全展示而不真的挂起 |
| prepare→wake→sleep | 登记被清除，跳过睡眠 |
| prepare→sleep→wake | 被设为可运行 |

## 源码与平台差异

实际读取[mit-pdos/xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支/2026-10-08，[kernel/proc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/proc.c)的sleep_prepare/sleep/wakeup和[kernel/pipe.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/pipe.c)的piperead/pipewrite/pipeclose；MIT许可证，完整SHA尚未固定。调用链`pipe predicate → prepare → unlock → sleep → relock → predicate`。原场景RISC-V教学内核管道，本课独立C++单槽与串行状态模型，只保留等待合同，不模拟上下文切换/中断/进程锁。源码引用日期能追溯阅读，不能当固定内核构建版本。[source.json](source.json)。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-08/run.sh
MODE=sanitize sh systems_practice/os/2026-10-08/run.sh
MODE=tsan sh systems_practice/os/2026-10-08/run.sh
```

[src/main.cpp](src/main.cpp)使用RAII锁与线程守卫；线程启动中途抛异常时守卫先close再join。20000次单生产者/消费者传递检查严格顺序，第三线程20000次无状态notify测试谓词复查。close后拒绝put，已存在值可被get取出一次，空槽关闭立即返回。通知噪声是人工额外通知，不声称强迫了操作系统虚假唤醒。

目标xv6观察方案（待具备工具链，在忽略缓存中，不改教学内核）：

```sh
cd systems_practice/.tmp
# 已有、版本核实的xv6检出中执行，先记录git rev-parse HEAD
cd xv6-riscv
riscv64-unknown-elf-gcc --version
qemu-system-riscv64 --version
make qemu
# xv6控制台：usertests；ctrl-p观察进程状态
```

这不是Linux/ARM命令；本期未准备内核补丁、未运行QEMU，构建版本待补，不把以上当验证成功。

## 实际结果与验证边界

[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)通过；[TSan](results/verified-tsan.txt)记录最终运行状态。未测排队时延/CPU吞吐/设备性能。xv6编译、QEMU、Linux与板端均未验证，详见[verification.json](verification.json)。安全模型的失败时序不能证明C++程序发生了丢唤醒。

## 工业故障与迁移

1. 低负载偶发永久等待→条件检查和登记之间有空隙→记录谓词/登记/notify的锁内序号→同一条件锁+原子等待协议；不能靠sleep延时“修复”，回归生产者先到/消费者先到/关闭三种顺序。
2. 偶发空槽读取或重复帧→醒来直接消费，未重新检查→日志区分通知次数和成功取帧次数→predicate wait循环；多消费者抢占需另测，本例未覆盖吞吐公平性。
3. 停机join卡住→只设置closed未通知全部等待者→检查线程栈及关闭路径→锁内设状态、通知双方、排空再join，代价是停止接收新帧。

迁移验收：Linux板端TSan与长期运行、关闭期间故障注入、真实SDK回调的对象寿命、队列深度与请求P99分别验收；C++ mutex可见性不替代DMA/GPU完成通知。

面试追问：1. notify能存储一个事件吗？2. prepare与外层锁如何消除窗口？3. 为什么wakeup还需进程锁？4. 唤醒后为何必须循环？5. close如何同时处理空槽和满槽？6. 怎样区别死锁与生产者已退出？

## 下一节

第12节：上下文切换与调度状态，继续解释“可运行”为什么不等于“立刻执行”。
