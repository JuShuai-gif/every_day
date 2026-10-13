# 2026-10-13 两篇论文：压缩预测的适用域与部署分布

- [Capability Scaling-Down Laws for LLM Compression](01-scaling/README.md)：共享密度响应可以减少测量，但跨状态/跨任务要检验适用域，预测精度不等于选择收益。首发2026-10-01，v1。
- [P4Q: Co-designing Token Pruning and Quantization for Vision-Language Model Acceleration](02-p4q/README.md)：选择器看低位扰动，校准看实际保留分布。首发2026-09-28，v1。

两篇arXiv预印本的一手全文方法/实验选段已读，不宣称同行评审通过。两份Python标准库独立小例已运行；并非完整模型复现，也没有GPU性能实测。P4Q简化例在正常评估分布出现误差退化，按原始结果保留。没有额外必做作业。
