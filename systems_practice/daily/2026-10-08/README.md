# 2026-10-08 C++ 工程知识：有界 PMR 请求内存与异常后整批回收

## 工业场景

机器人推理服务每帧构造最多64条80字符的候选标签。输入是标签数量和模拟坏标签位置，输出只有计数与字符总数；请求临时对象不得逃逸。16KiB栈内缓冲作为**本例临时数据预算**，耗尽时拒绝本批，保留上一已发布结果。它不代表整个服务零堆分配或硬实时保证。本课解决嵌入式C++的资源上界、失败可恢复与对象寿命，不调用GPU/NPU。

## 概念回顾

单调内存资源适合一批对象一起消亡的请求：每次申请满足尺寸和对齐要求，单个对象归还存储时通常不回收空间，最后统一释放。它节省的是细粒度回收管理，却不自动限制总量。默认上游仍可申请堆内存，所以固定预算必须显式接入空资源，让容量不足转为分配异常。资源只管理字节，对象析构仍由容器负责；释放整块内存既不会逐个调用字符串析构，也不会使已有容器自动忘记原来的容量。

这让分配策略与异常安全紧密耦合。候选标签必须先在局部容器中构造，只有整批成功才发布不含借用地址的结果。异常路径先让局部容器析构，再重置资源，下一帧才能安全复用缓冲。只调用容器清空并不结束容器自身对容量的所有权，过早重置会让新对象覆盖旧容器仍认为可用的存储。成员声明顺序也参与合同：缓冲最先构造，资源其次，审计包装最后，因此逆序销毁时依赖仍然存在。

嵌套容器容易绕过预算。普通字符串使用自己的分配器，而多态字符串经由支持分配器构造的容器获得同一个资源，才能把长字符串内容计入请求预算。预留容量减少向量扩容遗留的旧块，但不能消除字符串内容分配，更不能把累计申请字节等同于常驻内存。资源不提供线程安全，本例一请求一所有者，不跨线程共享。底层缓冲的对齐和生命周期是语言与库合同；操作系统页映射、首次触页以及硬件缓存影响时延，但本机分配次数检查并没有测到这些成本。

## 知识图谱

`Request拥有storage → monotonic_buffer_resource → Audit → pmr::vector<pmr::string>`；构造顺序向右，销毁向左。`解析/分配失败 → 局部析构 → release → 下一帧`；`全部成功 → 发布Result值 → 局部析构 → release`。

前置：RAII、vector扩容、异常栈展开。区分：对象寿命/字节寿命、clear/release、累计申请/RSS、空上游/默认堆上游、私有请求/共享资源。资源边界不等于锁边界。

## 编码练习

**唯一必做任务，25分钟：**在已写好的`Request::execute`中加入业务预算`max_chars`，在任何标签插入前检查下一条是否超预算，拒绝时保持published不变；完成0、恰好5120、5119三种边界验证。5分钟阅读所有权链，12分钟修改与失败路径，8分钟运行Release和Sanitizer。完整基线已经可运行，不要求重写分配器或新增线程池。

