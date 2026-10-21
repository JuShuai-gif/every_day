# 2026-10-21 C++17 第20课：PMR资源寿命与帧内存回收

## 本课目标与前置

承接第19课对齐，为每帧最多1000个Token建立内存资源。C++17新增pmr允许容器通过运行时memory_resource选择分配策略；容器/对象寿命仍遵循早期C++规则。10–15分钟现成材料，无额外作业。

## 源码阅读

实际读[LLVM libc++ llvmorg-20.1.8](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/src/memory_resource.cpp)：`monotonic_buffer_resource::do_allocate → __try_allocate_from_chunk → align_down`；以及[对应头文件](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/libcxx/include/__memory_resource/monotonic_buffer_resource.h)的 `release/do_deallocate/~monotonic_buffer_resource`。Apache-2.0 WITH LLVM-exception。原实现管理通用chunk、alignment和上游扩容；本例独立调用标准API，不复制库内部链表。

关键观察：该版本从chunk末端向低地址对齐分配；`do_deallocate`为空操作；`release`重置初始游标并遍历释放上游chunk。增长策略是实现细节，不把某次4032B分配提升为标准保证。[source.json](source.json)记录范围。

## 机制与知识图谱

`upstream → initial buffer → arena → vector<Token> → Token`；销毁顺序反过来。资源只归还存储，不知道Token析构函数。`clear()`销毁Token但vector仍拥有capacity；arena的单次deallocate不回收chunk。必须让所有借用该arena的容器先析构，再release；即使vector已clear，提前release仍会留下悬空capacity。

| 操作 | 对象 | 存储 |
| --- | --- | --- |
| clear1000个Token | alive变0 | 上游chunk仍活着 |
| 容器离开作用域 | 容器析构完成 | 单调资源仍保留chunk |
| arena.release | 无存活对象 | chunk归还上游，初始buffer可复用 |

[代码](src/main.cpp)中Counting通过new_delete_resource转发分配，记录活跃/峰值bytes；有限资源使用128B初始buffer和null_memory_resource。reserve4096触发bad_alloc，vector已有元素42必须保留。Token(-1)构造失败不增加alive；所有退出由RAII覆盖。

## 运行与观察

```sh
sh systems_practice/cpp17/2026-10-21/run.sh
MODE=sanitize sh systems_practice/cpp17/2026-10-21/run.sh
```

本机Apple clang21/macOS arm64，C++17，未安装依赖。实际[Release](results/release.txt)与[ASan/UBSan](results/sanitize.txt)：1000对象clear后alive0、retained4032B；一次上游分配、release后live0；有限资源OOM强保证、重用和构造回滚均通过。4032含库chunk开销，不是1000对象有效payload，也不是RSS。没有测速度或分配抖动。

## 故障链路与面试追问

- 帧结束后RSS不降：clear仍保留arena chunk→比较Counting.live与Token.alive，区分对象泄漏和资源保留→容器析构后按帧release；频繁上游分配可能损害延迟稳定性。
- 稀有大帧耗尽：无界上游掩盖容量估计错误→null上游注入OOM，检查旧vector内容→预留容量、业务拒绝/降级；不在仍有借用时重置资源。
- 多线程共用单调资源：并发分配可能数据竞争→所有权/线程审计→每worker独立arena或外部串行；本课未实现并发分配器。

追问：①pmr是容器还是分配协议？②clear、deallocate、release分别结束什么？③上游应活多久？④为什么clear后不能立即release？⑤null上游如何形成容量边界？⑥如何测帧延迟而非只计分配次数？

## 验证结果与边界

[verification.json](verification.json)。上游阅读、宿主编译、实际运行与sanitizer通过；目标Linux/板端未验。示例不执行悬空指针来演示错误，未测GPU/NPU/E2E。生产迁移需确认标准库pmr支持、对齐、最大请求、异常策略和每线程资源寿命。

实际检索日期2026-10-21。Google直访 `https://www.google.com/search?q=ncnn+float2int8+NEON+rounding+pmr+futex` 与知乎 `https://www.zhihu.com/search?type=content&q=NEON%20float2int8` 被网页工具拒绝访问；搜索引擎查询未取得可核查的知乎原文，因此不声称读过知乎案例。技术依据来自下面实际读取的GitHub实现与官方资料。

## 下一课

第21课filesystem、error_code与TOCTOU：资源有效不等于路径持续指向同一对象。
