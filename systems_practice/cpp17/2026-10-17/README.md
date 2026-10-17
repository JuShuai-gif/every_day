# 2026-10-17 C++17第17课：inline变量、ODR与静态配置

## 本课目标与前置

承接invoke/apply的接口边界，今天处理跨编译单元共享配置和统计。两个源文件同时include头文件，需要同一个配置地址和计数器。C++17新增inline变量；内部/外部链接、对象寿命和ODR是更早的基础。默认一个可执行文件，不扩展成动态库全局单例承诺。

## 源码阅读

实际读 [LLVM/libc++ llvmorg-20.1.8 include/optional](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/optional) 274–281行的 `nullopt_t`、受限构造标签及 `inline constexpr nullopt`定义。原场景是标准库无值标签，保留头文件定义与跨TU对象身份机制；本课为独立配置示例，省略optional内部存储、ABI宏和异常实现。该tag尚未把定义移到__optional/nullopt_t.h，尝试该路径404后找到真实文件。Apache-2.0 WITH LLVM-exception，[source.json](source.json)保留哈希。仅看此段，不宣称实现了整个optional。

## 机制与知识图谱

头文件inline定义→多个TU可见→满足ODR的同一实体→地址一致；`static const`内部链接→每TU独立实体→地址不同。constexpr负责常量求值，不应把它和链接身份混成同一概念；本例显式inline使namespace配置共享。编译器/链接器常以weak/coalesced符号实现合并，C++保证不依赖具体Mach-O符号名。

inline不赋予线程安全：配置不可变，计数器用atomic。relaxed适合独立计数，不发布其他payload；即使两个TU读写同一对象也不能用普通int制造竞争。多个定义必须相同且名称查找一致，宏生成不同定义仍违反ODR，链接成功不证明合法。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-17/run.sh
sh systems_practice/cpp17/2026-10-17/check-negative.sh
```

`main.cpp/reader.cpp/config.hpp`为完整三文件例子：比较config、local_config及std::nullopt地址，边界reserve0/4/5及负数；两个TU累计accepted=5。负例生成到build，两个普通外部变量重复定义，预期链接失败并检查duplicate symbol，不执行ODR违规程序。未测试宏不同定义的“不要求诊断”行为。

## 故障链路与面试追问

1. 每个文件计数看起来正确，总数却不同：检查是否在头文件用了static，比较两TU地址即可区别于丢更新；修复为inline atomic或集中定义/extern。代价是共享竞争，不能拿共享对象替代线程本地统计策略。
2. Debug可链接、插件加载后状态不一致：检查可见性、DSO边界、宏不同定义和装载方式。固定配置定义并显式导出接口/传入状态；本例只验证单可执行文件，未把地址一致推广跨动态库。
3. inline普通int压力测试丢计数：ODR保证身份，不保证同步。检查竞争报告，改atomic或锁；本课不执行有UB的反例。

追问：①inline变量的inline是什么意思？②namespace const与inline constexpr链接有何差异？③ODR为什么不总有诊断？④relaxed计数能发布请求数据吗？⑤跨DSO有什么额外边界？⑥如何避免动态初始化顺序依赖？

## 验证结果与边界

Apple clang21、C++17，Release和ASan/UBSan通过身份、边界及拒绝。实际链接失败日志见[negative.txt](results/negative.txt)，正常结果见[release.txt](results/release.txt)。无性能测量；无Linux/板端/跨DSO验证。[verification.json](verification.json)。Google直接查询失败，知乎检索没有采用的正文；依据真实libc++实现。

迁移验收：用目标Linux工具链编译两个TU、确认一致头文件配置、运行身份/边界，跨DSO另设计显式接口和测试，不依赖链接器偶然合并。示例为附加材料，无额外强制作业。

## 下一课

第18课：返回值与对象构造，继续区分保证的拷贝消除与可选NRVO。
