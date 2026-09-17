# 2026-09-14：C++ 工程知识——实时 VLA 控制帧的确定性内存池

## 工业场景

双相机 VLA 机器人在每个 20 ms 控制周期内，将视觉特征、位姿和动作 chunk 组装为临时 `ControlCommand`。若热路径对每个小对象分别 `new/delete`，通用分配器锁竞争、碎片和尾延迟会污染控制预算。本练习实现一个单线程、单帧独占的 4 KiB `FrameArena`：一帧最多 256 个 `ControlCommand`，对象在帧末统一 reset；64 字节对齐的 `CameraToken` 模拟 SIMD/缓存友好的视觉元数据。约束是池容量、析构登记容量预先给定，超限同步失败；它不是跨帧对象仓库，也不是通用线程安全 allocator。

## 概念回顾

内存池的价值不是“永远比堆快”，而是把热路径的分配策略变成可预测的容量契约。这里的单调 arena 在初始化阶段申请一块 `std::byte` 缓冲区，帧内只把 cursor 按 `std::align` 调到满足 `alignof(T)` 的地址，再用 placement new 开始对象生命周期；它不会逐个释放，因此分配接近常数时间、内部碎片仅来自对齐 padding。与此耦合的第二个机制是资源所有权：arena 拥有存储，不拥有普通裸指针的可跨帧语义；非平凡对象必须登记析构函数，`reset()` 逆序调用后才能复用字节。构造函数抛异常时，代码回滚 cursor，避免半个对象吞掉容量；析构登记满则在分配前失败。C++ 标准只规定对象生命周期、对齐和库同步语义，并不规定 `new` 的具体实现。常见 Linux 分配器会维护线程缓存、arena 和系统调用边界；mutex 也可能在无竞争时用户态原子操作、竞争时经 futex 阻塞，但这些是实现细节，不能推断到 macOS 或所有 allocator。实际机器人进程应让每个 worker 持有独立 pool，或在外层用明确的同步/所有权协议，绝不能把这个无锁类同时交给采集和控制线程。`std::pmr::monotonic_buffer_resource` 是生产中可优先评估的标准 C++17 方案；本实现保留析构登记和容量失败，专门暴露其正确性条件。

## 知识图谱

`控制帧开始` → 预分配 `std::byte` 存储与析构表 → `std::align` 计算物理地址 → placement new 开始 `T` 生命周期 → 返回**不拥有**的借用指针 → 帧末逆序析构 → cursor 归零。

两个子点的连接是：对齐只解决“地址能否安全放置对象”，不解决“何时销毁对象”；RAII/析构表解决生命周期，但不让指针跨过 `reset()` 继续有效。前置条件是对象都属于同一控制帧、最大字节数和非平凡对象数可估计、同一 arena 同时只被一个线程访问。`new/delete` 对照测的是每帧 256 个小对象的 CPU 分配路径；不包含相机、GPU 或 NPU 时间，也不能外推到不同 allocator 或设备。

来源与边界：本练习是依据 C++17 `std::align`、placement new 和对象生命周期规则的独立最小实现，并未拷贝开源项目代码；因此不虚构项目版本/函数归因。生产候选可比较标准 `std::pmr::monotonic_buffer_resource`，但本练习故意不引入 upstream 分配器或隐藏 fallback，以便观察容量、对齐和析构契约。

## 编码练习

阅读并扩展 `src/frame_arena.hpp`：为 `FrameArena` 增加一个 `mark()/rewind(mark)` 接口，使动作 chunk 解码失败时能回收本批临时对象；要求禁止跨过仍存活的非平凡对象，补充一个失败回滚测试。保持固定容量、对齐检查、构造异常回滚与逆序析构。不要把 `FrameArena` 改成全局单例或用 mutex “修复”跨线程误用；先设计对象所属帧与线程的边界。

## 文件说明

- `src/frame_arena.hpp`：固定容量单调 arena、对齐分配、placement new、析构登记和 reset。
- `src/main.cpp`：对齐、析构顺序、OOM 状态完整性与 heap 对照基准。
- `CMakeLists.txt`：C++17 和警告选项；`run.sh`：Mac 本机编译运行入口。

## 编译与运行

