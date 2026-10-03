# 2026-10-03 C++17 05：string_view借用与异步请求寿命

## 本课目标与前置

承接noexcept/容器移动：相机请求`camera=123`在网络缓冲区中解析，排队后原缓冲区复用。目标是保留低成本同步解析，同时保证异步持有有效数据。string_view是C++17新增，shared_ptr/移动是既有机制，平台内存分配细节不属于标准保证。现成附加例子，无第二份作业。

## 源码阅读

2026-10-03实际读取[LLVM libc++ main/include/string_view](https://github.com/llvm/llvm-project/blob/main/libcxx/include/string_view)，`basic_string_view`指针/长度构造、`data/size/remove_prefix/substr/at`；调用链为`substr → 边界检查 → 新的指针长度视图`。先尝试release18返回异常短内容、tag缓存失败，改读main，精确commit未固定。源码中的C++20/23分支没有用于例子。许可证[Apache-2.0 with LLVM exception](https://github.com/llvm/llvm-project/blob/main/libcxx/LICENSE.TXT)已读。

上游解决非拥有字符串访问，本课保留指针+长度、substr边界，不复制实现或依赖libc++内部断言。Request包装为独立工程设计。[source.json](source.json)记录阅读和失败。Google/知乎当期机制搜索没有可读原文，不宣称读过文章。

## 机制与知识图谱

`输入拥有者 → string_view同步解析 → 队列跨寿命 → 不可变shared owner → offset重建view`。

`value()`允许空value但拒绝空key/缺等号；`Request`先构造`shared_ptr<const string>`再验证，失败由RAII释放。只记录offset，不记录指向自身string的view，因此vector扩容和小字符串优化不会把view留在旧对象内部。`get()`检查移动后owner为空再重建视图；返回的view仍不能活得比Request的最后一个owner更久。const owner防止底层字符串resize/reallocate，不代表所有其他业务状态天然线程安全。

| 情况 | 同步借用 | 异步持有 |
| --- | --- | --- |
| 局部string马上复用 | 仅在复用前使用有效 | 入队前复制到不可变owner |
| packet含内嵌NUL | 使用指针+明确长度保留内容 | 保存全部字节；data()不保证终止 |
| 容器移动/扩容 | 裸view不延长寿命 | shared owner随对象移动，offset稳定 |

选择代价：本例每请求有string和shared控制块分配/计数成本；低延迟服务也可采用拥有string+offset、共享整帧缓冲池或仅同步借用，但必须证明所有权边界。此处不测性能，不声称零拷贝。

## 运行与观察

```sh
sh run.sh
```

C++17，AppleClang21。测试1000请求入队后覆盖原局部string，验证值未变；空值、内嵌NUL、复制/移动、移动后拒绝、substr越界及三种非法输入。没有执行悬空指针解引用，不用UB作实验。`std::string_view(packet,sizeof(packet))`保留a/NUL/b三个字节，`std::string(v)`按长度复制。

## 故障链路与面试追问

1. 偶发camera值变成下一帧内容 → 队列持有rx缓冲的view → 检查借用来源与复用时点 → 入队时绑定不可变owner，回归生产者先释放的情况；成本是复制或共享计数。
2. vector增长后短字符串坏、长字符串正常 → 自引用view与SSO移动有关 → 只记录offset并按新owner取view，避免依赖实现的SSO阈值；覆盖短长字符串/复制移动。
3. C接口读出多余字符 → data()缺终止契约 → 使用长度接口或显式拥有副本；内嵌NUL另按业务合同拒绝或保留。

追问：1. view复制了什么？2. substr为什么不延长寿命？3. SSO怎样暴露自引用成员问题？4. shared_ptr<const T>是否保证完整业务线程安全？5. 显式长度与NUL终止的区别？6. 如何取舍分配、复制和buffer lease？

## 验证结果与边界

[日志](results/host.txt)包含Release及ASan/UBSan两次PASS：queued=1000、invalid=3、empty/NUL/moved-from/substr边界通过。[verification.json](verification.json)分列状态。没有GPU/NPU/板端或真实网络并发负载，没有性能数字。Sanitizer通过不证明任意调用者永远不会把返回view保存过久。

## 下一课

06结构化绑定与引用：把借用概念扩展到绑定时究竟复制还是引用。
