# 每日独立 C++17 学习路线

这是单独的每日栏目，从2026-09-29开始补齐，随既有北京时间08:30任务执行。每天一节、约10–15分钟阅读和运行，提供完整示例。主方向仍保留C++17并发/C++工程知识；主课只有一个20–30分钟必做任务与一个无答案自测。本栏目不增加强制作业，主课恰好涉及同一机制时可交叉引用，但必须留下独立课号、进度和本课的新收获。

C++17是统一编译基线，不代表每个概念都诞生于C++17。基础、17新增接口与实现细节逐课区分；不把C++20的span/jthread或C++23的expected/optional单子操作混进17示例。首课从已有业务背景切入，随后补齐寿命、所有权和移动前置，再逐步进入库、模板与并发。

每次先读[课程表](../../cpp17/curriculum.json)、[历史索引](../../cpp17/index.md)、[进度](../../cpp17/progress.json)和[模板](LESSON_TEMPLATE.md)。同一北京时间自然日只推进一次；同日纠错/补充保留历史结果。缺依赖/平台仅记对应待验，不宣称全部通过；先补最早未完整交付课，不能悄悄跳过。28节完成后转入实际项目专题，不自动回到第一课。

每课实际阅读相关成熟开源代码（LLVM/libc++、Abseil、Folly、gRPC等），核对具体符号和版本；推荐仓库是候选，不代表已经读过。默认标准库小示例，不安装依赖。至少验证一个边界与一条失败路径，按主题选择ASan/UBSan/TSan；完整保留来源、验证和原始日志。所有CUDA执行仍固定Thor SM110。

| 课号 | 主题 | 耦合机制 | 标准版本边界 |
| --- | --- | --- | --- |
| 01 | 可选配置与失败回滚 | std::optional / 候选构造后提交 | 17新增optional；异常安全是既有基础 |
| 02 | 对象寿命与RAII | 作用域 / Rule of Zero | 既有基础 |
| 03 | 唯一所有权与移动 | unique_ptr / move后状态 | C++11基础 |
| 04 | 移动成本与容器扩容 | noexcept / vector重分配 | C++11基础 |
| 05 | 字符串视图与借用 | string_view / 悬空边界 | 17新增string_view |
| 06 | 结构化绑定与引用 | 拷贝绑定 / 引用绑定 | 17新增结构化绑定 |
| 07 | 初始化语句与查找作用域 | if初始化 / map查找 | 17新增if初始化 |
| 08 | 联合结果与状态机 | variant / visit | 17新增variant与visit |
| 09 | 类型擦除与动态值 | any / any_cast失败 | 17新增any |
| 10 | 数值解析与输入边界 | from_chars / 部分解析和溢出 | 17新增from_chars；核实库实现支持 |
| 11 | 哈希表插入成本 | try_emplace / insert_or_assign | 17新增两个插入接口 |
| 12 | 节点句柄与键变更 | extract / insert所有权 | 17新增node handle |
| 13 | 模板分支 | if constexpr / 被丢弃语句 | 17新增if constexpr |
| 14 | 参数包与求值顺序 | fold expression / 逗号折叠 | 17新增折叠表达式 |
| 15 | 类型推导边界 | CTAD / deduction guide | 17新增类模板实参推导 |
| 16 | 可调用对象组合 | invoke / apply | 17新增invoke与apply |
| 17 | 静态配置与链接 | inline变量 / ODR | 17新增inline变量 |
| 18 | 返回值与对象构造 | prvalue直接构造 / 可选NRVO | 17保证特定copy elision；NRVO不保证 |
| 19 | 对齐与对象存储 | alignas / over-aligned分配 | alignas是11基础；17扩展对齐分配 |
| 20 | 多态内存资源 | pmr / resource寿命 | 17新增pmr |
| 21 | 文件系统与错误 | filesystem / error_code与TOCTOU | 17新增filesystem |
| 22 | 互斥与多锁管理 | scoped_lock / 死锁顺序 | 17新增scoped_lock；mutex是11基础 |
| 23 | 读多写少的共享状态 | shared_mutex / 读者寿命 | 17新增shared_mutex；共享锁基础来自14 |
| 24 | 条件变量与退出协议 | 谓词等待 / 关闭排空 | C++11基础，结合17接口工程化 |
| 25 | 异步结果与异常传播 | future / promise所有权 | C++11基础 |
| 26 | 原子与发布可见性 | release-acquire / 数据竞争 | C++11内存模型基础 |
| 27 | 构建与库边界 | ABI / sanitizers与编译特性 | C++17工程实践，平台相关 |
| 28 | 综合配置与推理服务 | 生命周期 / 有界并发和验收 | 综合复用，不新增语法清单 |

[第01课](../../cpp17/2026-09-29/README.md) · [总入口](../../README.md)
