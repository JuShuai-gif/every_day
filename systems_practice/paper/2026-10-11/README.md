# 2026-10-11 两篇论文：权重冗余与联合压缩决策

| 一手论文 | 当期收获 | 本机验证 |
| --- | --- | --- |
| [Forward-Free LLM Depth Pruning via Weight Redundancy](01-wrp/README.md) | 输出空间Gram消除中间通道排列影响，但不能证明实际输入响应可替代 | 独立3×3代数例：相似度≈1而输出平方误差41 |
| [Joint Structural Pruning and Mixed-Precision Quantization for LLM Compression](02-toga/README.md) | 剪枝与位宽共同决定预算，联合优化未必每例都优于顺序法 | 独立枚举：本例同解/同误差，偏移集误差显著增大 |

两篇均在180天内首发，按arXiv无版本ID去重。已读各自v1正文方法/实验/结论选段及元数据，不把摘要当全文，也不声称逐字阅读所有参考文献和附录。未确认同行评审发表状态，按预印本处理；未找到可验证作者实现，不调用猜测API。标准库示例已运行，不是作者算法完整复现，不增加主课必做题。
