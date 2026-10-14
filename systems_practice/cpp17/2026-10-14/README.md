# 2026-10-14 C++17第15课：CTAD与deduction guide的所有权边界

## 本课目标与前置

承接参数包，今天给推理批次容器省略模板参数，同时避免把迭代器当成元素存入任务队列。CTAD和deduction guide是C++17新增；vector所有权、构造重载和字符串转换是既有机制。课堂提供现成示例，不增加作业。

## 源码阅读

实际读取[LLVM libc++ vector.h](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/__vector/vector.h)，tag llvmorg-20.1.8，2026-10-14；`vector(_InputIterator,_InputIterator)`构造与C++17 guide，`__iter_value_type`、input iterator/allocator SFINAE约束。LICENSE.TXT为Apache-2.0 with LLVM Exceptions。原场景是标准容器构造，保留从iterator value_type推导元素类型的机制，自写Batch/Packet为独立实现；未复制libc++内部实现或宣称编译使用该tag。实际编译链接Apple clang21随附libc++。[来源](source.json)。

## 机制与知识图谱

`调用实参 → 候选guide/隐式guide → 类模板实参 → 构造重载 → 资源寿命`。

`Batch(It,It)->Batch<iterator_traits<It>::value_type>`只选择T，不执行复制；实际Batch构造函数把元素复制到vector。修改原array不会修改队列内Batch。guide不能自动验证范围有效性，示例仅接受已知同容器有效范围，不用无关指针差来“检查”。空批次由运行期异常拒绝。

`std::vector range(begin,end)`得vector<int>且3元素；`std::vector braces{begin,end}`优先initializer_list，得vector<int*>且2元素。花括号并非范围构造语法，end指针不能解引用。本例只检查类型/长度，无UB。Packet的字符数组guide得Packet<string>，拥有字符串，而不是把短命char缓冲区当持久标签；这只是明确的业务策略，不是所有CTAD都会自动拥有数据。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-14/run.sh
SANITIZE=1 sh systems_practice/cpp17/2026-10-14/run.sh
# 受控失败：整数不是迭代器，应编译失败
clang++ -std=c++17 -DNEGATIVE -fsyntax-only systems_practice/cpp17/2026-10-14/src/main.cpp
```

[src/main.cpp](src/main.cpp)用static_assert核对三种推导类型，独立值检查原array改变后Batch不变；空范围抛invalid_argument。RAII vector/string管理资源。guide不存在或SFINAE排除会在编译期失败，不是运行时异常。

## 故障链路与面试追问

①初始化改圆括号为花括号后batch数量变2→查看decltype和重载集合→发现initializer_list存了两个指针→恢复范围构造或显式类型→回归元素值/长度/所有权。②标签在异步任务里失效→检查推导T是否指针/view→用拥有型string或显式所有者→回归来源缓冲区销毁后的安全访问；此例通过类型策略预防，没有执行悬空访问。

迁移需检查C++17工具链、目标标准库guide、所有权和有效迭代器范围，不以宿主编译证明板端ABI。追问：①guide会生成构造函数吗？②为何花括号可能得到vector<int*>？③guide能延长被借用对象寿命吗？④空范围为什么是运行时失败？⑤iterator_traits约束解决哪些误用？⑥什么时候显式模板参数更清楚？

## 验证结果与边界

[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[预期编译失败](results/negative.txt)与[状态](verification.json)。不测性能，不把编译期语法便利写成运行加速；Linux/板端未验。

## 下一课

第16课invoke/apply，把今天推导的任务载荷传给可调用对象。
