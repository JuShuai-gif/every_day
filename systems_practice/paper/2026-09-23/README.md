# 2026-09-23 · 两篇论文：恢复量化学生与Fisher路径剪枝

1. [Quantization-Aware Healing: A Practical Recipe for Recovering Compressed, 4-Bit LLMs](01-qah/README.md)：压缩后蒸馏该选哪个教师；本地例子有真实STE参数更新，并保留未支持论文趋势的结果。
2. [Optimal Pruning for Neural Architectures using Fisher Information Distances](02-fisher-distance/README.md)：沿参数到零的路径重估Fisher；区分论文RMS分数与真正长度积分。

两篇均读arXiv v1一手HTML全文中的方法、结果和局限，首发分别2026-08-21、2026-09-14，均在180天内；未确认同行评审发表。两个Python标准库小例子实际运行，完整作者实验、模型部署和设备性能均未复现。源码获取与可用性分开记录，不安装依赖/下载权重。
