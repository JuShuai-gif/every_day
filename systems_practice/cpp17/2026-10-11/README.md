# 2026-10-11 C++17第12课：节点句柄、改键与冲突回滚

## 本课目标与前置

承接11插入成本；推理资源注册表要把设备槽位ID从1改成3，槽位拥有不可复制/不可移动资源。`extract`与`insert(node)`是C++17新增，RAII/移动语义是已有基础。目标是改键时不搬动mapped对象，冲突时资源仍有主人，不额外布置编码题。

## 源码阅读

实际读取[LLVM/libc++ map](https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/libcxx/include/map)与[__tree](https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/libcxx/include/__tree)，tag llvmorg-18.1.8，2026-10-11，Apache-2.0 WITH LLVM-exception。

`map::extract`调用 `__node_handle_extract`：find失败返回空句柄，成功则摘掉树节点并把节点指针/allocator放入句柄。`map::insert(node)`调用 `__node_handle_insert_unique`：空句柄不插入，重复键把所有权放到返回值node，成功连接原节点后释放句柄内部所有权。原场景是标准库有序容器节点操作；本课是受机制启发的独立业务例子，不拷贝树实现、不证明Apple当前libc++字节码与18.1.8完全相同。来源及精确符号记录见[source.json](source.json)。

## 机制与知识图谱

`map owns node → extract owns node → mutate key → insert结果`：成功时map重新拥有；重复键时**返回值**拥有失败节点。普通非hint insert不会把失败所有权自动塞回原map，丢弃返回值会销毁该资源。对非空句柄调用key/mapped才合法；原元素iterator在extract后失效，不能继续解引用；本例只在重新插回后检查mapped地址。

[src/main.cpp](src/main.cpp)定义Slot，显式删除copy/move，使用try_emplace原地构造。`rename_slot`用整数key保存旧值，插入冲突取 `result.node` 改回原key，再插回。此回滚合同限定单线程同map、无抛出整数比较、无抛出key赋值；不能无条件推广到自定义会抛异常的Comparator或String重分配。跨容器必须allocator相容，本例默认allocator相等；不构造不相等allocator的UB反例。

| 路径 | 所有者 | 原槽位资源 |
| --- | --- | --- |
| extract缺失key | 空句柄 | 原表不变 |
| 改键成功 | 新key的map节点 | 地址不变 |
| 改键冲突 | insert_return_type.node | 明确回滚旧key |
| 句柄未插回即离开作用域 | 句柄析构释放 | 不应再当作表中资源 |

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-11/run.sh release
sh systems_practice/cpp17/2026-10-11/run.sh sanitize
```

1000次重复键冲突、改键、恢复，检查内容、资源活数和地址；缺失key、空node、默认allocator跨map转移；作用域结束alive=0。编译严格C++17。没有手写new/delete，不靠执行悬空指针验证规则。两脚本仅用已有c++，不安装库。

## 故障链路与面试追问

1. rename冲突后资源消失→忽略insert返回的node→打印inserted与node.empty并核对alive→显式回滚或返还句柄给调用者；不能仅检查原局部node，因为它已移动。
2. 换容器后偶发崩溃→allocator不等或使用extract前iterator→检查allocator等价和iterator来源→相同allocator节点转移，否则构造新元素/显式移动资源；代价是可能分配和改变地址。
3. 回滚本身抛异常→自定义key/Comparator不满足本例合同→故障注入比较器并确认句柄仍由谁拥有→设计返回带节点的错误对象，不能声称所有节点改键都有强异常保证。

采用条件：单线程或外部同一把锁保护完整extract/insert事务；allocator相容；冲突资源明确返还；跨DLL ABI/allocator边界另验；资源析构不得抛异常。没有测量分配次数或时延，因此“mapped不移动”不是性能加速结论。

追问：1. 为什么map中的key不可直接改？2. extract后谁析构mapped？3. 普通insert与hint insert失败所有权是否相同？4. 空句柄能否调用mapped？5. allocator不等为什么不是自动搬运？6. 会抛比较器如何改变回滚设计？

## 验证结果与边界

Release/ASan/UBSan通过，见[release.txt](results/release.txt)、[sanitize.txt](results/sanitize.txt)和[verification.json](verification.json)。真实验证mapped不可移动仍能转移和冲突回滚；未测性能、跨库ABI、Linux/目标板。没有把源码阅读的实现细节写成所有标准库的内部保证。

## 下一课

13：if constexpr与被丢弃语句，为不同资源类型写受类型约束的适配逻辑。
