# 2026-09-29 每日两篇论文

1. [Train Overcomplete, Deploy Compact: Scaling Recovery Capacity for Structured LLM Pruning](01-overrep/README.md) — 训练时扩展恢复模块，退火为线性后精确合并，避免部署时保留辅助分支。
2. [Fine-Tuning Low-Bit Models with Gradient in Quantized Code Space](02-gradcodes/README.md) — 梯度引导候选，按真实离散状态损失决定量化码更新。

两篇分别首发2026-09-07和2026-08-31，均在180天窗口内，未与历史arXiv ID重复。已读一手全文中的方法与实验部分；两套Python标准库小例子实跑，含真实参数更新。没有下载大模型、训练作者模型或测板端性能。OverRep作者仓库目前仅见许可证；GradCodes训练入口已读，但核心实现/依赖和许可证仍待补审计，不能把仓库存在当完整复现。
