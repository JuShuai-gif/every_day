# 2026-10-07 C++17 第09课：any动态值与失败合同

## 本课目标与前置

承接variant状态机。插件配置值的类型集合开放时，std::any拥有一个可复制对象；业务必须在运行时核对实际类型。场景是推理服务配置替换，机制为类型擦除和any_cast失败。any是C++17新增，RAII/异常安全不是17独有；不是把任意指针塞void*。

## 源码阅读

实际读 [LLVM/libc++ llvmorg-18.1.8/include/any](https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/libcxx/include/any)，tag固定，完整commit未另解析，Apache-2.0 WITH LLVM-exception。范围 `_IsSmallObject`、`_SmallHandler/_LargeHandler`、赋值、emplace、any_cast。调用链：构造选择handler→类型查询/销毁/复制分派；赋值先建临时再swap，emplace先reset再构造。独立使用标准API，无上游代码复制。宿主Apple libc++不宣称等于所读18.1.8实现。

## 机制与知识图谱

```text
插件值 → any拥有具体对象 → handler擦除具体操作 → any_cast<T>精确类型检查
                    ↓                           ↓
                 RAII销毁              指针nullptr / 值与引用bad_any_cast
```

any不会把int自动转成long。指针形式适合预期中的类型不匹配；值形式会复制，引用形式可借用但不能越过reset/替换。没有schema版本时any不是持久化格式或跨动态库稳定ABI。

本例用vector负载跟踪alive并注入复制失败：`active=source`先建候选，失败保留旧字符串；`active.emplace<Payload>`会先销毁旧值，构造失败后变空。如果必须保留旧值，使用单独candidate后swap。libc++小对象条件不仅看字节大小，还涉及对齐与nothrow移动；这是实现细节，标准不承诺某个固定SBO容量，任何内存分配/性能推论须另测。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-07/run.sh release
sh systems_practice/cpp17/2026-10-07/run.sh sanitize
```

[完整代码](src/main.cpp)固定C++17，不增加任务。检查空any、精确类型、bad_any_cast、1000次复制异常回滚/成功swap/emplace失败；alive最终0。借用指针在reset前使用，reset后明确丢弃，不通过实际UB证明悬空。

## 故障链路与面试追问

配置静默丢失：在active上emplace新插件值→构造抛异常后has_value为false→最小故障注入复现→候选构造后swap；需要额外临时内存但保留旧配置。

插件升级后cast失败：旧值是int，新插件期待long→指针cast为nullptr或值cast抛异常→记录schema和明确类型标签→边界显式转换/版本适配，不能reinterpret_cast绕过检查。跨DSO还需一致ABI/RTTI与库寿命，本例未测试动态卸载。

验收：缺值与错误类型可区分；失败不会误用旧borrow；不承诺SBO；所有负载释放；平台ABI另验。追问：any和variant何时选？int为何不能cast<long>？值/引用/指针cast成本和失败有什么不同？any为什么要求可复制值？emplace为何不同于赋值？如何避免插件卸载后对象handler失效？

## 验证结果与边界

Release与ASan/UBSan1000循环通过，alive=0，[验证](verification.json)、[来源](source.json)、[日志](results/release.txt)。未测性能、未运行动态库卸载或板端，不能以库实现阅读推断宿主SBO或锁实现。

## 下一课

10：from_chars、部分解析与溢出，承接主课清单输入边界。
