# 2026-09-22 两篇论文：动态量化修正与专家容量分配

| 论文 | 今日收获 | 复现难度与本机范围 |
| --- | --- | --- |
| [REAL-Q: E2E LLM Quantization via Dynamic Gradient Descent](01-real-q/README.md) | 量化过程中冻结已处理列，以保留通道耦合的损失修正剩余列 | 完整复现难；标准库梯度/Adam机制例子已跑通 |
| [ESTS at WMT26: Routing-Informed Expert Pruning for Model Compression](02-ests/README.md) | 用路由分歧分配保留容量，路由与专家必须同步裁剪；参数下降不自动带来算量下降 | 完整复现难；52容量案例、真实FP32字节缩减例子已跑通 |

两篇首发距今天均不超过180天；独立去重。示例为现成阅读材料，不增加今日主练习作业。实际运行仅 Python3.9.6 标准库 CPU，没有模型下载、GPU/NPU实测或完整论文任务指标复现。原文、版本、作者仓库范围及日志在各入口中列出。
