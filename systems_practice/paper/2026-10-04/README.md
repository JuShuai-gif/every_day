# 2026-10-04 两篇论文：交互感知剪枝与定长KV编码

- [Higher-order pruning of experts in mixture-of-experts language models（HOPE）](01-hope/README.md)：联合删除专家的代价不等于单个代价相加；四专家独立枚举已运行，展示校准改善与分布变化退化。
- [D-Quant: Driftable Entropy Coding for KV Cache Quantization](02-dquant/README.md)：用失真换取每token固定编码预算；独立前缀码例子实际18→16bit、误差0.7→2.7，字节流往返验证通过。

两篇分别首发2026-09-16/17，位于180天范围，索引按无版本arXiv ID去重。实际阅读一手HTML方法/实验章节；没有下载大模型，也未完成作者模型/设备复现。它们是现成阅读材料，不增加每日必做作业。[主课](../../daily/2026-10-04/README.md)。
