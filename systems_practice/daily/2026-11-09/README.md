# 2026-11-09 C++工程：候选构造与无异常提交

## 工业场景

推理服务热更新会话时，第二个资源申请或后端配置校验失败，旧会话必须保持可用。本课用独立CPU资源对象展示强异常保证，实际设备资源接入仍需完成事件与SDK错误处理。

## 概念回顾

候选构造负责把资源准备齐全，提交负责让读者看到一个完整状态。两者之间必须存在明确边界：所有可能失败的分配、配置解析、后端检查都发生在候选内部，成功后才替换当前对象。这样失败只销毁候选，旧会话仍然可用；如果先释放旧会话再创建新会话，就只能提供较弱的恢复保证，服务可能在配置更新失败后完全不可用。

RAII把清理责任绑定到已经构造成功的成员。本例先创建输入资源，再创建输出资源，最后检查配置；构造函数中途抛出异常时，已完成构造的unique_ptr成员自动析构，其拥有的资源被回收。整个Session对象的析构函数并不会在构造失败时执行，因此不能把唯一清理逻辑放进Session析构函数体。值语义容器同样负责自己的存储，避免手工维护多条回滚路径。

提交用unique_ptr的swap完成，它交换所有权而不复制Session。这里默认删除器使交换不抛出异常，旧对象转移给局部candidate，并在函数返回时释放。移动语义只解决所有权转移，不自动提供线程安全：当前示例由单个线程使用，多线程读者需要锁或能保持旧版本寿命的快照，不能保存一个裸指针然后允许另一个线程热更新。

强异常保证也不是外部事务。构造期间如果已经向设备发送不可撤销命令，回滚指针无法撤销设备状态；真实GPU异步任务仍需等完成事件后回收资源。本课故障注入只覆盖CPU资源和配置检查，不假装创建TensorRT执行上下文。测试在两个不同构造阶段失败，核对旧ID与存活资源数，再验证成功替换和非法输入；仅进程退出零不能证明旧服务没有被破坏。

## 知识图谱

`配置校验 → candidate(input → output → backend check) → noexcept swap → 当前新版本 / 局部旧版本析构`；失败边只销毁已经完成构造的候选成员。

## 编码练习

唯一20–30分钟任务：在Session加入第三个由unique_ptr持有的资源，在其创建后增加失败注入；保持旧ID、live数和成功替换的全部断言。本课以外都是已写好的阅读示例。

## 文件说明

src/main.cpp、CMakeLists.txt、run.sh；source.json记录真实来源，verification.json和results保存验证。

同日：[量化](../../quantization/2026-11-09/smoothquant/README.md) · [ARM](../../arm/2026-11-09/README.md) · [OS](../../os/2026-11-09/README.md) · [C++17](../../cpp17/2026-11-09/README.md) · [两篇论文](../../paper/2026-11-09/README.md) · [RK016](../../../rk3588/第03章_中断和中断控制器/RK016/README.md)。

## 编译与运行

在课目录执行`sh run.sh release`、`sh run.sh sanitize`；CMake可用`cmake -S . -B build/cmake && cmake --build build/cmake`。Thor隔离同步/hash复核后运行相同命令，无新依赖。

## 正确性验证

100轮成功替换、200个构造中途失败、100个非法配置；每次失败核对旧ID及2个活资源，退出作用域后live=0。单线程确定性测试，不运行UB，不宣称并发安全。

## 性能分析

不报告性能收益。发布指针成本与创建后端成本不同，生产记录准备/提交/旧资源排空三个区间。GPU kernel、ncu、PTX/SASS不适用于本课CPU所有权；以后CUDA仍固定Thor sm_110，对照架构游标不变。

## 实际运行结果

Mac Release、ASan/UBSan通过，见results。Thor最终验证见verification.json及当日门禁记录；不得用旧日结果代替。没有模型、GPU或NPU测试。

## 工程注意事项

实际读取LLVM llvmorg-20.1.8的[ToolOutputFile.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/llvm/lib/Support/ToolOutputFile.cpp)：CleanupInstaller默认清理、Keep显式保留，构造失败改变清理责任。Apache-2.0 WITH LLVM-exception，2026-11-09全文件。独立启发关系：保留成功前由候选负责回收的结构，改为内存会话；未复制LLVM文件或信号处理。C++17编译；unique_ptr与RAII是此前已有特性，inline static计数器属于17。

## 工业故障与面试追问

先销毁旧会话→新资源失败→服务无当前状态：日志核对旧ID与构造阶段，改为候选后提交。构造失败只靠外层析构清理→资源泄漏：在第二阶段注入失败并查live，改为成员RAII。设备仍在用旧buffer→指针已换但任务未结束：以事件/租约排空，不能用本例同步析构直接迁移。

追问：构造失败会执行哪个析构？强异常保证保护哪些状态？swap为何可作为提交点？自定义删除器有哪些条件？移动后旧资源由谁持有？并发读者如何保留版本寿命？

## 自测问题

如果后端验证会发送不可撤销的设备命令，候选构造加swap还能保证哪些状态，必须怎样重划提交边界？

最终验证：本次最终源码在Thor隔离目录运行Release和ASan/UBSan均通过，原始结果为results/thor-*.txt；同步前后17项SHA256相同。不是RK3588板验。

另实际阅读LLVM同tag libcxx/include/__memory/unique_ptr.h的unique_ptr::swap，确认交换pointer与deleter且声明noexcept；自定义删除器必须满足其交换合同。[源码](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/__memory/unique_ptr.h)。
