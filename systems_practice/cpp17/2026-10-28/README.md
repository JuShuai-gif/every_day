# 2026-10-28 C++17 第26课：原子与发布可见性

## 本课目标与前置
边缘服务由生产线程填充帧、由推理线程消费。两个紧密机制是 release/acquire 发布可见性与数据竞争边界：只有原子标志的 acquire 读看到 release 写后，普通数据的先前写入才建立同步；普通 `value` 不能在无同步时并发读写。

## 源码阅读
实际阅读 LLVM `llvmorg-20.1.8` libc++ `include/atomic` 与 `__atomic/atomic_base.h` 的 `store/load` 路径（Apache-2.0 WITH LLVM-exception，2026-10-28）。库把标准内存序映射到编译器/平台原子原语；本例独立保留发布合同，省略 lock-free 查询和平台汇编。

## 机制与知识图谱
producer writes payload → release store flag → acquire load flag → consumer reads payload。`relaxed` 只保证原子性/修改顺序，不提供 payload 可见性；mutex、Linux futex 与硬件 cache coherence 是不同层次。代码只允许一个生产者和一个消费者，stop/异常路径仍需 join。

## 运行与观察
`sh systems_practice/cpp17/2026-10-28/run.sh`；输入是固定整数 42，边界是消费者自旋直到发布。ASan/UBSan 可查越界但不能证明内存序正确，TSan 才能帮助发现数据竞争；本次未在 TSan 下运行，不能扩大结论。

## 故障链路与面试追问
flag 用 relaxed→消费者偶发旧 payload→改 release/acquire；先读 payload 后写 flag→数据竞争→重排/未定义行为→固定写入顺序。追问：acquire 同步什么？为什么 volatile 不够？何时 mutex 更合适？`seq_cst` 与 acquire/release 的代价？如何设计多生产者队列？

## 验证结果与边界
Apple Clang C++17 Release 实际通过 `release_acquire_pass value=42`；sanitizer、Linux、RK3588/Thor 未验证，无性能结论。

## 下一课
第27课是构建与库边界：ABI、sanitizer 与编译特性。
