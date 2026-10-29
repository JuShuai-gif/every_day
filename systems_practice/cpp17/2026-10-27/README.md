# 2026-10-27 C++17 第25课：future / promise 异常传播

## 本课目标与前置
边缘服务把预处理交给 worker，调用方要拿到值或原始异常。两个机制是 promise 对共享状态的写入所有权与 future.get 的一次性消费/异常重抛。

## 源码阅读
读取 LLVM llvmorg-20.1.8 libcxx/include/future 的 promise::set_value/set_exception、future::get 和 __assoc_state，Apache-2.0 + LLVM exceptions。标准库原场景；本课独立保留 one-shot contract，省略 executor、取消与生产回收。

## 机制与知识图谱
worker owns promise → set_value/set_exception → shared state；caller owns future → wait/get → value or exception。promise 异常路径若未设置结果，会变成 broken promise；future 不能复制，get 后状态被消费。

## 运行与观察
sh systems_practice/cpp17/2026-10-27/run.sh；正值返回 49，负值重抛 invalid_argument。代码是现成附加材料，不增加第二个任务。

## 故障链路与面试追问
异常分支忘 set_exception→broken promise→统一 catch 写入；两个消费者调用 get→第二次失败→明确单消费者或共享结果。追问：promise 谁拥有？get 为何一次？future 是否自动 join？异常怎样跨线程？生产代码如何取消和回收？

## 验证结果与边界
Apple Clang21 C++17 Release/ASan/UBSan 通过；未宣称 TSan、Linux executor 或性能收益。详见 source.json 和 verification.json。

## 下一课
下一课为第26课原子与发布可见性。
