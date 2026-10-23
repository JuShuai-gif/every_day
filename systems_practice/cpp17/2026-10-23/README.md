# 2026-10-23 C++17 第22课：双资源池转移与scoped_lock

## 本课目标与前置

承接第21课失败边界：两个推理worker池各持有100000个调度额度，双向并发转移必须守住总额200000。耦合机制是多锁死锁避免与异常下的资源/业务状态恢复。mutex源于C++11；scoped_lock及其零锁/多锁接口是C++17内容。

## 源码阅读

2026-10-23实际读取[LLVM libc++ mutex](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/mutex)，tag llvmorg-20.1.8，Apache-2.0 WITH LLVM-exception。调用链：scoped_lock多锁构造→std::lock→unique_lock锁第一把、try_lock第二把、失败释放并yield、换顺序重试；析构用参数包逐个unlock。只读该实现，不把算法当所有标准库的固定实现。[source.json](source.json)保存blob SHA。

原场景是标准库对任意Lockable的多锁获取；本例独立实现额度转移，保留“获取全部锁再修改”“构造失败释放已获锁”，省略真实请求队列、OS锁实现和公平性。没有复制上游代码。

## 机制与知识图谱

`transfer(a,b,n)`先拒绝a/b别名与负数→`scoped_lock`获取两锁→检查额度与注入异常→一次提交两个字段→作用域退出解锁。交换参数调用也能遵循std::lock的死锁避免协议；不保证饥饿自由或延迟上界。锁必须比guard活得久，不能在持锁回调里递归锁同一个非递归mutex。

关键区别：异常解锁只恢复“锁可再次获得”，不撤销已经修改的credits。本例把所有预期失败放在修改前，两个整型增减在约束范围内不抛异常。若业务插入日志分配、容器扩容或SDK调用，要另设计事务回滚，不能把guard当事务管理器。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-23/run.sh release
sh systems_practice/cpp17/2026-10-23/run.sh sanitize
sh systems_practice/cpp17/2026-10-23/run.sh tsan
```

[src/main.cpp](src/main.cpp)完整现成例子，不是新作业。两个线程相反顺序各转移10000次；零额转移是边界；负额、别名、余额不足、提交前异常为4个拒绝。受控Probe让第二次锁获取抛异常，检查第一把已释放；不通过执行死锁或UB验证。

## 故障链路与面试追问

- A持a等b、B持b等a→进程停住：线程栈显示反向嵌套lock；用一次scoped_lock获取完整锁集或统一全局锁序，回归双向压力；不可在已有外层锁时以为局部std::lock解决全局死锁。
- 异常后总额度变小→只恢复锁没恢复字段：在第一字段写入后注入失败可用安全状态模型推导；把失败点移至提交前或提供回滚，回归总额与每池余额。需要外部IO时避免持锁等待。
- 同一池传两次→自锁：入口地址比较拒绝，不能假定多锁算法识别别名。

追问：scoped_lock为何有零锁版本？两把mutex传入顺序相反是否足以制造死锁？try_lock抛异常谁释放第一把？持锁期间抛异常能自动撤销业务数据吗？std::lock保证公平吗？已有外层锁时局部死锁避免为何不够？

## 验证结果与边界

Release、ASan/UBSan、TSan通过，transfers=20000、total=200000、rejected=4、lock_exception_cleanup=1。见[verification.json](verification.json)及[最终Release日志](results/verified-release.txt)。未测锁性能、OS阻塞实现或板端表现；TSan不证明无死锁/无饥饿。

## 下一课

第23课shared_mutex与读者寿命；从多资源修改过渡到读多写少场景。今天主课采用不可变快照，下节将对照共享锁的边界，不能将两者直接断言为性能高低。
