# 2026-10-07 OS 第10节：原子互斥与嵌套关中断

## 承接与边缘问题

承接COW引用计数，今天10a原子互斥/可见性＋10b关中断/嵌套状态。边缘请求队列的短临界区需要防止并发更新；内核中断处理与进程上下文同时访问同一锁时，还可能发生同核自锁。阅读约10–15分钟，完整现成例子，不增加作业。

## 主题一

`Spin::lock`用atomic_flag acquire，unlock用release；互斥阻止两个线程同时改count，release/acquire使临界区内容在后续获取时可见。原子变量本身可见不等于普通成员自动安全，count/mirror都必须在同一锁下修改。失败忙等会占CPU，yield也不保证公平、无饥饿或实时上界；长等待用可睡眠互斥与队列协议。此例没有报告“自旋更快”。

## 主题二

本机 `InterruptState` 是安全状态模型：初始enabled记入saved，仅在depth从0变1时保存；push后屏蔽，最后一次pop才恢复。初始已关的状态必须保持关闭。关本核中断不能阻止另一核，因此仍需原子互斥；只用锁而允许同核中断进入相同锁又会自锁。

```text
初始开 → push(depth1,saved开) → push(depth2) → pop(depth1,仍关) → pop(depth0,恢复开)
初始关 → push(depth1,saved关) → pop(depth0,仍关)
```

宿主模型不执行特权指令，也不在用户态禁用macOS/Linux中断。嵌套过早enable和pop下溢作为受控失败检查，不能用宿主线程模拟器证明内核中断时序。

## 源码与平台差异

实际读 [MIT xv6-riscv/riscv/kernel/spinlock.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/spinlock.c)，日期2026-10-07、完整commit未固定，MIT LICENSE已读。路径 `acquire→push_off→原子exchange`，`release→原子store→pop_off`；还读holding。当前分支使用 `__atomic_exchange_n(...ACQUIRE)`，不要照抄旧教材的sync API当今日源码。RISC-V源码注释里的amoswap/fence不是本机A64实测；独立C++17例子只保留互斥和状态不变量，不改xv6，不实现调度器。来源见[source.json](source.json)。

## 现成观察示例与命令

```sh
sh systems_practice/os/2026-10-07/run.sh release
sh systems_practice/os/2026-10-07/run.sh sanitize
sh systems_practice/os/2026-10-07/run.sh tsan
```

[src/main.cpp](src/main.cpp)：4线程各10000次更新；两个初始中断状态、错误pop与异常解锁。lock_guard在异常期间释放锁，线程集合负责join。并发输出通过最终count/mirror核对；失败退出非0。xv6/QEMU未安装/运行，若在已有对应仓库继续验证：记录 `git rev-parse HEAD`，运行 `make qemu`，核对该分支riscv工具前缀；本课没有需要合入的内核补丁。

## 实际结果与验证边界

Release和ASan/UBSan实际PASS：40000受保护更新、异常后再次获取锁、两种嵌套初始状态、3个非法pop情况。最终TSan见[verification.json](verification.json)，原始输出在results。未测性能；Linux、xv6构建、QEMU、中断硬件、目标板均未验。

## 工业故障与迁移

同核中断中锁死：普通路径持锁后被打断→中断再次自旋→跟踪锁owner/中断状态与调用栈→在适合的内核路径屏蔽本地中断并正确嵌套，不能把用户态yield当修复；回归嵌套与异常路径。

高CPU但吞吐低：持锁线程被抢占/临界区阻塞→其余线程浪费周期→测持锁时间和调度切换→缩短临界区或换睡眠锁；回归长持锁、异常与退出。内核锁选型须另读Linux版本，C++flag没有xv6的cpu owner诊断。

验收：数据都受同一锁；不持自旋锁进行I/O或等待设备；恢复进入前状态；记录平台；先验证正确性再评估吞吐。追问：acquire是否让过去写入发布？关中断能保护多核吗？为什么只外层保存intena？yield保证公平吗？原子flag和临界区数据各承担什么？异常时谁解锁？

## 下一节

11：登记等待到睡眠的原子关系＋谓词复查/丢失唤醒，从忙等转到阻塞队列。
