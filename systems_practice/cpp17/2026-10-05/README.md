# 2026-10-05 C++17第07课：if初始化与配置查找作用域

## 本课目标与前置

推理服务按camera名称读取不可变batch配置：存在返回拥有寿命的快照，不存在返回空，非法更新保留原配置。承接结构化绑定/引用，本课连接C++17新增if初始化与既有map查找，透明比较器来自C++14，shared_ptr与mutex来自C++11。

## 源码阅读

2026-10-05实际读取[LLVM libc++ __tree](https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/libcxx/include/__tree)，tag llvmorg-18.1.8，函数`find`、`__lower_bound`、`__erase_unique`；[许可证](https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/libcxx/LICENSE.TXT)为Apache-2.0 WITH LLVM-exception。`find→lower_bound→比较确认等价→迭代器/end`，从树节点遍历到查找失败行为。早先release/18.x raw返回压缩页面，改读固定tag真实函数体，失败/改用记录见[source.json](source.json)。

原场景是关联容器查找；独立Registry保留“查找不插入、比较器等价”的机制，不复制红黑树，不声称libc++实现决定if语言语义。本机链接的是Apple标准库，并非构建该LLVM tag，版本阅读和宿主运行必须分开。

## 机制与知识图谱

`string_view查询 → std::less<>透明比较 → map::find → if(init;condition) → shared_ptr拷贝 → 解锁 → 消费快照`。

初始化的it在then/else整个选择语句内有效；作用域收紧有助减少误用，但不会延长所指节点寿命。锁保护查找与shared_ptr复制；返回后持有不可变Config所有权，即使注册表更新也不悬空。string_view只借用本次查找字符，不存到表内。初始化语句不是事务或线程安全机制，真正安全来自mutex与拥有型返回值。

非法batch在加锁写入前拒绝；候选shared_ptr先构造成功再替换，原配置保持。`operator[]`的缺失路径会插入默认对象，不应用于只读查找。`std::less<>`要求有效严格弱序，不能改成不稳定比较来“修复”命中问题。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-05/run.sh release
sh systems_practice/cpp17/2026-10-05/run.sh sanitize
```

[src/main.cpp](src/main.cpp)提供现成代码。1000次配置替换后旧快照仍为batch2，验证保留寿命；空表、空串、前缀、额外字符均不命中且不插入；非法batch拒绝后指针不变。安全`operator[]`反例展示意外插入，不执行悬空解引用或数据竞争来证明错误。

## 故障链路与面试追问

1. 未知camera越来越多→查询代码用operator[]→观察每次miss前后size→改find，代价是显式处理空结果；回归大量缺失查询，不能只测存在键。
2. 热更新后偶发坏配置→返回裸指针/迭代器，锁释放后被替换→检查返回对象所有权→返回不可变shared_ptr快照；代价为引用计数与旧版本暂存，需有内存上界和最长读者寿命。

追问：if初始化变量在else可见吗？限制作用域为何不能解决悬空？map::find为什么不插入？less<>如何支持string_view？shared_ptr能保证所指对象的线程安全吗？为何先构造候选再加锁？

## 验证结果与边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)通过。本例没有并发压力或性能测量，mutex协议是代码推理，不能称生产热更新验收；Linux/板端未验。[verification.json](verification.json)。

## 下一课

08 variant与visit：将多种业务结果表达为显式状态，沿[独立进度](../progress.json)推进。
