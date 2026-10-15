# 2026-10-15 两篇论文：预算与误差代理的边界

1. [MultiAlloc: Budget-Aware Precision Allocation for KV Cache Quantization](01-multialloc/README.md)：层位宽与高精度token争用同一预算，不能漏记metadata，也不能把预算当进程峰值。
2. [Revisiting Error Feedback for Model Quantization](02-feedback/README.md)：trace代理达到理论下界，不保证有限量化格的实际误差更小。

两篇均首发2026-10-13，读取v1一手方法/实验/局限选段，未核实同行评审状态，按预印本处理。标准库独立机制例已运行，非完整作者模型复现；第二篇首版假设失败及修订证据保留。GPU与Thor均未运行。
