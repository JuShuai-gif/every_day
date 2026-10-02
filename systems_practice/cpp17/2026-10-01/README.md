# 2026-10-01 C++17 03：唯一所有权与移动后状态

## 本课目标与前置

承接02生命周期，机器人帧缓冲从采集侧移入单槽处理器：成功接收才转移所有权，满槽或异常必须保留调用方资源。耦合机制是unique_ptr的唯一释放责任与显式提交点。它们是C++11基础，本课用C++17编译，不宣称属于C++17新增功能。

## 源码阅读

实际读[llvm/llvm-project release/18.x的unique_ptr.h](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/__memory/unique_ptr.h)，2026-10-01，move constructor→release、move assignment→reset(u.release())→转移deleter、reset和析构。精确commit未固定；[LLVM LICENSE](https://github.com/llvm/llvm-project/blob/release/18.x/LICENSE.TXT)为Apache2.0 WITH LLVM-exception。原场景是通用资源管理库，独立业务例子只使用std::unique_ptr，不移植库源码。读取范围与失败检索见[source.json](source.json)。

## 机制与知识图谱

`Owner持有Frame → 检查槽位与失败注入 → std::move提交 → Slot唯一持有 → take移动 → reset释放`。std::move本身只是转换表达式类别；真正的unique_ptr移动构造/赋值才转移指针，并保证源为空。不能把此保证推广到所有“有效但未指定状态”的移动后对象。

| 操作 | caller | slot | 释放责任 |
| --- | --- | --- | --- |
| 满槽拒绝 | 原值保留 | 原值保留 | 各自 |
| 提交前抛异常 | 原值保留 | 空 | caller |
| 接收成功 | 空 | 原caller指针 | slot |
| take | 空 | 空 | 返回的Owner |

[Slot::offer](src/example.cpp)接Owner&，先验证再移动；若按值传入，调用入口就可能消耗所有权，拒绝语义会不同。移动赋值到非空目标会先释放旧资源，故活对象计数必须覆盖该路径。移动通常保留被指向对象地址，borrowed pointer可以暂时相同，但reset或生命周期结束后不再可用。本例不解引用悬空地址。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-01/run.sh
```

EveryDay根，Apple clang21 C++17。Frame计数器与unique_ptr自动清理；静态断言禁止复制且move不抛。1000轮覆盖空输入、满槽拒绝、提交前异常、接受、take、非空目标移动赋值、reset，最后alive=0；现成附加例子，无新增作业。

## 故障链路与面试追问

故障一：队列满后调用方无法重试→断言caller非空并检查API参数→按值入口提前移动→改为明确提交时转移或返回未消费Owner；代价是调用者必须理解引用合同。故障二：异步任务偶发UAF→ASan和资源时间线→移动后仍保存裸借用并跨越reset→把所有权移入任务或建立有界借用寿命；不要无条件改shared_ptr隐藏责任。故障三：接收失败泄漏→检查异常发生在提交前后及alive计数→用RAII保证失败回滚，不能把release当无害观察器。

生产迁移验收：规定拒绝是否消费资源；异常注入覆盖每个提交前步骤；deleter兼容真实相机/设备释放接口并不抛；异步所有权与join边界明确；ASan和长期资源计数通过。Slot是单线程示例，unique_ptr不能自动提供并发同步。未涉及GPU/NPU缓冲区释放API。

追问：1.std::move究竟做什么？2.unique_ptr移动后源为何可判空？3.按值offer和Owner&有何失败语义差别？4.release与reset谁释放？5.移动赋值到非空目标会怎样？6.为何所有权正确仍可能有数据竞争？

## 验证结果与边界

[初测](results/initial.txt)与[最终](results/final.txt)保留；Release及ASan/UBSan的1000轮均通过，alive=0。未测性能，不声称移动一定比复制快；未跑Linux或板端。[verification.json](verification.json)分开记录源码阅读、宿主和目标状态。Google请求失败、知乎无已核查原文，不将搜索摘要当教程。

## 下一课

04 noexcept与vector重分配：从单次移动所有权走向容器扩容时的异常保证与复制/移动选择。
