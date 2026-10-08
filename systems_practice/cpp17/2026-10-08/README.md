# 2026-10-08 C++17 第10课：from_chars与完整输入合同

## 本课目标与前置

从第09课动态值失败转向相机输入shape解析：两个字符串变成rows/cols/bytes。今天耦合`from_chars`的词法结果和候选配置提交；C++17新增的是接口，事务式更新是既有工程方法。输入十进制正整数1–4096，总FP32缓冲不超过4MiB，无空格、正号、单位或内嵌NUL；不依赖字符串以NUL终止。

## 源码阅读

2026-10-08实际读[LLVM main](https://github.com/llvm/llvm-project)的[libcxx/include/__charconv/from_chars_integral.h](https://github.com/llvm/llvm-project/blob/main/libcxx/include/__charconv/from_chars_integral.h)：`from_chars`→`__from_chars_atoi`→`__subject_seq_combinator`，重点是数字扫描、溢出后继续确定ptr、成功才写value。Apache-2.0 WITH LLVM-exception。llvmorg-18.1.8直链Cache miss，改读main，未固定SHA。原场景通用整数解析；本例独立调用API，增加完整消费与业务预算，不复制内部实现。只用整数接口，不推断浮点支持或C++23 constexpr可用。[来源记录](source.json)。

## 机制与知识图谱

`借用string_view → 空串拒绝 → from_chars(ptr,ec) → 完整消费 → 数值范围 → checked bytes → 提交Shape`。

`12ms`能合法返回12及指向m的ptr，`ec==0`仅表示解析了有效前缀；业务要求还需`ptr==end`。词法错误或超出uint32范围时库保留目标值，但业务上限拒绝发生在解析成功之后，所以仍使用局部候选，不能直接解析到live字段。乘法先除法检查，避免先溢出再比较。空view先返回，不对潜在空指针做加法。本例限制4096已使乘法很小，通用checked乘法保留以避免未来放宽时出现漏洞。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-08/run.sh
MODE=sanitize sh systems_practice/cpp17/2026-10-08/run.sh
```

现成[src/main.cpp](src/main.cpp)验证4096个有效值、11类词法/业务拒绝、超4MiB回滚、uint32溢出保持77、`12ms`部分消费2字符。拒绝包含`2\0x`，不会被C字符串接口提前截断。第一次编译的initializer_list类型冲突已修正，旧[失败日志](results/release.txt)保留，最终日志以verified为准。

## 故障链路与面试追问

1. 输入`640junk`却生效→只看ec→观察ptr偏移→完整消费后再提交；回归单位、空格、NUL与完整数字，不能以悄悄截断修复。
2. rows修改成功但cols失败→直接写live造成半配置→对比失败前后的三个字段→候选整体提交；回归第二字段失败和总字节越界。

迁移验收：确认目标libc++/libstdc++整数from_chars存在；HTTP/配置入口先确定字节长度；协议若接受空格应显式规范化并单独测试。不要执行越界读来验证接口。

追问：1. ec成功能否忽略ptr？2. from_chars与stoi在异常/locale上如何不同？3. unsigned接受负号吗？4. 为什么业务失败仍需候选值？5. NUL终止和长度边界有何不同？6. shape上限扩大后怎样维护字节乘法检查？

## 验证结果与边界

[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)均通过，Apple clang21/C++17。本课只测正确性，不报告解析吞吐。Linux/板端未验；来源阅读/本机执行分别见[verification.json](verification.json)。

## 下一课

第11课：try_emplace与insert_or_assign，把解析后的配置接到哈希表更新中；今天不提前推进。
