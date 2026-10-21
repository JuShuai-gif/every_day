# 每日 C++17 索引

独立随每日北京时间08:30任务运行，同日不重复推进，不改变12个主方向。路线及完整28课见[课程说明](../docs/cpp17/README.md)，状态见[progress.json](progress.json)。此前主轮换中的C++课程保留原位，不倒填为本栏目的历史交付。

下一节：**19**（按progress.json继续）。

2026-10-09：[第11课：哈希表插入成本](2026-10-09/README.md)。Mac C++17 通过 `try_emplace`、重复键与 miss 查找边界；目标板未验证。

| 日期 | 课号 | 两个机制 | 实际验证 | 阅读入口 |
| --- | --- | --- | --- | --- |
| 2026-09-29 | 01 | optional状态 / 失败回滚 | Mac C++17 Release、ASan/UBSan通过；7类非法更新保留旧值，无性能结论 | [配置热更新](2026-09-29/README.md) |
| 2026-09-30 | 02 | 部分构造回滚 / Rule of Zero | Mac Release/ASan/UBSan：1000构造失败+1000移动和重复reset，2000资源均回收；无性能结论 | [对象寿命与RAII](2026-09-30/README.md) |
| 2026-10-01 | 03 | unique_ptr唯一所有权 / 移动后状态 | Release/ASan/UBSan 1000拒绝/异常/移动/reset循环，alive=0 | [所有权](2026-10-01/README.md) |
| 2026-10-03 | 05 | string_view借用 / 不可变所有者与offset重建 | Mac Release/ASan/UBSan，1000队列元素与失败/边界通过；无性能结论 | [借用寿命](2026-10-03/README.md) |

2026-10-02正式交付：[04 noexcept与vector扩容](2026-10-02/session-02/README.md)。Mac Release/ASan/UBSan通过；源码已读，Linux/板端未验。[并发旧游标补充](2026-10-02/README.md)保留但不计新课。

2026-10-04正式交付：[06 结构化绑定与引用](2026-10-04/README.md)。Release/ASan/UBSan通过；2次拷贝 vs 0次新增拷贝、异常/空表/重复键；板端未验。

2026-10-05正式交付：[07 if初始化＋map查找；1000替换/旧快照寿命、缺失不插入与失败回滚通过；LLVM固定tag源码已读，未测性能。](2026-10-05/README.md) Release/ASan/UBSan通过。

2026-10-06：[CPP08 variant与异常状态机](2026-10-06/README.md)。1000候选提交/失败回滚、bad_get/valueless/visit拒绝与恢复，Release/ASan/UBSan通过。

2026-10-07：[CPP09 any类型擦除与cast失败：1000次赋值回滚/emplace清空，Release/ASan/UBSan通过，alive=0；动态库/板端未验。](2026-10-07/README.md)

2026-10-08：[第10课：from_chars与完整输入事务](2026-10-08/README.md)。Mac C++17 Release/ASan/UBSan通过；实现已读，目标板未验证。完整解析、11类拒绝与溢出保留旧值通过；无性能结论。

2026-10-11：[第12课：节点句柄与冲突回滚](2026-10-11/README.md)。1000冲突/改键、缺失/空句柄/跨map转移，Release/ASan/UBSan通过；mapped copy/move删除，alive=0；板端未验。

2026-10-12：[第13课：if constexpr与被丢弃语句；独立字节oracle/空与255边界/256回滚，Release/ASan/UBSan通过，两个预期编译失败核验；板端未验。](2026-10-12/README.md)

2026-10-13:[第14课：参数包与有序折叠。空包/短路/顺序、1000异常回滚与前缀提交反例，Release/ASan/UBSan通过；Folly初始化列表机制已读，独立C++17重写，板端未验](2026-10-13/README.md)。

2026-10-14：[CPP15：CTAD与deduction guide](2026-10-14/README.md)。范围拥有、花括号指针反例、空范围与预期编译失败，Release/ASan/UBSan通过；libc++ llvmorg-20.1.8已读，板端未验。

2026-10-15：[CPP1716：invoke/apply与参数寿命](2026-10-15/README.md)。成员调用/成员数据引用、move-only与空tuple、两次异常回滚通过Release/ASan/UBSan；板端未验。下一课17。

2026-10-17：[第17课](2026-10-17/README.md)。inline变量与ODR：跨TU身份、边界及预期重复符号链接失败通过；Release/ASan/UBSan通过，板端未验。下一节18。

2026-10-18：[第18课](2026-10-18/README.md)。prvalue直接构造/可选NRVO；不可移动Frame、optional、边界/异常及两种预期编译失败通过；Release/ASan/UBSan/noelide通过，NRVO移动0→1，无性能结论。下一节19。

2026-10-19：[第19课](2026-10-19/README.md)。alignas/扩展对齐分配；vector0/1/3/257及扩容、make_unique异常、std::align空间不足，Release+ASan/UBSan通过，alive0；未测性能/板端。下一节20。

2026-10-21：[第20课：PMR对象析构与arena整体释放](2026-10-21/README.md)。clear析构与4032B保留、release归还、有限arena失败回滚；Release/ASan/UBSan通过，无性能数字。 下一节21。
