# 2026-10-02 两篇论文：状态精度分配与低位网格优化

本日正式两篇为DAMP和GSQ，各有独立可运行机制例；标准库CPU例已运行，不是原模型完整复现。

| 论文 | 核心收获 | 已验证范围 |
| --- | --- | --- |
| [DAMP: Decay-Aware Mixed-Precision Recurrent-State Quantization](02-damp/README.md) | 状态误差的长期传播取决于能量与衰减；head内相同衰减可能不改变排序 | 脉冲累积与排名独立CPU例，非作者模型 |
| [GSQ: Highly-Accurate Low-Precision Scalar Quantization for LLMs via Gumbel-Softmax Sampling](03-gsq/README.md) | 训练离散网格logits/scale后仍需硬化验收；噪声重放影响梯度 | 600步独立小例、有限差分、真实2bit打包 |

[DAMP代码](02-damp/example.py)、[GSQ代码](03-gsq/example.py)。阅读版本与原始结果均在各自目录。首轮生成的[Debias-SparseGPT补充](01-debias/README.md)与10月1日已登记论文重复，保留来源/结果但不计今日新论文、不推进去重列表。
