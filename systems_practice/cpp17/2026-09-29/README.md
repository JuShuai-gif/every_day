# 2026-09-29 C++17 第01课：可选配置与失败回滚

## 本课目标与前置

边缘视觉服务启动时可能还没有合法配置，运行中收到新模型名、batch和阈值。如何同时表达“尚未就绪”和“更新失败仍沿用旧配置”？本课把它缩成一个单线程配置槽：`model`非空、batch在[1,16]、有限阈值在[0,1]，不加载模型或执行推理。

主机制是C++17新增的`std::optional<T>`；耦合机制是早已有之的异常安全和作用域资源管理。只需会struct、构造函数和try/catch。`std::move`、noexcept与type traits先解释本例所需结论，后续课再深入。完整代码已提供，阅读和运行约10–15分钟，不新增必做编码任务或自测。

## 源码阅读

实际读取[LLVM仓库](https://github.com/llvm/llvm-project)的[libcxx/include/optional](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/optional)，分支`release/18.x`，读取日期2026-09-29；具体读了`__optional_destruct_base::reset`、`__optional_storage_base::__construct`、`optional::emplace`和`optional::swap`。原场景是标准库通用可选值存储；顺序是emplace→reset→construct，swap则按两边有值状态分派。另核对main分拆后的`__optional/optional.h`，不把它当成本机标准库版本。tag直达请求失败，精确commit未固定，URL是分支链接而非永久提交链接。

保留可选状态和“先构造再提交”的接口约束，省略标准库的union、SFINAE、平凡类型特化与ABI实现。示例是**独立业务实现，直接使用本机std::optional**，不复制或改编LLVM代码。许可证为Apache-2.0 WITH LLVM-exception，头部声明已读；[来源及失败记录](source.json)。

## 机制与知识图谱

`optional<Config>`拥有零个或一个Config对象。空状态不是“字段全部为0”，也不是一根必须手动释放的指针；有值时Config作为optional的子对象存在。Config中的string仍可能自行分配堆内存，所以不能把optional直接说成“所有内容都无堆分配”。`has_value()`只回答对象是否存在，不负责验证业务字段；本例由构造函数检查字段。访问前先判空，或用会报告空访问的`value()`；不演示对空对象解引用这种未定义行为。

直接`active.emplace(...)`的危险来自顺序：原配置先销毁，新配置的构造如果抛异常，active会变空。容器自身仍有效，但业务连续服务的要求已经被破坏。安全路径先在局部candidate中构造新配置；构造失败时active未被触碰；成功后通过不抛异常的swap提交，candidate接管旧值并在作用域结束时析构。这个“失败则旧状态不变”的承诺叫强异常保证。

这里的前提不是“所有swap都安全”，而是Config的移动构造与交换不会抛异常。代码用编译期断言守住此条件，未来成员类型变更若破坏条件会编译失败。string用默认分配器，成员自动管理资源，无裸new/delete。代码只在单线程访问active；C++异常安全不等于跨线程原子发布，其他线程并发读写仍需同步，也不能把借出的Config引用跨更新保存。

```text
未配置(nullopt) → candidate构造与校验 → noexcept swap → 已配置
                       ↓失败                         ↓下次更新
                active完全不变              旧值由candidate析构
optional状态 → 对象寿命 → 异常路径 → 业务连续性
```

## 运行与观察

从仓库根目录运行，只有已有C++编译器和标准库依赖：

```sh
sh systems_practice/cpp17/2026-09-29/run.sh release
sh systems_practice/cpp17/2026-09-29/run.sh sanitize
```

[main.cpp](src/main.cpp)先展示错误使用emplace后的空状态，再验证候选提交路径。实际检查空访问异常、首次配置失败、batch和阈值的两端、空名字/非法batch/越界阈值/NaN/Inf共7次失败更新、成功更新和重复reset。断言用主动抛错实现，Release不会因NDEBUG关闭检查。构建开启C++17和严格警告；二进制只放忽略的`.tmp/`。

## 故障链路与面试追问

| 触发 | 现象 | 根因与诊断 | 修复/代价 |
| --- | --- | --- | --- |
| 对活动槽直接emplace非法配置 | 更新失败后服务变成未就绪 | 本课对照组复现，检查has_value | 候选构造后提交；短暂同时持有两份配置 |
| 忽略NaN检查，只检查小于0/大于1 | NaN绕过区间判定 | 构造NaN边界输入 | 显式isfinite，拒绝不合法状态 |
| 新增会抛异常的成员交换 | 原先的提交保证失效 | 本例static_assert阻止构建 | 重审提交协议；不能随意写noexcept掩盖问题 |

面试追问：

1. optional空状态与Config字段为零有何差别？
2. optional有值是否保证业务字段合法？
3. emplace失败为什么可能丢失旧值？
4. 候选对象和旧配置分别在什么时候析构？
5. 本例强异常保证依赖哪些可检查条件？
6. 为什么这个接口还不能安全地供多个线程同时读写？

## 验证结果与边界

真实结果见[Release](results/release.txt)、[ASan/UBSan](results/sanitize.txt)、[环境](results/environment.txt)与[验证状态](verification.json)。只验证宿主CPU的标准库语义和独立业务示例，没有编译LLVM工程。没有计时，未宣称配置交换、GPU、NPU或端到端性能提升；无目标板验收。内存分配失败没有注入，结论依赖候选构造在提交前完成的控制流，不声称覆盖所有异常。性能若后续测量，必须单独量化复制成本、峰值存储和同步开销。

## 下一课

[02 对象寿命与RAII](../../docs/cpp17/README.md)：把本课“离开作用域自动清理”展开成构造、析构、成员顺序和Rule of Zero。进度见[独立索引](../index.md)。
