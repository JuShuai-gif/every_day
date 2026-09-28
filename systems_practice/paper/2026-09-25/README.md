# 2026-09-25 · 两篇论文补课

实际阅读与运行2026-09-28，主课之外的现成阅读材料，不另加作业。

- [Prune Once: Retraining-Free Task-Agnostic Pruning for Vision-Language Models](01-porta/README.md)：用校准特征方差而非单看均值幅度衡量通道信息，权重分数Sij=Var(Xj)*abs(Wij)，结合输出方差分配层稀疏率。
- [TwinQuant: Learnable Subspace Decomposition for 4-Bit LLM Quantization](02-twinquant/README.md)：把W拆成UV+R，并用可逆G以及全局正交Q重新参数化，使两个分支和激活的量化误差共同下降；浮点等价并不保证量化后等价。

两篇独立小例子实际运行；完整模型/作者代码/Thor验收边界分别见各自source与verification。
