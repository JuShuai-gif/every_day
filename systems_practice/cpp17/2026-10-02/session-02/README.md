# C++17第04课：noexcept怎样影响vector扩容的复制成本

## 本课目标与前置

推理请求列表增长时，一次reserve为何可能复制全部元素？把第03课移动所有权推进到**移动的异常合同与容器事务回滚**。noexcept和移动是C++11基础；inline static计数器与`is_nothrow_move_constructible_v`按C++17编译。源码内部带C++20宏不表示例子使用C++20。本日早先[03补充](../README.md)不重复计课。

## 源码阅读

[llvm/llvm-project](https://github.com/llvm/llvm-project)，release/18.x，读取2026-10-02，commit未固定，Apache2.0 WITH LLVM-exception。实际读[libcxx/include/vector](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/vector)的`reserve`、`__swap_out_circular_buffer`及[__memory/uninitialized_algorithms.h](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/__memory/uninitialized_algorithms.h)的`__uninitialized_allocator_move_if_noexcept`。调用链为分配候选buffer→move_if_noexcept逐个构造→完成后交换→旧存储释放；构造守卫清理已经成功创建的候选元素。

原场景是标准容器异常安全。保留“可抛move且可copy时选择copy”的可观察行为；独立测试类只用int负载和计数，不复制libc++实现，不把宿主Apple libc++等同于release18源码构建，也不推断其他库的增长倍数。

本次于2026-10-02实际尝试[Google检索](https://www.google.com/search?q=CUDA+transpose+stride+bank+conflict+FP32+FMA+noexcept+vector+xv6+kalloc)和[知乎检索](https://www.zhihu.com/search?type=content&q=FMA%20vector%20noexcept%20kalloc)，均返回Internal Error，未读到文章正文。以下技术依据来自实际取得的GitHub实现和官方资料，不把检索摘要算源码阅读。

## 机制与知识图谱

类型trait→选择复制或移动→候选区构造→失败清理/成功提交→引用失效与峰值内存。只写`std::move`不会承诺不抛异常；它产生右值表达式。若移动可能抛且原对象已被修改，失败后恢复旧值会困难；可复制时保留旧对象能支持强保证。若仅能移动且该move抛，某些vector操作的保证会放宽，不能把本例强回滚推给所有类型。

[src/example.cpp](src/example.cpp)的Item<true/false>只有noexcept合同不同；reserve(4)后构造四个对象，reserve(old_capacity+1)强制扩容。noexcept类型观察到4move/0copy；另一类型4copy/0move。reserve(capacity)没有重分配。故障注入在候选copy构造前抛，不篡改源对象、不触发UB。

## 运行与观察

```sh
cd systems_practice/cpp17/2026-10-02/session-02
sh run.sh
```

四个位置逐一注入copy异常，核对data/capacity/size/原值全部不变，候选已构造对象正确析构，作用域结束live=0。真实Apple clang21 arm64 Release与ASan/UBSan均通过。[run.txt](results/run.txt)、[验证](verification.json)、[来源](source.json)。没有跑上游测试，也不把构造次数等同于延迟；所有性能域未测。

## 故障链路与面试追问

1. 请求数组扩容出现CPU尖峰→元素move缺noexcept导致昂贵copy→记录copy/move计数与分配，检查trait而不是猜测STL慢→只有确实不抛的移动才标noexcept，或稳定容量reserve；代价是预留内存和峰值需要预算。
2. 扩容后旧指针偶发崩溃→外部缓存元素地址失效→在容量增长点核对data变化与所有观察者寿命→使用索引/稳定句柄或隔离生命周期；不能靠reserve“永久保证地址”，容量仍可超出。
3. noexcept函数实际抛出→进程terminate→先审查内部操作和故障路径→修正异常合同；本例不故意终止进程来当测试。

迁移验收：真实元素类型的trait/复制成本、最大容量、故障点rollback、地址使用者、内存峰值和请求P95一起检查；本例int对象太小，没有性能收益推论。若预留造成不可接受峰值，选分块或稳定存储须重新评估cache代价。

追问：move_if_noexcept如何选择？删掉copy后保证如何改变？reserve与resize差异是什么？为何不能盲加noexcept？扩容时旧对象何时销毁？容量不变时哪些引用有效？

## 验证结果与边界

源码已读、现成示例已交付、本机两种构建通过4个故障注入和两条正常分支。没有Linux/板端或真实业务性能证据；无需GPU/NPU参与。附加阅读无第二个必做任务。

## 下一课

第05课按[课程表](../../curriculum.json)继续；与本课类型约束和库接口的关系在下一期建立。

[格式化后最终验证](results/final-run.txt)再次通过，保留先前结果。
