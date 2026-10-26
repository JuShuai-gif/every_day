# 2026-10-26 C++17 第24课：条件变量与退出协议

## 本课目标与前置

承接shared_mutex的读者寿命，处理边缘推理worker的退出：谓词等待与关闭排空。队列容量4，单worker消费，任务异常可隔离。条件变量是C++11基础，本例使用C++17编译，不引入jthread/stop_token。

## 源码阅读

实际读[LLVM libc++ llvmorg-20.1.8 condition_variable.h](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/__condition_variable/condition_variable.h) `condition_variable::wait(lock,predicate)`：循环检查predicate，不满足就调用底层wait；[condition_variable.cpp](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/condition_variable.cpp) `wait/notify_one/notify_all`：检查锁所有权、调用平台封装、处理错误。Apache-2.0 WITH LLVM-exception；读取2026-10-26，blob见[source.json](source.json)。

原场景是通用标准库等待；本课是独立队列实现，保留谓词循环与锁保护状态，加入业务关闭协议，不复制库实现。没有把libc++调用封装当作已阅读Darwin pthread或Linux futex内核；C++标准不保证具体futex实现。

## 机制与知识图谱

```text
mutex保护(items, closed) → wait检查谓词 → 原子解锁/等待 → 唤醒后重新上锁/检查
closed=false → close提交true → 同时唤醒消费者和等待容量的生产者
closed && 非空 → 继续pop；closed && 空 → 结束 → join → 销毁队列
```

notify不是状态，也不会积攒“任务令牌”。消费者谓词是`closed || !empty`；生产者谓词是`closed || size<capacity`。close与谓词在同一互斥量下修改/读取，解决检查后睡眠的丢失唤醒窗口。正常push通知一个消费者，close通知两组所有等待者。worker单独处理任务异常，继续计入已完成任务；队列对象必须比所有访问它的线程活得久。

基线思考是仅等待`!empty`或仅通知消费者，关闭时会挂住；本例不会故意启动无法退出的线程，而以“空close”和“满队列producer close”的有限回归覆盖修复。`noise()`主动通知但不改状态，证明不能将唤醒当作可消费，不宣称制造了真实系统伪唤醒。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-26/run.sh release
sh systems_practice/cpp17/2026-10-26/run.sh sanitize
sh systems_practice/cpp17/2026-10-26/run.sh thread
```

[完整实现](src/main.cpp)与RAII Joiner在异常退出时close/join。40轮×100任务，每轮5次受控任务异常；容量4、重复close、关闭后提交拒绝、空队列结束和满队列生产者退出。满队列用例允许线程在close前或后到达wait，两种调度都须拒绝；没有假称精确观察了阻塞状态。工作区已有Clang21，未安装依赖。

## 故障链路与面试追问

| 条件→信号 | 诊断 | 修复与代价 |
| --- | --- | --- |
| 只notify消费者→满队列producer无法退出 | 线程栈位于space wait，closed已真 | 关闭时广播两组，唤醒后重查谓词；可能出现唤醒竞争 |
| 空即退出→尚未close的worker提前死亡 | 检查closed/empty二元状态和完成数 | 用带closed的谓词；等候结束依赖明确close |
| 任务抛异常→进程terminate或排空不足 | 区分任务异常与队列/锁异常，计数结果 | worker内隔离业务异常，最终join；不能无声吞掉基础设施异常 |

追问：为什么wait必须带谓词？notify是否保存状态？close为何广播生产者？unlock后notify是否安全？join后读计数为何无数据竞争？队列为空是否等于所有请求完成？

## 验证结果与边界

[Release](results/verified-release.txt)、[ASan/UBSan](results/verified-sanitize.txt)、[TSan](results/verified-thread.txt)均通过：4000任务、200受控任务异常、满队列4项排空、空队列close。来源/编译/运行分开见[验证](verification.json)。TSan通过是本次路径证据，不是形式证明或所有调度覆盖。未测性能；Linux/板端、GPU/NPU/E2E未验。

迁移验收：覆盖多个生产者、线程启动失败、容量上界和shutdown顺序；在业务服务中区分排队/在途计数；目标libc++或libstdc++上跑关闭回归与TSan。当前单worker简化不支持并发析构与外部submit，调用方须先停止访问。

## 下一课

第25课future/promise：把worker内部异常和结果所有权安全传回请求端。
