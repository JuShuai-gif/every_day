# 验证摘要

- 2026-09-17（Asia/Shanghai）在 Apple Silicon Mac 上实际配置、编译并运行 Release。4 项正确性检查全部通过：64 字节对齐、逆序析构、`reset()`、OOM 状态回滚。20 次预热后 100 次采样：arena P50/P95 为 **2.75/3.25 us**，heap `new/delete` 对照为 **11/13.083 us**，每帧各构造 256 个 `ControlCommand`。
- ASan/UBSan Debug 构建实际通过，正确性输出一致。其 arena P50/P95 为 **11.958/12.041 us**，heap 对照为 **23.875/31.583 us**；Sanitizer 数值仅用于内存检查，不与 Release 性能比较。
- 该结果只覆盖本机 CPU 的分配与析构微基准，不含双相机、GPU/NPU、锁竞争、真实 allocator 峰值压力或控制系统端到端延迟。无需 CUDA/RKNN 工具链。