源码启发：[LLVM仓库](https://github.com/llvm/llvm-project)，2026-10-08读取main的[实现](https://github.com/llvm/llvm-project/blob/main/libcxx/src/memory_resource.cpp)中`__null_memory_resource_imp::do_allocate`、`align_down`、`__try_allocate_from_chunk`、`monotonic_buffer_resource::do_allocate`，及[头文件](https://github.com/llvm/llvm-project/blob/main/libcxx/include/__memory_resource/monotonic_buffer_resource.h)的release/析构。Apache-2.0 WITH LLVM-exception；旧tag链接Cache miss后改读main，完整SHA未固定。原场景是通用标准库资源实现；本例**独立使用标准API**，保留上游失败及区域寿命机制，不复制其增长算法、不实现通用线程安全资源。网页main不等于本机Apple libc++同版本，实际计数来自本机。

## 文件说明

[src/main.cpp](src/main.cpp)、[build.sh](build.sh)、[run.sh](run.sh)、[source.json](source.json)、[verification.json](verification.json)、[结果](results/verified-release.txt)。

每日附加现成材料：[AWQ第二轮](../../quantization/2026-10-08/awq/README.md) · [ARM16 packing](../../arm/2026-10-08/README.md) · [OS11等待唤醒](../../os/2026-10-08/README.md) · [C++17第10课解析](../../cpp17/2026-10-08/README.md) · [两篇论文](../../paper/2026-10-08/README.md)。这些不是额外必做作业。

## 编译与运行

在EveryDay根目录执行：

```sh
sh systems_practice/daily/2026-10-08/run.sh
MODE=sanitize sh systems_practice/daily/2026-10-08/run.sh
```

Apple clang21，arm64 macOS；严格C++17，警告视为错误。Linux可用已安装C++17编译器运行相同入口；真实板端未运行。首次编译确认标准库提供非experimental的`<memory_resource>`。

## 正确性验证

65个已观察到的reserved路径分配点分别注入bad_alloc；每次检查旧结果保持，再解除故障并重试。1000次成功/业务失败循环验证release后复用；另测空请求、1000000条触发有界失败、64字节对齐与嵌套资源一致性。外部Result没有字符串视图，所以不存在请求结束后借用读取。ASan/UBSan检查通过不证明任何异步SDK已经完成；本例没有异步访问。

## 性能分析

同样64条长字符串，growth申请71次/9696字节，reserve为65次/7680字节；这是Audit成功申请的累计payload，失败调用也会增加calls但不会增加bytes。不同libc++增长策略可改变数值。16KiB为保留容量，还存在对齐空洞；没有测RSS、页故障、尾延迟或推理端到端收益。reserve过大反而立即耗尽，arena对长寿命、随机释放负载可能浪费更多内存。

生产验收先采分配次数、失败率、最大并发请求数和CPU请求P50/P95/P99，再测预触页/堆方案；每worker一个16KiB缓冲的总预算随worker数增长。GPU/NPU/传输没有测量，不填性能数字。

## 实际运行结果

[Release](results/verified-release.txt)与[ASan/UBSan](results/verified-sanitize.txt)通过。实际输出：`failure_points=65 reuse=1000`。详见验证记录；本课不报告速度提升。用户四个既有修改文件不参与格式化；仓库脚本只在今日源码的隔离镜像运行后复制回格式结果。

## 工程注意事项

`Request`不可复制也不可移动，因为内部资源指向自身缓冲；可在外部用稳定地址的唯一所有者管理整个Request。不要返回容器、指针或string_view。声明顺序需保持storage早于resource。空上游只约束接入该资源的分配，日志、异常运行库、外部SDK仍可能用堆。生产并发需单独所有权或同步，不能把本例资源直接设成全局默认资源。

## 工业故障与面试追问

以下为可诊断的工程失效路径，非声称已遇到的生产事故：

| 触发→信号 | 根因与最小诊断 | 修复与回归 |
| --- | --- | --- |
| 重复请求后偶发标签改变 | 容器仍活着就release；比较数据地址和销毁时序 | 让容器先离开作用域，重复复用/ASan回归；不靠clear |
| 固定缓冲仍出现堆分配 | 普通string或默认upstream逃逸；审计嵌套allocator | pmr::string＋空上游；测试超过SSO长度，保留bad_alloc拒绝路径 |
| 一次OOM之后所有请求都失败 | 单调资源未重置，已析构对象的旧块仍占预算 | 失败路径整批回收，逐分配点注入再重试；不能提前发布半批 |

追问：1. deallocate为什么可能不回收？2. release为什么不能代替析构？3. pmr::vector如何传递分配器给pmr::string？4. reserve如何影响峰值而非仅调用次数？5. 移动Request会破坏哪个地址合同？6. 多worker下怎样建立全服务内存上界？

## 自测问题

如果把返回值改为指向标签内容的`string_view`，并由异步发送线程稍后使用，要同时改变哪些所有权与回收条件，才能继续保证固定预算和异常可恢复？
