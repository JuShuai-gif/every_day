# Towards Green AI: Evaluating Energy Efficiency for Quantized LLM Inference

论文 [arXiv:2610.17531](https://arxiv.org/abs/2610.17531), v1 2026-10-13，已读摘要、元数据和全文入口。作者比较多种 weight-only PTQ 在 H100、A6000、A100、L4 上的准确度、延迟与能耗，报告长输入/短输出和 batch 对能效的影响，并指出 fused int8 实现的能耗优势。独立示例只展示质量门槛后的能耗归一化，不冒充论文的 GPU 实测或任务分数。