```sh
cd /Users/guhaoran/code/EveryDay/systems_practice/2026-09-14
./run.sh

# 格式化本仓库所有 C/C++/CUDA 源码
../../scripts/format-cpp.sh

# 可选：额外做地址/未定义行为检查
cmake -S . -B results/mac-sanitize-build -DCMAKE_BUILD_TYPE=Debug \
  '-DCMAKE_CXX_FLAGS=-fsanitize=address,undefined -fno-omit-frame-pointer'
cmake --build results/mac-sanitize-build
./results/mac-sanitize-build/frame_arena
```

## 正确性验证

必须打印四项 PASS：`CameraToken` 地址满足 64 字节对齐；两个 `DestructionProbe` 按 2、1 逆序析构；`reset()` 后已用字节为 0；32 字节小池请求 64 字节对齐对象时抛出 `std::bad_alloc` 且 cursor 仍为 0。额外边界是构造异常和析构表耗尽：扩展练习应证明二者都不留下可见的半对象状态。Mac 可完整验证本 C++ CPU 示例，无 GPU/NPU 依赖。

## 性能分析

先各预热 20 帧，再采样 100 帧；每帧构造 256 个 32 字节 `ControlCommand`。arena 时间从第一个 bump 分配到 reset 返回，排除池初始化；heap 时间包括同样数量的 `new/delete`。记录 P50/P95 和编译模式。这个微基准仅用于观察本机 CPU 分配路径，不能声称控制系统端到端收益；生产还需采集 allocator contention、页面缺失、CPU 频率、控制周期 P99 和内存上限。

## 实际运行结果

Apple Silicon Mac 上 Release 实际通过 4 项正确性检查。20 次预热、100 次采样、每帧 256 个对象：arena P50/P95 为 **2.75/3.25 us**；heap `new/delete` 对照为 **11/13.083 us**，见 [Release 日志](results/mac-release-run/output.log)。ASan/UBSan Debug 同样通过，arena 11.958/12.041 us、heap 23.875/31.583 us，见 [Sanitizer 日志](results/mac-release-run/sanitize.log)；Sanitizer 数值不与 Release 比较性能。完整范围见 [验证摘要](results/verification.md)。本练习不需要 CUDA、TensorRT、RKNN 或模型，故没有 GPU/NPU 数据。

## 工程注意事项

不要在 `reset()` 后解引用旧指针，即使字节内容暂时未变；那是生命周期错误。对象含文件句柄、锁、CUDA/RKNN 资源或跨帧回调时，必须确认逆序析构时机正确，必要时改用显式所有权队列。固定池在容量不足时应由上层执行降级、丢帧或背压，而不是悄悄 fallback 到堆破坏实时性。多线程版本首先考虑每线程 arena；共享 arena 要明确互斥、批次边界和析构期间禁止访问的协议。对过度对齐类型、缓存行伪共享、NUMA、allocator 实现差异都要在目标系统实测。

## 工业故障与面试追问

工业故障：

1. 容量估计偏小会在高峰帧触发 `bad_alloc`，表现为控制命令缺失；记录每帧 high-water mark，采用背压/降级或扩大固定容量。
2. 忘记登记非平凡析构会泄漏句柄或延迟释放资源，表现为长跑后 FD/GPU 资源耗尽；用析构计数和泄漏检测验证，或禁止此类对象进入帧池。
3. 跨线程 reset 与读取会造成悬垂生命周期和数据竞争，表现为偶发控制值损坏；用 TSan 和帧所有权日志定位，改为 thread-local pool 或队列移交。
4. 忽略 `alignof(T)` 会在 SIMD/原子对象上触发未定义行为或性能骤降；加入地址断言并通过 sanitizer/目标机测试验证。

面试追问清单：

1. `malloc`、`operator new`、placement new 和 `std::pmr` 分别负责什么？
2. 为什么 `std::align` 后不能只累加 `sizeof(T)`，而要考虑 padding？
3. arena reset 时为何要逆序析构？平凡析构对象能省略登记的条件是什么？
4. 构造函数抛异常时，bump pointer 和析构表应如何保持一致？
5. Linux 的 allocator 线程缓存和 futex 与 C++ 内存池/线程安全之间是什么关系，哪些不是标准保证？
6. 何时选择每线程 pool，何时选择共享 pool 加锁，如何设计容量不足时的背压？

## 自测问题

若动作 chunk 的对象中混入需要异步 GPU 完成后才能析构的 buffer，而控制线程仍要在 20 ms 边界 reset arena，你会怎样划分所有权、完成信号和 pool 生命周期，既避免 use-after-free 又不让热路径退化为无界堆分配？
