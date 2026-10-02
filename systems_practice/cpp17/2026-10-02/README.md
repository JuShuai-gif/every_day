> 2026-10-02并发游标纠正：本页是补充材料，不计本日正式课程、不增加必做作业；请从[正式C++17第04课](session-02/README.md)开始。旧源码、来源与日志全部保留。

# 2026-10-02 C++17 第03课：唯一所有权与移动后状态

## 本课目标与前置

承接RAII：推理帧交给单槽队列时，拒绝入队后由谁释放？两个机制是unique_ptr的排他所有权和移动提交边界。它们属于C++11基础，本例严格C++17，无C++20接口。输入是两个Frame与一个空Owner，输出是接受/拒绝和生命周期账本。单线程Slot是现成合同示例，不声称线程安全。

## 源码阅读

2026-10-02实际读取[LLVM/libc++](https://github.com/llvm/llvm-project) release/18.x的[__memory/unique_ptr.h](https://github.com/llvm/llvm-project/blob/release/18.x/libcxx/include/__memory/unique_ptr.h)，`unique_ptr(unique_ptr&&)→release`、move assignment→reset、析构→reset。Apache-2.0 WITH LLVM-exception，精确commit待补；源码日期与分支已记录。原场景是标准库通用资源所有权，本例直接使用标准库API、独立实现Slot，不复制内部compressed_pair等细节。新头文件带C++23条件宏不意味着例子使用C++23。

## 机制与知识图谱

[代码](src/example.cpp)路径：`offer(Owner&)`先检查空/满，再执行可能失败的校验，最后移动；`take()`把所有权转给调用者。std::move只提供右值表达式，真正转移由unique_ptr移动操作完成。移动后源unique_ptr为空是该类型的保证，不能推广为所有类型都“变空”。

| 状态 | 调用者first | Slot | 消费者 | 观察 |
| --- | --- | --- | --- | --- |
| 构造 | 独占Frame A | 空 | 空 | alive=2（另有B） |
| 校验抛错 | 仍持有A | 空 | 空 | 原地址保持 |
| 接受 | 空 | 持有A | 空 | 没有复制Frame |
| take | 空 | 空 | 持有A | 原borrowed地址仍相同 |
| move赋给B owner | 空 | 空 | 转移走 | B先释放，alive=1 |
| reset | 空 | 空 | 空 | alive=0 |

借用指针get不延长寿命。移动owner不移动堆上对象，但新owner销毁后旧borrowed失效；例子不解引用悬空指针来“测试”。reset销毁旧对象后仍可重复置空，默认deleter无异常。若业务校验放到move之后，拒绝可能已丢失调用者重试能力。

## 运行与观察

```sh
sh run.sh
```

Apple clang21，Release与ASan/UBSan运行1000轮：空拒绝、满拒绝、注入异常、接受、take、再次空take、移动赋值释放旧资源、reset。编译期检查Owner不可复制、移动构造noexcept；运行期独立计数确认资源最终清零。原始[日志](results/host.txt)、[验证](verification.json)、[来源](source.json)。这是完整附加例子，无第二个必做练习。

## 故障链路与面试追问

故障一：队列满后无法重试→按值接收Owner已经提前转移→检查调用边界前后source→采用本例引用参数先校验后commit→代价是API必须说明失败保留所有权，回归异常/满两路径。

故障二：移动后borrowed偶尔崩溃→新owner reset了→沿所有者寿命定位而非把std::move当内存搬运→让借用只在明确scope内或传递owner→避免使用共享所有权掩盖业务生命周期，回归析构计数。

迁移到线程池须加入锁/队列关闭与排空协议，unique_ptr仅解决寿命，不提供发布内存序。未做并发/性能测试，不报告延迟收益。设备buffer版还要等设备完成再释放，CPU owner析构不替代CUDA event。

追问：①std::move是否移动数据？②unique_ptr移动后保证与vector的区别？③get/release/reset各改变什么？④move赋值如何释放旧对象？⑤为什么先校验再commit？⑥unique_ptr是否解决线程同步？

## 验证结果与边界

源码已读、宿主编译/执行/Sanitizer通过；精确源码commit、Linux板端、设备异步寿命未验证。没有构造UB或声称完成并发队列。

## 下一课

04按课程表继续移动成本与容器扩容，独立游标只推进一次。
