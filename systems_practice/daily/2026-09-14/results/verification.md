# 重写版验证摘要

- 2026-09-17（Asia/Shanghai）Apple Silicon Mac Release 实际配置、编译和运行通过：4 worker 并发构造 256 个 command，4 个受管对象在 reset 后析构，活跃 Producer 时 reset 被拒绝。20 次预热后 100 次单 producer 样本：arena P50/P95 为 **1.084/1.167 us**；heap `new/delete` 对照为 **12.875/13.25 us**，每次 256 个对象。
- ASan/UBSan Debug 实际通过，同一正确性结果；arena P50/P95 **16.292/20.042 us**，heap 对照 **24.459/32.167 us**。Sanitizer 只用于内存检查，不能同 Release 比较性能。
- 实际读取 gRPC Core commit `0ce43f688351925b8fdec5f2ea75781b578fed3d` 的 `src/core/lib/resource_quota/arena.h` 与 `arena.cc`；README 标明使用的 `Alloc`、`ManagedNew`、`DestroyManagedNewObjects`、`ManagedNewObject::Link`、`AllocZone` 和独立简化边界。
- 结果仅是本机 CPU 微基准：不含四 worker 吞吐、线程创建、相机/GPU/NPU、真实控制端到端时延、内存压力或目标 Linux allocator。无 CUDA/RKNN 依赖。
