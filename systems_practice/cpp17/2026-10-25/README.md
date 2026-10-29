# 2026-10-25 C++17第23课：共享锁与解锁后的读者寿命

## 本课目标与前置

接22课多锁异常安全，今天维护一个读多写少的模型配置：四个读者需要一致的generation和32个权重，写者构造/验证候选后发布。`shared_mutex`是C++17新增，`shared_lock`来自C++14，shared_ptr/RAII是更早基础。锁保护指针对象的并发访问，复制的共享所有权保护解锁后的旧快照，两者不能互换。

## 源码阅读

实际读取[LLVM llvmorg-20.1.8 libcxx/src/shared_mutex.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/shared_mutex.cpp)与[include/shared_mutex](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/shared_mutex)，Apache-2.0 WITH LLVM-exception。`shared_mutex::lock_shared`委托`__shared_mutex_base::lock_shared`，状态字分写者进入位与读者计数；写者先占写位，再在gate2等待读者退出，新读者在gate1等待；最后一个读者解锁通知写者。具体实现有内部mutex与条件变量，读锁不是“零写入计数的无锁读”。[source.json](source.json)。

这是该libc++版本的实现解释，不是C++标准保证写者公平，也不证明Apple当前libc++逐字采用同一实现。示例只调用标准C++17接口、独立实现业务快照，未复制锁实现或假称跨OS行为一致。

## 机制与知识图谱

```text
prepare(分配/填充) → validate(可能失败) → unique_lock短暂swap → 锁外销毁旧引用
read → shared_lock → 复制shared_ptr<const State> → unlock → 读不可变权重
```

`const State`与不暴露可变别名使快照在解锁后仍一致；shared_ptr的控制块线程安全不意味着同一个shared_ptr对象可以无锁读写。构造失败不触及current，提交swap不分配；旧vector最后一次释放放在锁外，避免把析构延迟算入临界区。持有者可以跨版本延长旧内存寿命，所以热更新峰值要计入仍在使用的快照。

边界例先持有generation0再发布1，旧引用仍可读取。输入负generation拒绝，候选验证抛异常后current仍为1。并发示例不保证真实公平/最大等待，也不执行错误的裸引用解锁访问来制造UB。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-25/run.sh release
sh systems_practice/cpp17/2026-10-25/run.sh sanitize
sh systems_practice/cpp17/2026-10-25/run.sh tsan
```

[src/main.cpp](src/main.cpp)是完整现成例子；Apple clang21严格C++17。`Joined`在启动线程途中失败也join已启动线程；读者通过原子标记报告不一致，避免线程内抛异常导致terminate。四读者各5000读取，写者最终发布501；2种拒绝、旧generation0、全局alive=0验收。索引/运行日志独立保存，不增加第二个作业。

## 故障链路与面试追问

1. 解锁后偶发use-after-free→返回State裸引用或string_view→用快照存活计数、ASan和热更新压力区分→返回持有所有权的不可变快照，代价是引用计数和旧版本峰值内存。
2. 读线程多却吞吐下降→共享锁内部读者计数竞争或持锁业务过长→与mutex/原子快照在真实读写比下对比等待与临界区时长→缩短持锁范围或按证据替换；本课没有性能实测，不承诺shared_mutex更快。
3. 发布P95抖动→最后旧引用在锁内释放大对象→记录析构阶段/锁持有时间→swap后在锁外析构；依然需要控制旧引用总量。

追问：①共享锁保护哪个对象？②shared_ptr为何仍需锁？③const能否防止所有可变别名？④读者延长寿命的内存代价是什么？⑤写者公平是标准保证吗？⑥异常发生在prepare和publish阶段分别会留下什么状态？

## 验证结果与边界

[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)、[TSan](results/verified-tsan.txt)均通过，20000读取、2拒绝、最终501、live0。[verification.json](verification.json)。TSan不证明公平或所有调度安全；Linux/目标板/时延和吞吐未测。GPU/NPU与本课无关，未使用其性能作为对照。

## 下一课

24课条件变量与关闭排空，连接“锁保护状态”到“正确等待状态变化”。本节只推进23号，不与主方向C++轮换混为一套游标。
