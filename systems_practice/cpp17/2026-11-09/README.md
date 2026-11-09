# 2026-11-09 project05：临时文件发布与清理

## 本课目标与前置

新配置写到一半失败，不能覆盖仍在使用的current配置。 本栏目为现成附加例子，不增加必做编码任务。前置：昨日课、RAII与容器寿命。

## 机制与知识图谱

Output在私有测试目录mkstemp创建候选，write检查fwrite，publish先检查fclose再rename；析构删除未发布候选。rename提供路径可见性的切换，未调用fsync所以不宣称掉电持久化。文件系统错误以filesystem_error传播；跨文件系统EXDEV需另设计，不偷偷copy覆盖。C++17 filesystem为新增接口，RAII和FILE属于既有机制。

`输入合同 → 取得所有权/准入 → 执行与错误返回 → 推进状态 → 发布或回收`。关键函数见src/main.cpp；没有把API返回成功等同最终业务完成。

## 源码阅读

实际阅读[CleanupInstaller构造/析构，ToolOutputFile构造](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/llvm/lib/Support/ToolOutputFile.cpp)，llvmorg-20.1.8，许可Apache-2.0 WITH LLVM-exception。原场景编译工具输出与失败清理；独立启发实现只在mkdtemp私有目录实验，新增rename发布，不复制信号清理。主课讲内存会话，本课增加真实文件系统错误边界。 分支读取只固定读取日，目标BSP/库仍需精确版本核验。知乎定向搜索未获得匹配原作者正文，不用无关搜索结果作依据。

## 运行与观察

在本目录执行`sh run.sh release`和`sh run.sh sanitize`。C++17；CMakeLists.txt亦可构建。原始Mac结果在results；Thor以当日隔离同步及最终hash结果为准。测试使用私有build目录或匿名pipe，不访问用户业务文件。至少覆盖空/边界、失败恢复与正确性oracle。

## 故障链路与面试追问

写半文件直接替换→读者看到坏配置→使用独立候选；析构静默close→延迟I/O错误被吞→显式close成功才发布。

追问：rename与fsync分别保证什么？失败候选由谁清理？为何临时文件放同文件系统？close失败能重试吗？旧打开FD读哪个版本？并发发布如何仲裁？

## 验证结果与边界

Mac Release和ASan/UBSan通过；详见results。功能验证不声称吞吐、实时性或完整推理产品。无GPU/NPU测量，CUDA执行固定Thor SM110。迁移验收须在目标Linux运行相同错误路径并对齐源码SHA256；ARM/RK3588不是同一板端验收。

## 下一课

project06：持久化与目录fsync边界；同日不重复推进。

最终验证：本次最终源码在Thor隔离目录运行Release和ASan/UBSan均通过，原始结果为results/thor-*.txt；同步前后17项SHA256相同。不是RK3588板验。
