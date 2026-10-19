# 2026-10-19 两篇论文：剪枝后恢复与约束下的配置选择

两篇为现成阅读材料，均实际读取arXiv一手HTML的方法与实验选段，并读作者实现；没有下载模型/数据或复现完整系统。

1. [Structural Pruning of Large Vision Language Models: A Comprehensive Study on Pruning Dynamics, Recovery, and Data Efficiency](01-vlm-pruning/README.md)：2026-04-27的扩展研究，承接作者2025工作，不能说机制首次在2026提出。核心收获是剪枝评分与恢复训练分开验收；本地独立例子包含200次真实projector更新。
2. [MetaKV: Adaptive KV Cache Compression for Constrained LLM Inference](02-metakv/README.md)：2026-09-07预印本。核心收获是预测可行不等于实际满足预算，且论文与公开代码的fallback公式不同；本地反例实际验证了选择翻转。

两例仅Python标准库CPU数值/策略实验，无作者完整训练、LLM任务精度、GPU/NPU/Thor性能复现。[主课](../../daily/2026-10-19/README.md)。
