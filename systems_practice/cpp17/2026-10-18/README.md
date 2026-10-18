# 2026-10-18 C++17 第18课：返回值直接构造与可选NRVO

## 本课目标与前置

承接inline变量与ODR，本课看推理帧工厂能否按值返回不可移动资源。输入帧长0、1、4096合法，负数和4097拒绝。C++17保证特定同类型prvalue直接构造；命名局部变量的NRVO仍可选。RAII/移动和异常安全来自更早标准，不把编译器优化选项当语言保证。

## 源码阅读

实际读[LLVM/libc++](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/optional) `llvmorg-20.1.8`，`make_optional<T>(Args&&...)`返回`optional<T>(in_place,...)`，调用链为工厂→optional原位构造→T构造；Apache-2.0 WITH LLVM-exception，2026-10-18。保留原位构造/按值返回，省略optional比较、赋值和SFINAE实现。独立例子调用宿主libc++，不是把上游整库编译成当前程序；源码tag与本机SDK版本分别记录。

另读[class.copy.elision](https://eel.is/c++draft/class.copy.elision)的NRVO规则；这是当前草案，只取与17一致的命名返回规则，不引入协程或新版本隐式移动。Google检索取得页面；知乎NRVO答案落到验证页，正文未读。[source.json](source.json)保存路径、哈希与范围。

## 机制与知识图谱

`direct(n) → Frame(n) → 调用者对象`没有中间Frame需要搬运，因此Frame copy/move都删除仍合法；`factory(n) → make_optional<Frame>(n)`直接在optional存储构造Frame。`named(n)`返回有名字的Movable，允许NRVO，但必须有未采用NRVO时可用的构造路径。`forced(n)`给局部对象加`std::move`使其成为xvalue，编译器实际警告阻碍NRVO，产生一次移动。

对象寿命表：直接返回/optional成功→作用域结束析构；Frame构造抛异常→Frame析构不执行、成员在构造失败时自动回收；本例先校验长度再分配vector；命名返回无NRVO→移动后源对象和目的对象分别正常结束。`alive`仅计成功构造，失败不能先加计数。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-18/run.sh release
sh systems_practice/cpp17/2026-10-18/run.sh noelide
sh systems_practice/cpp17/2026-10-18/run.sh sanitize
# 以下两条必须失败，验证不能依赖NRVO救活不可移动类型：
clang++ -std=c++17 -DNEGATIVE_NRVO -fsyntax-only systems_practice/cpp17/2026-10-18/src/main.cpp
clang++ -std=c++17 -DNEGATIVE_MOVE -fsyntax-only systems_practice/cpp17/2026-10-18/src/main.cpp
```

现成附加例子，无额外编码作业。`Frame`最大4096是教学输入合同；实际SDK句柄可用同样的工厂，但析构需调用并检查SDK释放接口。

## 故障链路与面试追问

- 不可移动Frame返回命名局部→构建失败→误以为NRVO总存在→查deleted constructor诊断→返回同类型prvalue或提供正确移动；不能只调整优化等级。
- 代码评审“优化”成`return std::move(value)`→移动次数增加→表达式变为xvalue→开启pessimizing-move告警并比较noelide日志→移除多余move；不是禁止所有返回移动，例如返回参数有不同规则。
- 迁移验收：同C++17、同标准库ABI、异常设置，检查无移动对象/空值/失败；跨动态库对象分配释放另验。

追问：C++17直接构造是否需要移动构造存在？NRVO为何仍要求有效返回路径？删除析构函数会怎样？optional原位构造与先建临时对象有什么区别？禁用elision选项为何没破坏direct？构造失败时谁释放vector？

## 验证结果与边界

Apple clang21 / macOS arm64：Release `nrvo_moves=0`，`-fno-elide-constructors`为1；两种模式强制move增量都为1。0/1/4096、2拒绝、alive=0通过；ASan/UBSan通过。两个负向编译均报告deleted constructor，原始输出在[results/final-negative.txt](results/final-negative.txt)。有意保留警告作为教学证据。未测速度，Linux/板端/跨库ABI未验证。见[verification.json](verification.json)。

## 下一课

第19课：alignas与C++17扩展对齐分配，连接返回对象与真实存储合同。
