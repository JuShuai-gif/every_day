# 2026-09-14：C++ 工程知识——并发控制帧 Arena 与受管对象回收

## 工业场景

双相机 VLA 机器人以 20 ms 为周期汇集四个 worker 的视觉/状态结果，再生成最多 256 个临时 `ControlCommand`。逐对象 `new/delete` 会让 allocator 元数据、线程缓存和尾延迟进入控制路径。本练习的固定容量 `FrameArena` 让 worker 在同一帧内并发 bump 分配：生产者租约结束、所有 worker `join` 后，控制线程才可析构帧内受管 telemetry 并复用整块内存。容量不足必须同步失败，禁止在实时路径偷偷扩容到堆；对象不得跨过帧 reset。

## 概念回顾

本练习从 gRPC Core 的 Arena 提炼两个耦合机制。第一是并发 bump 分配：gRPC `Arena::Alloc()` 用原子 `fetch_add(memory_order_relaxed)` 在初始 zone 中递增偏移，超出后通过 `AllocZone()` 接入新 zone；这说明分配地址唯一性不需要总序，但资源统计与生命周期另有边界。为适应控制帧的容量可预测需求，本实现改成 CAS 预检再递增：避免固定 buffer 溢出后留下不可恢复 cursor，并明确仅支持 16 字节及以下对齐，不能把 gRPC 当前的对齐假设误说成通用规则。第二是受管对象生命周期：gRPC `ManagedNew()` 将对象节点用 CAS 链入 `managed_new_head_`，`DestroyManagedNewObjects()` 先 exchange 链表再析构，避免析构中产生新受管对象时漏清理。本练习保留该链表思想，并用 `Producer` RAII 租约和 closed-bit 状态机规定 reset 前必须无活跃生产者。C++ 原子内存序只约束可见性和同步；它不替代业务层 join，也不保证对象跨 reset 安全。Linux 上该类实现通常只依赖 CPU 原子而非 mutex/futex；若改成等待生产者释放，阻塞路径才可能进入 pthread mutex/condition variable 和 Linux futex，macOS 的内核机制不同。固定 arena 的取舍是低抖动与可观测容量上限，代价是容量规划、对过度对齐/抛异常构造的限制，以及必须把跨帧资源移到显式所有权队列。

## 知识图谱

`worker 获取 Producer` → 原子 state 增加活跃计数 → CAS 分配 16-byte slot → trivial 对象 `make()` 或非平凡对象 `managed_new()` → CAS 链入析构栈 → worker 释放租约 → 控制线程 `join` → closed-bit 独占 reset → exchange 析构链表 → cursor 清零。

子点一是“原子分配”：`memory_order_relaxed` 只用于 slot 唯一性，不能发布业务数据；子点二是“生命周期门”：closed-bit 与 `Producer` 计数阻止 reset 和新生产者交错。前置条件是所有对象属于同一帧，且 reset 由控制线程在 join 后执行。`ManagedNew` 链表的析构顺序是并发压栈顺序，不等于业务创建顺序；需要确定析构拓扑的资源不应依赖它。

