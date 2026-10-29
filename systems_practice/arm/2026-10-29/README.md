# 2026-10-29 ARM source04：相邻算子布局与版本化分派

相机预处理后的行归约必须让 NEON 与 scalar 共用 `ptr+n`、尾部不越界的布局合同，再按能力安全回退。实际阅读 llama.cpp `7aca0d2e8d92b56911233b822db01f9fbb1ae50` 的 `ggml/src/ggml-cpu/ggml-cpu.c` 注册/能力分派；本例保留“能力选择+尾部 scalar”，省略 NUMA 和完整 backend registry。`src/main.cpp` 以 C++17 `vld1q_f32/vaddvq_f32`（AArch64）或 scalar fallback 验证 n=7、n=0。Mac 实测通过；没有 RK3588/Thor 板、PMU 或 E2E 推理数据，不能外推 NEON 收益。故障链：尾部越界→ASan/边界测试；错误能力宣称→启动时 capability 查询与回退。追问：为什么不能把 `sizeof(void*)` 当作 SIMD 能力？向量尾部如何证明？布局 stride 如何传给相邻算子？
