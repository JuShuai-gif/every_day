# 2026-10-14 两篇论文：压缩预算与量化误差目标

- [DBW：Differentiable Bit-Widths: Co-optimizing Pruning and Quantization via SVD for Ultra-Efficient LLM Compression](01-dbw/README.md)，2026-10-05首发v1。核心收获：分量0-bit剪枝与量化预算应共同决定，硬化还要修补整数预算。
- [TaSQ：Tailoring the Quantization Space for 1-Bit KV Cache Compression](02-tasq/README.md)，2026-10-02首发v1。核心收获：key重建误差与QK误差不同，码本和scale成本使“1bit”不等于完整缓存1bit。

两篇都在180天窗口内，按无版本arXiv ID去重。论文方法/实验章节和指定作者源码已阅读，Python标准库独立例子已运行；没有完整模型、训练或Thor复现，不把作者报告视为本机结果。所有运行命令在各子目录README，不增加强制作业。
