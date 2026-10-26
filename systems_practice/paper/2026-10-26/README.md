# 2026-10-26 两篇论文：保留低精度缓存与选择性淘汰

- [Minima-KV: Retention-Preserving KV Cache Compression with Mixed-Format Paged Attention](01-minima/README.md)：稳定合并不同分区的attention；保留内容不代表固定开销或提速。2026-08-24首发，v1预印本。
- [CompressKV: Semantic-Retrieval-Guided KV-Cache Compression for Resource-Efficient Long-Context LLM Inference](02-compress/README.md)：用选择的检索head指导token保留；分布变化后仍可能遗漏关键内容。2026-06-23首发，v1预印本。

均在180天窗口内，已按无版本arXiv ID核对现有进度，无重复。两篇一手全文的方法/实验选段已读；CompressKV作者选定实现已读。两个Python标准库独立示例实际运行通过，不是作者模型/设备复现。不增加每日强制作业或自测。