GitHub 源码依据：实际读取 [grpc/grpc](https://github.com/grpc/grpc) commit [`0ce43f688351925b8fdec5f2ea75781b578fed3d`](https://github.com/grpc/grpc/tree/0ce43f688351925b8fdec5f2ea75781b578fed3d)，文件 [`src/core/lib/resource_quota/arena.h`](https://github.com/grpc/grpc/blob/0ce43f688351925b8fdec5f2ea75781b578fed3d/src/core/lib/resource_quota/arena.h) 的 `Arena::Alloc`、`New`、`ManagedNew`，以及 [`arena.cc`](https://github.com/grpc/grpc/blob/0ce43f688351925b8fdec5f2ea75781b578fed3d/src/core/lib/resource_quota/arena.cc) 的 `DestroyManagedNewObjects`、`ManagedNewObject::Link`、`AllocZone`。原实现服务 RPC 生命周期、配额和可增长 zone；本练习是受其启发的独立简化，不复制代码，删除配额/zone/上下文，换成固定容量和显式控制帧关闭。

## 编码练习

为 `FrameArena` 添加 `try_reset_after_join()`：当存在 `Producer` 时返回 `false` 而非抛异常；成功时保持 `managed_head_` 的 exchange 析构语义。增加两个测试：一个 worker 故意延迟持有租约，验证 reset 被拒绝；一个受管对象析构中再创建诊断对象，验证 reset 循环不会漏析构。说明为什么该诊断对象必须通过已知有效的 producer/专用清理阶段创建，而不能绕过 frame 生命周期。

## 文件说明

- `src/frame_arena.hpp`：固定容量原子 arena、Producer RAII、CAS 析构链表和 reset gate。
- `src/main.cpp`：4 worker 并发分配、受管析构、活跃生产者拒绝 reset 与 heap 对照基准。
- `CMakeLists.txt`、`run.sh`：C++17 构建与本机验证入口。

## 编译与运行

```sh
cd /Users/guhaoran/code/EveryDay/systems_practice/2026-09-14
./run.sh
../../scripts/format-cpp.sh

cmake -S . -B results/mac-sanitize-build -DCMAKE_BUILD_TYPE=Debug \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer'
cmake --build results/mac-sanitize-build
./results/mac-sanitize-build/frame_arena
```

## 正确性验证

程序必须打印 `workers=4`、`managed_destruction=PASS`、`reset_gate=PASS`：四个 worker 共构造 256 个 command；四个受管 telemetry 仅在 `reset_after_join()` 后析构；持有 Producer 时 reset 必须抛 `logic_error`。还应在目标系统用 TSan 检查扩展后的并发路径。这里没有 GPU/NPU 依赖，Mac CPU 可完整验证；heap 对照不是端到端控制延迟。

## 性能分析

先预热 20 次，再采样 100 次；每次单 producer 构造 256 个 32 字节 command。arena 时间包含租约、CAS bump 与 reset，不含构造 arena 的一次性 vector 分配；heap 时间包括同数 `new/delete`。记录 P50/P95、编译模式、worker 数和容量水位。四 worker 的正确性测试不是并发吞吐基准；若测量多 worker，应单列 thread 创建、调度和 cache-line contention。

## 实际运行结果

Apple Silicon Mac Release 实际通过 `workers=4`、`managed_destruction=PASS`、`reset_gate=PASS`。20 次预热、100 次单 producer 样本：arena P50/P95 为 **1.084/1.167 us**，heap 对照为 **12.875/13.25 us**，见 [Release 日志](results/mac-release-run/output.log)。ASan/UBSan Debug 同样通过，arena 16.292/20.042 us、heap 24.459/32.167 us，见 [Sanitizer 日志](results/mac-release-run/sanitize.log)；Sanitizer 数值不能与 Release 对比。完整范围见 [验证摘要](results/verification.md)；没有 GPU/NPU 数据。

## 工程注意事项

固定 16-byte 对齐是此练习的显式限制；含 AVX-512、DMA 或平台过度对齐对象要改接口与分配策略。`close_and_reset()` 析构函数路径不抛异常，业务路径应使用 `reset_after_join()` 获得违反协议的错误。CAS 链表只保证节点不会丢失，不提供创建顺序；受管对象析构不得等待已退出 worker。真正的实时系统还要为容量峰值、线程绑定、NUMA、缓存行、异常构造、跨帧 GPU fence 和取消请求制定独立策略。

## 工业故障与面试追问

工业故障：

1. 高峰帧超容量会抛 `bad_alloc`，表现为动作 chunk 缺失；记录 high-water mark，采用背压/降级而不是隐式 heap fallback。
2. reset 与仍活跃 worker 并发会产生 use-after-free，表现为偶发姿态/控制值损坏；Producer 计数、join 日志和 TSan 是最小诊断，修复为帧关闭协议。
3. 把 relaxed slot 分配当成数据发布会造成读到未初始化 command；用 release/acquire 的队列或 join 发布数据，而不是强化 allocator 内存序。
4. 受管析构依赖创建顺序会在并发下失败；记录资源依赖图，改为显式关闭顺序或独立所有权对象。

面试追问清单：

1. 为什么 gRPC `Arena::Alloc` 的 bump 计数可用 relaxed，而对象发布不能只用 relaxed？
2. `fetch_add` 后检测固定池溢出与 CAS 预检各有什么状态一致性差异？
3. placement new、析构、`delete` 与 arena 所有权分别由谁负责？
4. `ManagedNew` 的 CAS 链表为何不保证业务析构拓扑？
5. Producer 计数如何避免 reset 与新生产者竞争？为什么仅检查 active==0 不够？
6. 何时用 thread-local arena，何时用共享 arena，mutex/futex 会在什么层级介入？
7. 实时控制中为什么容量不足时的失败策略比“自动扩容”更重要？

## 自测问题

若视觉 worker 交给 GPU 的 buffer 必须在异步 fence 完成后才可析构，而控制帧仍需按 20 ms 尝试 reset，你会如何把 Producer 租约、fence 回调、超时降级和跨帧所有权组合成不会泄漏、不会 use-after-free 且容量有上限的协议？
