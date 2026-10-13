# 2026-10-13 C++17 第14课：参数包、有序执行与事务边界

## 本课目标与前置

承接if constexpr，为推理服务启动多个配置步骤：必须按声明顺序执行，某步失败时不能让半配置上线。输入是三个可调用对象，输出是配置vector与调用日志。两个耦合机制为C++17折叠表达式和内建逗号的顺序保证；RAII/vector强异常隔离属于更早基础。仅有“从左到右执行”并不自动拥有回滚。

## 源码阅读

实际读取2026-10-13的[facebook/folly main Foreach.h](https://github.com/facebook/folly/blob/main/folly/container/Foreach.h)、[Foreach-inl.h](https://github.com/facebook/folly/blob/main/folly/container/Foreach-inl.h)，Apache-2.0；具体`for_each→for_each_impl(TupleTag)→for_each_tuple_impl(index_sequence)→invoke_returning_loop_control`。当前实现使用int[]初始化列表的参数包展开与loop_continue短路，并不是C++17 fold；本课将其“按序展开/控制是否继续”的机制转换为**受启发的独立C++17实现**，不冒称上游使用逗号折叠。

读取[`[expr.prim.fold]`](https://eel.is/c++draft/expr.prim.fold)折叠形式与空包规则，当前草案包含后续标准内容，本例严格用C++17可编译子集；不借用C++20 concepts。代码没有Folly依赖。精确main commit未固定，日期和文件SHA留在[source.json](source.json)。Google组合查询可达、知乎未找到采用的匹配原作者案例，不能以检索摘要替代已读实现。

## 机制与知识图谱

`ordered(F&&...f)`使用`(static_cast<void>(f()),...)`，返回值被转成void，避免类类型重载逗号改变预期。每个回调调用按包顺序发生。空包的逗号折叠为void；`validate`以true为&&折叠初值，空包成功，失败回调后短路。std::forward保留调用对象值类别，但并不延长对象寿命。

| 层次 | 本例证据 | 不能推导 |
| --- | --- | --- |
| 参数构造 | 回调以lambda传入 | 调用前的参数表达式求值顺序不由函数体fold控制 |
| 有序调用 | 日志1/2/3 | 已发生外部副作用会自动回滚 |
| 短路校验 | 第2步false，第3步没调用 | 校验成功后资源永远不变化 |
| 事务提交 | candidate复制→按序写→swap | 网络/文件等任意外部操作也可回滚 |

`transaction`先复制live，操作只触及候选vector，全部成功才swap。失败时候选自动析构，live不变；此强保证依赖所有回调遵守“只修改传入候选”的合同，示例不扩张到任意用户回调。基础`ordered`安全反例在第二步抛异常，第一步日志仍留下，证明顺序与原子提交是两个机制。

## 运行与观察

```sh
# 项目根，现成阅读示例
sh systems_practice/cpp17/2026-10-13/run.sh release
sh systems_practice/cpp17/2026-10-13/run.sh sanitize
```

[src/main.cpp](src/main.cpp)检查顺序123、空包、&&短路2次、1000次失败回滚、成功提交7/8/9，以及未事务化异常前缀1。没有执行未定义行为，也没有写一个“不保证顺序”但强行期待某个顺序的脆弱测试。vector拥有存储，异常路径由RAII回收；本例不涉线程，不加无意义TSan。编译使用C++17、Wall/Wextra/Werror；无性能结论。

## 故障链路与面试追问

故障一：注册顺序仍不对→副作用发生在构造传入参数时，而非回调体→分别打印构造/调用日志→把顺序敏感操作推迟到lambda调用，不能靠折叠控制函数调用前已经发生的事情。

故障二：第二步抛异常后live部分更新→原实现直接修改live或回调偷改外部对象→注入失败并逐项检查live→先候选后提交，代价是复制/峰值存储，实时热路径可改预分配状态但必须重验异常合同。

故障三：验证false后仍出现后续动作→把&&写成按位&或提前执行所有参数→检查回调计数→用布尔&&短路并延迟求值，空包identity也要明示。

验收清单：标准版本17；空包正常；副作用位于回调体；异常只保留允许的日志；提交前live不变；回调不捕获悬空引用；候选复制失败时也保留旧配置。目标Linux编译器/STL/ABI仍须另验。

追问：①fold的结合方向和求值顺序有何区别？②为什么static_cast<void>？③&&折叠的空包初值如何选择？④传参阶段的副作用能被函数体排序吗？⑤哪些副作用无法被候选vector隔离？⑥forward后的lambda引用何时可能悬空？

## 验证结果与边界

Mac Release/ASan/UBSan通过，[最终日志](results/verified-release.txt)、[验证](verification.json)。未测CPU性能；GPU/NPU/端到端不适用，无Linux/板端运行。源码阅读、宿主执行、板端验证各自记录，库实现不是语言规范本身。

## 下一课

第15课：CTAD与deduction guide，继续研究接口如何在编译期确定类型及其边界。
