# 2026-10-19 C++17 第19课：扩展对齐与对象存储

## 本课目标与前置

承接第18课对象构造。推理服务有128字节对齐的Slot，需在vector扩容、独立分配和构造异常时保持合同。alignas是C++11；C++17扩展对齐new/delete是本课新增边界。128是**示例接口要求**，不是宣称所有CPU的cache line为128，也不是DMA对齐证明。

## 源码阅读

[LLVM llvmorg-20.1.8 libcxx/include/__new/allocate.h](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/__new/allocate.h)，实际读`__is_overaligned_for_new`、`__libcpp_allocate`、`__libcpp_deallocate`、`__libcpp_deallocate_unsized`。根据所需alignment与默认new对齐比较，分配和释放对称传递`align_val_t`；Apache-2.0 WITH LLVM-exception。它服务于库分配辅助路径。本课独立调用标准容器/make_unique，不复制内部函数、不依赖该私有ABI；本机系统libc++未声称就是该tag。[来源](source.json)。

## 机制与知识图谱

`alignas(128) Slot` → `alignof=128` → `sizeof`是128的倍数 → vector每个元素都满足对齐；扩容可能移动到新地址，旧指针仍会失效。对齐解决地址约束，不解决借用寿命、缓存伪共享或设备可见性。

`make_unique`调用构造表达式；若构造抛出，存储被回收，尚未完成构造的对象不调用其析构，已完成的子对象按语言规则清理。例子在增加alive之前注入失败，析构计数并不单独证明分配器无泄漏，ASan是额外证据。

`std::align`只在既有字节区内寻找位置。给256B且基址已128对齐，从base+1开始，舍去127B后剩128B；空间仅127B时失败且指针/space不变。找到地址尚未开始Slot寿命，不能直接把字节区当已构造对象使用。本例不做无意义的placement new，下一课pmr再连接资源寿命。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-19/run.sh
MODE=sanitize sh systems_practice/cpp17/2026-10-19/run.sh
```

[src/main.cpp](src/main.cpp)用C++17/RAII，0/1/3/257元素和emplace扩容后检查每个地址；make_unique正常与构造失败；std::align足够/不足空间。不是额外编码作业。Linux目标以CXX=g++运行同入口，ABI/标准库须独立验证。

## 故障链路与面试追问

1. 新类型加alignas，旧自定义pool仍返回默认对齐地址→UB/对齐检查失败→记录请求对齐和地址模值→修复allocator的对齐分配与配对释放；代价是padding和额外元数据，回归所有尺寸。
2. 地址模值正确但扩容后读到旧数据→错误保留vector元素指针→记录capacity与data变化/用ASan检查→改为索引或稳定所有权；预留容量只在上界可信时有效，不能当永久地址保证。

追问：alignas与sizeof关系？扩展对齐何时进入align_val_t重载？为什么new/free不能随便配对？构造失败时哪些析构会执行？std::align为什么不创建对象？对齐128为何不能直接证明消除了伪共享？

## 验证结果与边界

[release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)通过：align128/sizeof128，构造失败1、空间失败1，alive=0。未计时，无CPU/GPU/NPU/E2E收益数据。未运行Linux和板端；没有自定义allocator、DMA绑定或并发支持声明。[verification.json](verification.json)。

## 下一课

第20课：pmr与resource寿命。保持分配/对象寿命/借用三条边界分别可追踪。
