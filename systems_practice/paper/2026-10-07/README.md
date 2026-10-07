# 2026-10-07 两篇论文：预算公平与发布后验证

- [Small LLMs: Pruning vs. Training from Scratch](01-prune-budget/README.md)：剪枝初始化的收益随预算口径变化。标准库小例真实训练更新，更多步数使排序反转；未复现LLM。
- [Quantization-Triggered Backdoors…Validation–Deployment Gap](02-deployment-gap/README.md)：应验证量化/重载后的最终产物，阈值margin可揭示均值误差隐藏的风险。防御性小例通过，无后门训练/作者模型复现。

都已读原文指定章节和表格；第一篇作者具体实现访问失败，第二篇说明完整产物不公开。两例均可直接运行，无安装/模型下载，不增加主课作业。GPU/NPU/E2E性能均未验证。
