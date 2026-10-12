# 2026-10-12 C++17 第13课：类型分支与被丢弃语句

## 本课目标与前置

边缘请求编码器同时接收整数字段和字符串字段：整数没有`.size()`，字符串不能转成无符号整数。怎样在一个模板中写两套类型专属操作，同时保留运行时长度检查？前置是模板实例化、RAII和vector。本课`if constexpr`、`is_same_v`是C++17；异常安全和整型转换规则不是17新特性。

## 源码阅读

实际读[LLVM libc++ llvmorg-20.1.0](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.0/libcxx/include/__memory/uninitialized_algorithms.h)，`__allocator_destroy_multidimensional`、`__allocator_construct_at_multidimensional`及其异常guard。文件该区域处于`_LIBCPP_STD_VER >= 17`内。原场景是数组/非数组对象的allocator构造与失败回滚：编译期分支让数组元素递归与单对象构造分开；递归构造失败后逆序销毁已构造部分。许可证Apache-2.0 WITH LLVM-exception；LICENSE已读。

本课是受该“类型分派+失败回滚”机制启发的独立协议编码器，没有复制内部libc++函数、没有依赖其私有接口。省略allocator重绑定与多维数组，用候选字节数组把运行时检查和提交分开。

同时读`allocator_traits.h`的`allocate_at_least`，发现其中`requires`分支是C++23保护区；明确排除，不把它照搬成17代码。标准依据是[N4659 stmt.if](https://timsong-cpp.github.io/cppwp/n4659/stmt.if)的constexpr-if规则。Google入口失败；知乎结果出现混用C++20 construct_at/requires的示例，未作为技术依据。完整来源见[source.json](source.json)。

## 机制与知识图谱

```text
T实例化 → if constexpr(类型特征)
  ├─ 整数：make_unsigned → 小端移位 → 候选字节
  ├─ string：检查255上限 → 长度+内容 → 候选字节
  └─ 不支持：依赖于T的static_assert
               ↓
         校验完成才insert到输出
```

普通`if`即使条件可常量折叠，模板实例仍必须满足两边的语义要求；`if constexpr`在条件不再依赖时不实例化被丢弃语句。它不等于预处理删文本，也不能隐藏所有非依赖语法/名字错误。`unsupported<T>`故意让失败断言依赖类型，避免错误发生在所有实例共享的模板定义处。

`append(-1 int16)`先按标准转成对应无符号值，再写小端字节，避免对负数右移的实现差异。本例只用于8位字节的目标环境；不能把任意对象`memcpy`当稳定跨ABI协议。字符串内容长度仍是运行时属性，constexpr分支不能代替长度验证。

候选缓冲区使过长字符串在修改输出之前失败；`vector<uint8_t>`最终insert没有元素构造异常，分配失败由vector保证。额外分配是明确代价，小消息吞吐未测，不宣称该方案最快；工业实现可预留容量或先验证后写有界buffer，但必须保持事务合同。

## 运行与观察

现成[src/main.cpp](src/main.cpp)包含独立字节oracle、空字符串、255边界、256拒绝且输出不变。负例受宏控制，只做预期编译失败：

```sh
sh systems_practice/cpp17/2026-10-12/run.sh
cd systems_practice/cpp17/2026-10-12
# 两条命令都应编译失败；这正是预期验收
clang++ -std=c++17 -DFAIL_ORDINARY_IF -fsyntax-only src/main.cpp
clang++ -std=c++17 -DFAIL_UNSUPPORTED -fsyntax-only src/main.cpp
```

第一条报告int没有size；第二条报告unsupported wire field type。它们不是构建环境坏了，不能删除负例或悄悄放宽模板支持类型。附加材料无需用户再做编码任务。

## 故障链路与面试追问

1. 某个新类型实例化突然编译失败→把普通if误当编译期语义选择→看诊断究竟来自未选运行分支还是必选分支→使用依赖类型的constexpr分支，负例与正例共同回归。
2. 长字符串拒绝后输出已半写→把类型合法当内容合法，先写长度再检查→比较调用前后字节快照→先构造候选再提交；代价是额外内存，不能删回滚检查换速度。
3. 跨设备解析错误→把主机字节序/对象布局当协议→手算0x1234应为34 12→显式编码整数，避免sizeof(struct)跨ABI传输。

追问：constexpr-if与编译器常量折叠差在哪里？被丢弃语句是否不解析？为什么断言依赖T？为何长度仍需运行时判断？候选构造的异常安全保证是什么？if constexpr会让任何算法更快吗？

## 验证结果与边界

Apple Clang21严格C++17，Release/ASan/UBSan通过；8字节oracle一致、空/255通过、256失败回滚。两个负例实际编译失败，日志见[results](results/expected-fail_ordinary_if.txt)和[verification.json](verification.json)。没有测性能、没有验证Linux ABI/板端协议集成，也没有使用C++20/23接口。内存安全检查不证明协议版本兼容；上线必须添加版本、长度和截断接收验收。

## 下一课

第14课参数包与折叠表达式：扩展为多个字段时，怎样保持求值顺序和失败边界；今天不提前推进。
