# 2026-09-27 · TensorRT：输入消费事件与输出所有权

补课：实际编写、源码阅读和验证日期均为 **2026-09-28**。

## 工业场景

Thor SM110 上分类头softmax，[1024,127] FP32，120帧含20预热；输入可提前回收而输出必须等待。

源码来源：[NVIDIA TensorRT](https://github.com/NVIDIA/TensorRT)，main，读取2026-09-28；文件 `samples/sampleNonZeroPlugin/sampleNonZeroPlugin.cpp；include/NvInferRuntime.h`，实际阅读 `SampleNonZeroPlugin::build/infer；IExecutionContext::setInputConsumedEvent/enqueueV3`。许可证：Apache-2.0。实际读过NonZero样例的引擎构建/绑定/同步生命周期；独立改为内置softmax并加入消费事件。没有复制或声称实现NonZero插件。自写kernel基线/候选复用前一天同一源码，构建目标仍110。

## 概念回顾

相机推理服务把输入张量地址绑定给执行上下文，然后异步提交 TensorRT 工作。提交返回只表示主机完成排队，不能证明 GPU 已经读完输入，更不能证明输出可用。如果生产者立即写下一帧，推理可能读到两帧混合的数据，错误往往随调度时序变化而出现。输入消费事件给出了一个较早的所有权归还点：运行时确认不再读取输入后，另一个流才能覆盖该缓冲区。这个事件需要在整次推理期间存活，不能作为函数中的临时资源随提交返回销毁。

与它耦合的第二个机制是输出与上下文的生命周期。输入消费完成不包含输出写入完成，主机读取输出必须等待输出复制及推理流完成。本例在输入事件之后从生产者流把输入清零，用这种主动破坏旧输入的方式检查消费边界，同时仍等推理流结束再检查输出。一次请求全部结束之后才复用上下文，避免把同一上下文并发提交误当成双缓冲。流的析构先同步再销毁，且发生在上下文和设备缓冲区析构之前，使异常路径也遵守设备访问的生命周期。

性能必须分层观察。主机提交时间包括运行时排队开销，设备事件包围的是引擎工作区间，完整请求时间还包含传输、等待和本例用于验证的输入回收操作。引擎构建和反序列化不计入稳态请求，但需要单独考虑启动成本。本课固定小张量形状，专门暴露所有权问题；动态形状、多个执行上下文和跨设备迁移会扩展状态空间，不能从此示例推出已经解决。配套自写 softmax 基线与线程束候选提供可看源码的热点对照，但其机器指令不能冒充 TensorRT 私有内核的实现。

## 知识图谱

绑定地址 → enqueueV3 → consumed事件 → producer流清零输入；infer流完成 → 输出读取 → 上下文复用

前置：C++17 对象生命周期、行主序张量及显式错误检查。语言保证、运行时实现和硬件执行分别验收；不把CPU状态机当设备同步证明。

## 编码练习

唯一25分钟练习：给CPU Lease和设备示例增加一个“取消等待但资源仍保留”的请求状态；保持GPU访问完成前不销毁资源。5分钟读事件契约，12分钟修改，8分钟状态机测试与Thor验收。

## 文件说明

[src](src/) · [构建](CMakeLists.txt) · [入口](run.sh) · [验证](results/verification.json)。
附加现成阅读：[每日量化](../../quantization/2026-09-27/spqr/README.md) · [ARM](../../arm/2026-09-27/README.md) · [两篇论文](../../paper/2026-09-27/README.md)。不增加第二个强制作业。

## 编译与运行

从本目录执行，不安装依赖或下载模型：

```sh
bash run.sh cpu
bash run.sh sanitize
# 仅 Thor，TRT headers/lib 可由 CMAKE_PREFIX_PATH 定位:
bash run.sh thor
```

所有CUDA执行目标仅Thor sm_110。官方JetPack下载页读取2026-09-28列出7.2.1/L4T39.2.1/CUDA13.2.2/TensorRT10.16.2；实际驱动、ncu版本和构建兼容仍需在板端核验。见[PROFILE](PROFILE.md)。

## 正确性验证

CPU所有权状态机Release/ASan/UBSan通过；CUDA配置缺nvcc失败，TensorRT编译、事件生命周期、结果与性能均未验证。

测试失败会返回非零退出码，不使用Release会消失的assert。原始日志保留在results，目标设备应先通过正确性再采性能。

## 性能分析

配套[PROFILE.md](PROFILE.md)给出公平基准、ncu筛选采集和PTX/SASS生成。CPU提交、GPU kernel/engine、传输与端到端分别记录；暂无GPU数字。

## 实际运行结果

CPU所有权状态机Release/ASan/UBSan通过；CUDA配置缺nvcc失败，TensorRT编译、事件生命周期、结果与性能均未验证。 [CPU日志](results/cpu.txt) · [消毒器日志](results/sanitize.txt)。

## 工程注意事项

实际读过NonZero样例的引擎构建/绑定/同步生命周期；独立改为内置softmax并加入消费事件。没有复制或声称实现NonZero插件。自写kernel基线/候选复用前一天同一源码，构建目标仍110。 RAII清理检查CUDA返回值，不能释放设备仍在访问的资源；输入/输出大小与容量必须一致。每帧 FrameDrain 在主机张量之后声明，异常时先同步两流再释放主机输入/输出，避免异步复制访问已经析构的 vector。

## 工业故障与面试追问

- 提交后马上覆盖输入出现间歇错误；变值/清零输入和事件轨迹定位，等待consumed。
- 把consumed当输出完成读到旧值；D2H后同步infer流。
- 异常路径先销毁context出现非法访问；检查RAII声明逆序，让stream先同步销毁。

面试追问（基础→实现→边界→权衡）：

1. enqueue返回保证什么？
2. 输入事件为何不能保护输出？
3. 跨流复用需什么依赖？
4. 单context可并发enqueue吗？
5. 引擎构建时间如何计入冷启动？
6. 引擎事件区间为何不是单kernel时间？

## 自测问题

如果输出缓冲区也交给另一个GPU后处理流，最早何时可以让下一帧复用它？请写出完整事件依赖图。
