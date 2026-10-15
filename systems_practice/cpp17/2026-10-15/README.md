# 2026-10-15 C++17第16课：invoke/apply与请求参数寿命

## 本课目标与前置

承接CTAD，给推理请求分发器把tuple参数展开到成员函数。`std::invoke`与`std::apply`是C++17新增；移动与unique_ptr来自C++11。输入是一份拥有int载荷的tuple和借用的Session，校验后更新计数。同步例子不包含线程队列，不能把引用捕获当作异步安全。

## 源码阅读

实际读 [LLVM/libc++ llvmorg-20.1.8](https://github.com/llvm/llvm-project/tree/llvmorg-20.1.8/libcxx)，`include/__functional/invoke.h::invoke`、`include/__type_traits/invoke.h::__invoke`七种分派、`include/tuple::__apply_tuple_impl/apply`约1370–1383行，Apache-2.0 WITH LLVM-exception，读取日2026-10-15。`apply→index_sequence展开get→__invoke`；成员函数对象可为对象、reference_wrapper或指针类，普通函数走直接call。记录见[source.json](source.json)。本例**独立启发实现**，调用标准API，不复制库代码、不重写完整类型萃取。

## 机制与知识图谱

`拥有tuple → std::move(tuple) → get得到右值unique_ptr → apply展开 → invoke成员函数 → value参数接管所有权 → 验证/更新或异常析构`。

apply不会自动复制、延长被引用对象寿命或保证业务事务。forward只保留值类别；lvalue tuple不能把unique_ptr复制到按值参数，因此静态is_invocable为false。移动tuple后参数被消费，异常也不会返还原请求载荷。Session用std::ref仍是借用，必须在调用结束前活着。

invoke成员数据返回引用，用`decltype`静态断言为int&，可直接修改total；若包装函数改成`auto`返回，会丢引用，应根据合同使用decltype(auto)。空tuple支持零参数调用。`make_tuple(x)`保存值快照，`tie(x)`保存借用，例中3→8能观察两者差异；不制造悬空引用。

## 运行与观察

```sh
# 工作目录为本README目录
sh run.sh release
sh run.sh sanitize
```

[src/main.cpp](src/main.cpp)涵盖move-only成员调用、数据成员引用、空tuple、拥有/借用对照、两个拒绝路径与异常后的计数不变。具体日志 [release](results/release.txt) / [sanitize](results/sanitize.txt)。使用标准C++17，不引用C++23 invoke_r。

## 故障链路与面试追问

1. 请求排队后随机崩溃：tuple使用tie/forward_as_tuple借用短命输入；先画producer/consumer生命周期，在不解引用悬空对象的审查中确认所有权，改用拥有tuple，Session用受控shared ownership或队列关闭排空；移动载荷不等于借用Session安全。
2. 重试请求时载荷变空：apply(std::move(args))已消费unique_ptr，即使submit抛异常；记录入参move和失败点，设计重建/可重放请求或在转移前验证；不能“再move一次”恢复资源。
3. 执行失败total却增加：业务先更新后校验，invoke无事务保证；当前先校验再提交，回归-1与limit+1；复杂状态需要候选对象或回滚。

追问：①invoke支持哪些成员对象形式？②apply怎样用索引展开tuple？③std::move何时实际转移资源？④异常后参数归谁？⑤auto与decltype(auto)怎样影响成员数据返回？⑥异步队列里ref需要什么生命周期保证？

迁移验收：目标编译器/stdlib支持C++17；验证所有tuple元素的拥有/借用合同、move-only、空包、业务错误、关闭时对象寿命。不用库内部noexcept实现推导所有标准版本保证。

## 验证结果与边界

Mac Release/ASan/UBSan通过，total=9，两个拒绝，拥有值3/借用值8。源码版本已固定；目标Linux/板端编译未验，无性能数字、无GPU/NPU工作。参见[verification.json](verification.json)。Google检索页未作为已读技术正文；知乎访问403；技术结论来自已读libc++及本地编译。

## 下一课

第17课inline变量与ODR，解释同一配置在多个翻译单元中的身份。
