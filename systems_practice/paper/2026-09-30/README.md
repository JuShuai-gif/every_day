# 2026-09-30 两篇论文：状态存储与压缩决策的失败边界

两篇均在近180天内首发，与历史arXiv去重；均为预印本，不推断已同行评审。今天优先选能纠正部署误判的机制，作者代码公开情况不足已单列，不伪造源码阅读。

| 论文 | 核心收获 | 本机现成例子 |
| --- | --- | --- |
| [When Quantization Breaks Memory: Recurrent-State Write-Back in Low-Precision Temporal Inference](01-writeback/README.md) | 状态回写是时序计算的一部分；微小更新可被逐步舍入吞掉 | 60步独立标量反馈、真实nibble存储边界检查通过 |
| [When Compression Scores Cannot Decide: Information Boundaries for Group-Robust LLM Pruning](02-group-risk/README.md) | 稳定的局部分数不足以决定完整模型最差组风险 | 同观测反转与729组slack恒等式检查通过 |

两个Python标准库示例属于附加阅读，无第二个编码作业；未训练或运行作者模型，无GPU/NPU/E2E或模型任务精度复现。
