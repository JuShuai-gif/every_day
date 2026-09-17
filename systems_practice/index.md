# 工业级 CUDA、C++ 与 Edge AI 每日练习

每天北京时间 **08:30** 在 EveryDay 项目运行。完整要求见 [练习规范](PRACTICE_SPEC.md)。同一天追加内容使用独立 session 目录，历史文件不覆盖。

当前 Mac 无可用 CUDA GPU：GPU 主题照常轮换，完整保留目标代码、构建与验证命令；本机可验证部分与 Linux NVIDIA GPU / Jetson 待验证部分分别记录。

轮换顺序：CUDA Kernel → TensorRT → RK3588 NPU / RKNN → PTX / CUTLASS → GPU 访存优化 → GPU 体系结构 → C++17 并发 → CPU 体系结构 → ARM SIMD / NEON → 边缘端部署 → C++ 工程知识 → 循环。

2026-09-16 扩展为 11 个方向：新增 RK3588 NPU / RKNN 与 ARM SIMD / NEON。NPU 主题保留完整转换和板端代码；ARM SIMD 独立选题，优先借鉴 ggml、ncnn 的 CPU 实现并在 Apple Silicon Mac 本机验证，RK3588 为可选移植场景。

| 日期 / 会话 | 主主题 | 核心知识点 | 代码路径 | 验证状态 | 性能数据与证据 |
| --- | --- | --- | --- | --- | --- |
| [2026-09-14](2026-09-14/README.md) | C++ 工程知识（补充历史） | gRPC Arena 启发的原子 bump、受管析构链表与 Producer/reset 生命周期门 | [frame_arena.hpp](2026-09-14/src/frame_arena.hpp)；[并发测试与基准](2026-09-14/src/main.cpp) | Mac Release 与 ASan/UBSan 实际编译运行通过；4 worker、受管析构和 reset gate 均通过 | 20 预热+100 次，256 对象：Release arena P50/P95 1.084/1.167 us，heap 对照 12.875/13.25 us；仅 CPU 微基准。[日志](2026-09-14/results/verification.md) |
| [2026-09-15](2026-09-15/README.md) | CUDA Kernel | 双相机 UINT8 NHWC → FP16 NCHW 归一化融合；中间张量消除；分离 Kernel 与端到端计时 | [preprocess.cu](2026-09-15/src/preprocess.cu)；[cpu_check.cpp](2026-09-15/src/cpu_check.cpp) | CPU Release 编译、4 种形状及负 Batch 校验通过；ASan/UBSan 通过。CUDA/GPU 因缺依赖未验证 | CPU 参考 `[2,224,224,3]`：p50 0.159875 ms、p95 0.275375 ms，10 次预热 + 50 次采样；GPU 数据未验证。[实测日志](2026-09-15/results/run-2m3zbaM3/output.log) |
| [2026-09-16](2026-09-16/README.md) | TensorRT | 小 Batch 动态 Shape/Profile 与缓冲区契约；同 Shape 复用练习；分离 CPU 提交、GPU 推理区间和 E2E | [trt_dynamic.cpp](2026-09-16/src/trt_dynamic.cpp)；[cpu_check.cpp](2026-09-16/src/cpu_check.cpp) | Mac CPU Release 与 ASan/UBSan 实际编译运行通过；6次变值帧/Shape、非法输入通过。GPU 配置因缺 nvcc 失败，TensorRT 目标编译/执行/精度未验证 | CPU B=2 参考 p50 0.000001584 ms、p95 0.000001708 ms/次；10组预热+100组采样，每组1000次；GPU Kernel/E2E/功耗未验证。[日志](2026-09-16/results/cpu-bEqMZkQH/output.log)；[失败与范围](2026-09-16/results/verification.md) |
| [2026-09-17](2026-09-17/README.md) | RK3588 NPU / RKNN | Runtime `size_with_stride`/`w_stride` 物理输入绑定；紧凑 UINT8 NHWC 逐行写入与 RAII 生命周期 | [rknn_stride_binding.cpp](2026-09-17/src/rknn_stride_binding.cpp)；[CPU 检查](2026-09-17/src/preprocess_cpu.cpp) | Mac CPU Release 与 ASan/UBSan 实际编译运行通过；RKNN 转换与 RK3588 NPU 未验证（无 Toolkit2、板卡、Runtime/驱动和 `.rknn`） | CPU 辅助 Release 平均 0.0856833 us/次（1,000 预热+10,000 次）；无 NPU 性能数据。[日志与范围](2026-09-17/results/verification.md) |

下一主主题：**PTX / CUTLASS**。不得因本机缺少 GPU 而跳过代码生成；依规范生成目标环境命令并记录验证边界。

`2026-09-14` 为用户要求补充的历史 C++ 练习，不改变当前轮换位置。
