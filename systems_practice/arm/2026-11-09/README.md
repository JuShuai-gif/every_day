# 2026-11-09 source10：NEON packing双槽与租约回收

## 本课目标与前置

相机输出已pack4，但下游仍在读取时下一帧复用了同一槽。两个固定槽把容量拒绝与最后消费者释放联系起来。 本栏目为现成附加例子，不增加必做编码任务。前置：昨日课、RAII与容器寿命。

## 机制与知识图谱

Pool::acquire先检查use_count==1，只有pool本身仍持有时才允许pack；返回shared_ptr<const vector>延长槽寿命。固定两槽没有缓存淘汰器，也不宣称硬实时；shared_ptr引用计数、分配、首次触页仍有成本。只支持单线程申请，其他线程不得同时改变pool槽；仅消费者释放独立shared_ptr不等于任意并发get安全。

`输入合同 → 取得所有权/准入 → 执行与错误返回 → 推进状态 → 发布或回收`。关键函数见src/main.cpp；没有把API返回成功等同最终业务完成。

## 源码阅读

实际阅读[PoolAllocator::fastMalloc / fastFree / clear，budgets与payouts分离](https://github.com/Tencent/ncnn/blob/master/src/allocator.cpp)，master / 2026-11-09，许可BSD-3-Clause。原实现是推理内存池；独立示例保留在用/可复用区分，改为两个vector槽，不声称复刻ncnn策略。NEON pack沿用昨天独立实现，新增容量和回收验证。 分支读取只固定读取日，目标BSP/库仍需精确版本核验。知乎定向搜索未获得匹配原作者正文，不用无关搜索结果作依据。

## 运行与观察

在本目录执行`sh run.sh release`和`sh run.sh sanitize`。C++17；CMakeLists.txt亦可构建。原始Mac结果在results；Thor以当日隔离同步及最终hash结果为准。测试使用私有build目录或匿名pipe，不访问用户业务文件。至少覆盖空/边界、失败恢复与正确性oracle。

## 故障链路与面试追问

槽忙仍重写→旧消费者读取新帧→核对两份lease同时存活的oracle→忙时拒绝；cache clear被当强制释放→在用数据寿命错误→检查所有权计数→最后租约释放才回收。

追问：如何区分capacity与RSS？use_count能否作并发锁？为什么返回const？尾部访问如何界定？何时两槽仍不足？clear是否可以释放在用对象？

## 验证结果与边界

Mac Release和ASan/UBSan通过；详见results。功能验证不声称吞吐、实时性或完整推理产品。无GPU/NPU测量，CUDA执行固定Thor SM110。迁移验收须在目标Linux运行相同错误路径并对齐源码SHA256；ARM/RK3588不是同一板端验收。

## 下一课

source11：packing工作集与公平总耗时；同日不重复推进。

主要能力层2/3：CPU缓冲区所有权与真实NEON布局。vld1q_f32加载4个连续float，vst4q_f32交错输出四组lane，尾部标量处理；标量oracle逐元素检查。汇编生成：`c++ -std=c++17 -O2 -S src/main.cpp -o results/arm.s`，观察LDR Q/LD1与ST4，具体寄存器由编译器决定。未测性能，内核复用收益不得忽略租约/申请与拒绝成本；本日不涉及页表/内存序，不引用本地PDF未读页。

最终验证：本次最终源码在Thor隔离目录运行Release和ASan/UBSan均通过，原始结果为results/thor-*.txt；同步前后17项SHA256相同。不是RK3588板验。

最终src/main.cpp SHA256：`22079f4ce068be403c0c2f3f8ca33113b670d4894da82bef15142af413750cee`。Mac/Thor真实汇编分别保存results/arm.s、thor-arm.s；源码不变。
