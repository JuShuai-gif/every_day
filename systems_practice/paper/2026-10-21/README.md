# 2026-10-21 两篇论文：蒸馏梯度与校准分布的边界

1. [Apertus LLM Family Expansion via Distillation and Quantization](01-apertus/README.md)：稀疏教师概率没有重新归一化时，梯度必须保留概率质量；独立INT4 QDQ示例实际更新160步，不能称为压缩大模型复现。
2. [Influence-Inspired Spectral Rotations for Extreme Low-Bit LLM Quantization](02-spectral/README.md)：Hadamard旋转与校准能量缩放耦合；独立u2真实打包示例在同分布改善、偏移分布退化，且小矩阵元数据使存储比FP16更大。

两篇均实际读一手全文选段和作者代码，首发均在180天内；按去版本arXiv ID去重。以下是已写好可运行材料，不增加必做作业。作者完整训练/评估、GPU与Thor性能未复现；原始结果与来源分别归档。10月20日草稿保留，本日重新阅读并运行。[主课](../../daily/2026-10-21/README.md)。
