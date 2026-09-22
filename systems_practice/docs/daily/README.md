# 每日知识轮换说明

每天一个主主题，顺序为 CUDA Kernel → TensorRT → RK3588 NPU/RKNN → PTX/CUTLASS → 量化 GEMM → GPU 访存优化 → GPU 体系结构 → C++17 并发 → CPU 体系结构 → ARM SIMD/NEON → 边缘端部署 → C++ 工程知识。

课程放在 `systems_practice/daily/YYYY-MM-DD/`；同日额外主课放 `session-NN/`。每课保留一个编码练习及一个自测问题，并包含 README、代码、构建/运行入口和验证记录。具体要求见[完整规范](../PRACTICE_SPEC.md)。

[主课索引](../../daily/index.md)记录实际轮换进度。每日量化、ARM 和论文分别在独立文件夹递进，通过链接互相引用。主方向中的“量化 GEMM”仍是主课，放在 daily/，与 quantization/ 的每日方法栏目区分。
