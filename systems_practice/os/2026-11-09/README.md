# 2026-11-09 project05：非阻塞发送游标与字节预算

## 本课目标与前置

推理结果输出管道被慢消费者阻塞，应用重试时从头发送造成重复帧。 本栏目为现成附加例子，不增加必做编码任务。前置：昨日课、RAII与容器寿命。

## 机制与知识图谱

enqueue限制未发送字节总量，flush每次只推进write实际返回的字节数；EAGAIN保留cursor，EINTR重试。pipe是字节流，生产使用还需上一课的组帧器，1MiB并不是内核pipe容量。vector逻辑长度上界不等于capacity/RSS上界；append分配失败会抛出，调用方需决定断流或重试。示例单生产者单线程驱动，未测试多writer原子性。

`输入合同 → 取得所有权/准入 → 执行与错误返回 → 推进状态 → 发布或回收`。关键函数见src/main.cpp；没有把API返回成功等同最终业务完成。

## 源码阅读

实际阅读[pipe_write → pipe_full/O_NONBLOCK/EAGAIN；pipe_poll就绪检查](https://github.com/torvalds/linux/blob/v6.8/fs/pipe.c)，v6.8，许可GPL-2.0。Linux原生pipe实现已读相关函数；用户态独立实现保留短写/EAGAIN语义，不复制内核锁或ring。与xv6区别：此处使用Linux/POSIX非阻塞状态，不声称xv6有同样poll接口。 分支读取只固定读取日，目标BSP/库仍需精确版本核验。知乎定向搜索未获得匹配原作者正文，不用无关搜索结果作依据。

## 运行与观察

在本目录执行`sh run.sh release`和`sh run.sh sanitize`。C++17；CMakeLists.txt亦可构建。原始Mac结果在results；Thor以当日隔离同步及最终hash结果为准。测试使用私有build目录或匿名pipe，不访问用户业务文件。至少覆盖空/边界、失败恢复与正确性oracle。

## 故障链路与面试追问

短写后从头重发→校验序列重复→保留实际发送cursor；只限制单帧长度→排队总内存增长→按pending字节做准入。

追问：EAGAIN是否丢数据？write返回正数能否小于请求？预算含已发送前缀吗？poll可写保证整帧吗？PIPE_BUF等于pipe容量吗？多writer怎么处理？

## 验证结果与边界

Mac Release和ASan/UBSan通过；详见results。功能验证不声称吞吐、实时性或完整推理产品。无GPU/NPU测量，CUDA执行固定Thor SM110。迁移验收须在目标Linux运行相同错误路径并对齐源码SHA256；ARM/RK3588不是同一板端验收。

## 下一课

project06：发送关闭与EPIPE终态；同日不重复推进。

最终验证：本次最终源码在Thor隔离目录运行Release和ASan/UBSan均通过，原始结果为results/thor-*.txt；同步前后17项SHA256相同。不是RK3588板验。
