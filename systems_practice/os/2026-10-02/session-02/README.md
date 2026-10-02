# OS第05课：物理页空闲链表与模型加载失败回滚

## 承接与边缘问题

承接04陷入返回，今天05a页分配器空闲链表、05b分配失败与释放责任。场景：旧模型占3页，8页池里加载需6页的新模型，中途不足怎么办？已写好的10–15分钟观察材料，不增加编码作业。本日前面的[04补充](../README.md)因并发旧游标保留，不推进课号。

## 主题一：空闲页链表

实际阅读[mit-pdos/xv6-riscv](https://github.com/mit-pdos/xv6-riscv)，riscv分支2026-10-02，[kernel/kalloc.c](https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/kalloc.c)全文，MIT许可，commit未固定。`kinit→freerange→kfree`把范围向上对齐到页边界并挂入空闲链；`kalloc`持spinlock取头，空链返回0；`kfree`检查对齐/范围，填充值帮助暴露悬空引用，再挂回头部。原项目分配4096字节整页用于用户内存、页表、栈等。填垃圾不能证明消除了use-after-free，也不提供完整双重释放检测。

## 主题二：失败与释放责任

返回空指针是分配接口的一部分，调用者必须决定已经取得的资源归谁释放。新模型只要未提交，就由候选对象持有页租约；第六页不足会展开局部vector，把已经取得的五页归还；旧三页仍有效。这是用户态业务回滚合同，不能说xv6原生使用C++RAII。链表只管理页是否空闲，不知道业务“模型是否完整”。

知识图谱：有限容量→取头/还头→空链失败→候选所有权→析构逆向回收→提交后才替换旧资源。并发安全在xv6由spinlock提供，本例单线程没有锁，不能拿去多线程共享。

## 源码与平台差异

[src/example.cpp](src/example.cpp)是独立C++17状态模型，8个alignas4096页对象、索引链表与used位。保留空链/页粒度/失败归还；额外used位安全拒绝重复释放。不是xv6补丁，不分配真实物理页，不保证PA连续或DMA可用；宿主OS页大小也不由alignas4096决定。Linux内核页分配、用户态malloc、设备DMA都不能据此类比为相同接口。[来源](source.json)。

本次于2026-10-02实际尝试[Google检索](https://www.google.com/search?q=CUDA+transpose+stride+bank+conflict+FP32+FMA+noexcept+vector+xv6+kalloc)和[知乎检索](https://www.zhihu.com/search?type=content&q=FMA%20vector%20noexcept%20kalloc)，均返回Internal Error，未读到文章正文。以下技术依据来自实际取得的GitHub实现和官方资料，不把检索摘要算源码阅读。

## 现成观察示例与命令

```sh
cd systems_practice/os/2026-10-02/session-02
sh run.sh
```

对照：旧3页+新6页触发失败，回滚后仍剩5页；新5页恰好装满；所有租约析构后回到8页。额外验证1000轮8页取还、所有页4096对齐、重复release拒绝，实际计数来自代码，不调用未检查的系统分配接口。Pool必须长于所有Lease，析构检查gets==puts；Lease只移交所有权，不复制。

## 实际结果与验证边界

Apple clang21 arm64 Release及ASan/UBSan均通过：gets=puts=8014、failures=1、free=8，double_free_rejected=1。[完整日志](results/run.txt)、[验证](verification.json)。未计时，无CPU分配延迟、Linux缺页、GPU/NPU/E2E数据。源码已读；本机模型已编译运行；xv6固定commit、RISC-V工具链/QEMU、Linux及板端全部未验证，没有内核修改或运行声明。

## 工业故障与迁移

1. 热更新失败后可用内存逐次下降→怀疑中途分配泄漏→在每一个失败点对比live/gets/puts和旧模型可用性→候选RAII统一回收；代价是峰值仍含旧+新模型，不能把回滚当降峰值方案。
2. 两个请求同时归还同页→链表环/相同页重复分配→使用状态位、所有权日志与并发工具区分重复释放和锁缺失→定义唯一所有者并在生产分配器用适合的同步。used位只用于本例串行检测，不是并发算法。
3. 虚拟地址对齐被误当DMA连续→设备访问失败→核对驱动映射接口和实际分配约束→通过设备SDK分配/映射，不能把本例地址直接交给设备。

迁移验收：真实服务逐点故障注入、旧模型仍可推理、峰值预算含并存与scratch、停止/异常路径全释放；Linux与设备内存分别计数。若峰值不可接受，要考虑分段/离线切换，不能在未提交前释放旧模型。当前证据只支持用户态寿命合同，不能证明内核分配性能。

追问：页粒度为何造成内部碎片？kfree的填充能检测哪些错误？空链返回0时谁回滚？对齐与物理连续有何不同？Pool先销毁为什么危险？线程安全与所有权安全为什么都需要？

## 下一节

第06课按[课程表](../../curriculum.json)继续地址空间机制；本课不增加自测。

[格式化后最终验证](results/final-run.txt)再次通过，保留先前结果。
