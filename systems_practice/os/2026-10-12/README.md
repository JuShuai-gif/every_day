# 2026-10-12 OS14：睡眠锁的边界与嵌套锁顺序

## 承接与边缘问题

承接OS13管道背压，本节两个主题是14a自旋锁/睡眠锁分工、14b嵌套锁与死锁路径。机器人输入缓冲池中，一个线程等某块数据可用，不应把保护整个缓存目录的锁一起占住。现成例子约10分钟运行阅读，不增加主课作业。

## 主题一：短状态锁与可阻塞资源锁

实际阅读xv6-riscv `kernel/sleeplock.c` 的 `acquiresleep/releasesleep`。短spinlock保护locked/pid，不把spinlock当成长期占用资源的锁。**2026-10-12读取的riscv分支已经使用 `sleep_prepare(lk) → release(&lk->lk) → sleep() → acquire(&lk->lk)`**；旧书常见`sleep(chan, lock)`不能无说明套到此版。

同时阅读 `proc.c` 的 `sleep_prepare/sleep/wakeup`：先在进程锁下登记chan，wakeup清空chan；如果真正sleep前已经被唤醒，sleep看到chan已清空而不进入SLEEPING。醒来仍须while复查locked，因为唤醒不等于独占权移交。调用链为acquiresleep→准备等待→释放状态锁→调度/返回→复查→设置locked。

这一机制连接了“等一个可能很久的事件”和“检查等待条件不能丢唤醒”。它不同于C++标准直接规定mutex使用某个内核API；macOS和Linux标准库如何阻塞不是本例证明的内容。

## 主题二：引用固定身份，等待锁固定内容

`bio.c::bget`先在bcache.lock下查找并增加refcnt，再释放全局锁，才取得某块的sleeplock。refcnt防止等待期间该块身份被复用；块锁保护内容。`brelse`反向先释放块锁，再取得全局锁减少引用。

```text
目录锁：查找 + pin ──释放──> 等待块锁 → 使用块
                                      ↓
目录锁：unpin <──重新获取── 释放块锁
```

如果持有目录锁等待块锁，另一线程持有块锁又需要目录锁，等待图出现环。引用计数大于零不表示当前线程已独占内容；内容锁空闲也不意味着没有等它的已pin线程。

## 源码与平台差异

[MIT xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支读取2026-10-12；LICENSE已读为MIT，未固定commit，读取文件哈希留在[source.json](source.json)。范围：sleeplock.c全部52行、bio.c中bget/bread/brelse、proc.c中上述等待/唤醒函数。原场景是磁盘块缓存；本例为受其启发的独立C++缓存租约及锁序检查器，保留pin→解锁→等待/释放→unpin，省略中断、磁盘I/O、LRU和内核调度。未把C++ mutex称为xv6 spinlock或futex实现。

Google直接端点失败；知乎检索未核实相关原作者案例，精确结论以上游源码为准。没有新增内核补丁；教学研究按当前分支理解，若要跑QEMU应先把读取版本固定并使用该版工具链，不能把本例执行当xv6验收。

## 现成观察示例与命令

[src/main.cpp](src/main.cpp) `Cache::Lease`在目录锁内pin，释放目录锁后等待buffer mutex；异常析构先unlock buffer再unpin。`Guard`以线程本地rank栈，在取得反向锁之前抛异常，安全展示死锁边；不真的让测试挂死。两线程各更新10000次。

```sh
sh systems_practice/os/2026-10-12/run.sh
# 本机Sanitizer重现
cd systems_practice/os/2026-10-12
clang++ -std=c++17 -O1 -g -pthread -fsanitize=thread src/main.cpp -o build/tsan
./build/tsan
# Linux或RK3588：在该目标已有C++工具链上同样运行run.sh
```

检查项：高rank→低rank拒绝、正序成功、异常释放引用、pin期间禁止复用、最终data=20000/ref=0。rank检查器只覆盖显式Guard调用，不是全程序死锁检测器；buffer租约靠结构约束释放顺序。长操作不在目录临界区内执行。

## 实际结果与验证边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[TSan](results/tsan.txt)均通过，Apple Clang21/C++17。源码已读；commit未固定；xv6编译/QEMU、Linux原生运行、板端设备均未验证，见[verification.json](verification.json)。没有CPU等待、NPU、GPU或E2E性能测量。通过TSan不证明没有死锁或所有调度下都正确。

## 工业故障与迁移

1. 全部摄像头请求同时停止→持目录锁等繁忙块形成环或全局串行→采线程栈，画持有/等待关系，区分环与一个慢I/O→pin后释放全局锁再等待；必须保证pin期间身份不复用。
2. 偶发读到别块数据→仅保存指针却未pin→记录资源代次/refcnt与回收事件→在目录锁内固定引用，再获得内容锁；引用开销不能靠跳过来优化。
3. 异常后池越来越小→unpin缺失→对照获取/释放计数并注入消费者异常→使用租约；清理应无异常，生产实现需处理锁失败策略而非在析构中传播。

迁移验收：目标上验证唯一身份、异常释放、关闭时排空等待者；目录大小固定后观察争用，未测前不更换无锁结构。操作系统等待实现、驱动完成事件及DMA一致性需另验。现成例子没有关闭中的设备请求，不能作为完整推理资源池。

追问：为何睡眠锁内部仍有spinlock？登记chan到sleep之间的唤醒怎样保存？唤醒为何仍要while？refcnt与独占锁分别保护什么？bget为何先pin再等？全局rank能发现哪些/遗漏哪些死锁？

## 下一节

OS15：FD/file/inode层次与路径名/引用寿命，继续解释“身份固定”如何延伸到模型文件替换。
