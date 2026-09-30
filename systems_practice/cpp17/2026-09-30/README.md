# 2026-09-30 C++17 02：对象寿命、作用域与Rule of Zero

## 本课目标与前置

承接01的配置失败回滚：推理服务构造请求时先取得文件、暂存区，再创建解码器。如果最后一步失败，文件不能泄漏。输入是正常/失败开关；输出为打开/关闭计数和一次字节往返。讲两个机制：**部分构造的反序清理**与**由资源成员组合得到的Rule of Zero**。它们是C++既有基础（unique_ptr自C++11），不是C++17新增；本课严格C++17。

## 源码阅读

2026-09-30实际读[LLVM/libc++ release/18.x unique_ptr.h](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/__memory/unique_ptr.h)：`~unique_ptr→reset→deleter`，`release`清空原指针，移动赋值调用reset/release。许可证[Apache-2.0 WITH LLVM-exception](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/LICENSE.TXT)。分支读取，精确commit待补；这是通用独占对象所有权实现。本课独立实现FILE删除器与Request组合，保留单一所有者/自动回收机制，省略allocator、共享所有权、异步设备事件；未复制上游代码。[source.json](source.json)。

## 机制与知识图谱

`Request{File, vector, Decoder}`按**成员声明序**初始化。Decoder抛异常时，Request从未完成构造，不会调用Request析构函数；已完成的vector和File仍反序析构。File的自定义deleter关闭FILE并更新计数，不能抛异常；清理失败通过close_errors报告。测试者Stats必须活得比所有File长，这个外部观察器本身也是寿命合同。

Request没有声明析构/复制/移动特殊成员。编译器由unique_ptr成员推导不可复制、可移动，static_assert核实。移动后只检查标准保证的源file为空，不假设vector移动后固定size。重复reset安全，表示释放可幂等；不把同一个raw FILE交给第二个owner。把借用get()长久保存在异步回调仍会悬空，RAII不能替代请求完成协议。

| 状态 | 已成功资源 | 退出路径 |
| --- | --- | --- |
| fopen失败 | 无 | 抛错，计数不增 |
| vector或decoder构造失败 | 已构造成员 | 自动反序释放 |
| 构造完成→移动 | 资源归新对象 | 源file为空 |
| reset→离开作用域 | 文件已关 | 不重复关闭 |

## 运行与观察

本课目录`sh run.sh`，脚本把临时目录设为本课build/tmp，产物忽略。C++17 Release与ASan/UBSan，1000次Decoder故障、1000次移动和重复reset；实际日志[results/run.txt](results/run.txt)。正常路径fwrite/fflush/fseek/fread均检查返回值，打开2000次、关闭2000次，清理错误0。

## 故障链路与面试追问

- 服务错误请求增多后FD耗尽：定位构造失败发生在资源取得之后；统计打开/关闭差值，故障注入回归。修复把资源首先放进RAII成员，而非只在最外层析构手工关闭；代价是显式移动与deleter寿命设计。
- 请求排队后出现坏句柄：检查借用指针是否越过owner作用域，不能只看打开/关闭数平衡。把整个owner移动到任务或保留完成租约；这会延长资源占用，队列必须有界。本课不执行悬空访问来“验证”UB。
- 文件关闭失败被吞：析构不能安全向外抛，但只报告也未必满足持久化需求。关键输出需显式可失败的commit/flush步骤，析构只兜底；本例验证资源寿命，不提供掉电持久化保证。

追问：1. 外层构造失败会调用谁的析构？2. 成员初始化列表顺序是否决定构造顺序？3. Rule of Zero为什么仍允许自定义普通构造函数？4. unique_ptr移动后源对象保证什么？5. deleter引用的Stats为什么必须长寿？6. RAII为什么不能保证异步回调完成？

## 验证结果与边界

[verification.json](verification.json)：Mac Apple clang21 Release/ASan/UBSan实际通过，无GPU/NPU/吞吐/端到端性能结论。未注入真实文件系统关闭失败或bad_alloc；Decoder故障只证明该失败点的展开。迁移应在目标libc++/libstdc++与文件系统重跑边界，增加FD上限、队列关闭与磁盘失败；不把本机2000次平衡当生产长期稳定验收。

## 下一课

03按[课程表](../curriculum.json)继续；本课的单一所有权是下一节移动语义与所有权转移的前置。现成附加例子，无第二个强制作业。

归档前复验改用本课`build/tmp/request.tmp`，确保写入位置受控；最初`results/run.txt`使用匿名tmpfile，保留原始证据，最终版本见`results/final-run.txt`。
