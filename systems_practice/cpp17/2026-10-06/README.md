# 2026-10-06 C++17 第08课：variant结果与异常状态机

## 本课目标与前置

推理请求只有Idle、Ready或Failed之一，使用C++17新增variant/visit表达封闭状态集合。承接if初始化的作用域，今天把状态与资源一起保存，重点是类型分派和失败后状态是否仍有效。unique_ptr与异常安全是此前C++基础，variant不自动提供业务事务。

## 源码阅读

2026-10-06实际阅读[LLVM/libc++ main include/variant](https://github.com/llvm/llvm-project/blob/main/libcxx/include/variant)：`__generic_get`先检查alternative，`__throw_if_valueless`及`visit`依据index分派。原release/18.x raw URL返回Internal Error，因此阅读main，不能声称固定release18。Apache-2.0 WITH LLVM-exception许可证已读。这里使用标准接口的独立例子，不复制libc++模板实现；宿主Apple libc++不一定与main同版本。完整调用链/失败记录见[source.json](source.json)。

## 机制与知识图谱

`请求shape→构造候选vector→无抛出移动提交Ready→visit显示状态`。Ready的unique_ptr表达唯一所有权，state本身是move-only。准备失败在提交前抛出，旧Ready仍指向原buffer。`static_assert(is_nothrow_move_assignable_v<State>)`是提交策略的前提，后来给alternative加一个可能抛出的move成员会在编译期打断这一保证。

| 操作 | 标准可观察结果 | 业务含义 |
| --- | --- | --- |
| get_if读取错误alternative | nullptr | 允许分支检查 |
| get读取错误alternative | bad_variant_access | 必须处理逻辑错误 |
| 不同alternative的move构造抛异常 | valueless_by_exception | 不是Idle，也不是Failed |
| visit valueless | bad_variant_access | visitor不能替你恢复 |

示例另用Bomb的类型改变move赋值触发确定的valueless路径，然后赋int恢复；不把所有emplace异常都声称必然valueless。显式visitor覆盖三个alternative，增加状态会要求补齐分支。某些访问模式编译器可优化成switch，本课不承诺固定跳表/分派性能。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-06/run.sh release
sh systems_practice/cpp17/2026-10-06/run.sh sanitize
```

[完整实现](src/main.cpp)，C++17/Apple clang21。1000次Ready替换与候选分配失败保持原指针；shape0拒绝、错误get、valueless、visit拒绝及恢复均实际验证。例子是附加现成材料，不增加作业。

## 故障链路与面试追问

- 先emplace销毁旧请求再分配新buffer→异常后旧请求丢失→在分配点注入失败核对原指针→先构造再提交；短暂持有两个buffer，峰值内存增加。
- visitor假定总有值→异常状态下再次抛出→查看valueless/index和原始异常→在系统边界恢复或终止请求；不要把variant_npos当作业务状态编号。
- visitor捕获Ready地址后重置state→悬空访问→审计借用寿命，Sanitizer辅助→让借用不跨状态替换，或明确转移所有权。

追问：variant和虚函数的扩展边界有何差异？get_if与get怎样选择？valueless和monostate是否相同？何种赋值异常保证丢值？为什么候选提交需要nothrow条件？增加新alternative如何发现遗漏？资源峰值与强异常保证怎样权衡？

## 验证结果与边界

[Release](results/verified-release.txt)及[ASan/UBSan](results/verified-sanitize.txt)通过；[verification](verification.json)。不测性能、不声称跨库ABI稳定。main源码阅读与宿主运行是两份独立证据，Linux/板端和跨线程状态同步未验证；这个State没有锁，不能并发改写。

## 下一课

第09课any/type erasure与any_cast失败，比较封闭alternative集合和开放动态类型。
