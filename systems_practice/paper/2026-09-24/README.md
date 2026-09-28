# 2026-09-24 · 两篇论文补课

实际阅读与运行2026-09-28，主课之外的现成阅读材料，不另加作业。

- [Breaking the Compression Barrier: Cross-Architecture Compression Boundary Learning via Reverse Regrowth](01-bridge/README.md)：先越过剪枝崩溃点，再从损坏严重的层恢复关键连接；论文用层表征相似度筛选和策略梯度分配恢复预算。离散二阶准确率差用于识别性能骤降。
- [A Hardware-oriented Approach for Efficient Bayesian Inference Computation and Deployment](02-bayes/README.md)：把不同形状的张量收缩并成规则批次，或展平并放入块对角矩阵；用分组限制填零开销。合并两块新增零元素数为r1*c2+r2*c1。

两篇独立小例子实际运行；完整模型/作者代码/Thor验收边界分别见各自source与verification。
