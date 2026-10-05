# 2026-10-05 两篇论文：精度预算与可伸缩模型

- [FlexPosit: Tunable Fractional Precision for LLM Inference Accelerators](01-flexposit/README.md)：位宽预算要与硬件窗口对齐；独立Posit小码本/scale搜索/预算实验已运行，作者量化和硬件实现未能读取，不声称复现。
- [Telescopic Language Models](02-tlm/README.md)：随机前缀监督加full anchor；独立线性模型真实训练2000步，作者仓库代码尚未发布，未复现语言模型。

两篇原文选定方法/实验章节已读，论文ID与首次日期已核实去重。只提供现成附加代码，无额外作业。实测均为CPU标准库数学实验，无GPU/板端性能，完整复现在backlog。
