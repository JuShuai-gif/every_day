# 2026-09-28 两篇论文：减少推理工作量与公平量化比较

- [Rift：Exploiting answer-invariant redundancies in satellite imagery for efficient VLM inference on edge](01-rift/README.md)：先保留相关图块，再按条件准确率与成本分配 token。合成例子实际运行，展示分布变化导致误删；未训练作者预测器、未实测设备能耗。
- [A Unified Rate-Distortion Perspective on Vector, Product, and Scalar Quantization](02-rate-distortion/README.md)：在固定输入分布和码率下比较量化结构。独立 Lloyd 小例子实际更新码本；码本利用率相同仍可能有不同重建误差。

两篇都是2026年9月首发的 arXiv v1，当日核验元数据与一手全文对应方法、实验及局限。没有独立确认同行评审录用。小例子是附加阅读，不增加主课必做作业。
