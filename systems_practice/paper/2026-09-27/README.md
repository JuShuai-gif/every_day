# 2026-09-27 · 两篇论文补课

实际阅读与运行2026-09-28，主课之外的现成阅读材料，不另加作业。

- [Efficient Quantization-Aware Distillation with Cross-Modal Alignment for Edge Vision–Language Models](01-edge-distill/README.md)：以冻结教师作为量化学生的语义锚，联合关系蒸馏与对称InfoNCE；非RGB查询RGB键值做跨模态注意力。仅关系距离无法约束整体语义旋转。
- [BASC: Behavior-Aligned Quantization and Pruning for Low-Bit Spiking Neural Networks](02-basc/README.md)：LIF膜电位的阈值使小权重变化改变放电时间。TSC用时间任务损失学习scale，BIC重评剪枝边界附近通道间的相互作用。权重误差最小不一定对应行为误差最小。

两篇独立小例子实际运行；完整模型/作者代码/Thor验收边界分别见各自source与verification。
