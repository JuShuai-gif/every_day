# 2026-10-18 两篇论文：scale位置与实际执行码本

1. [RoleQ: Role-Aligned Scales for Converting Language Models to Ternary](01-roleq/README.md)：scale应与reader/writer功能单位对齐；小例子比较行/列粒度，不能用权重误差代替知识保留。
2. [Fractional Power-of-Two Quantization for Efficient and Effective Multiplier-Free LLM Inference](02-fpot/README.md)：校准需要匹配真实近似码本；整数shift-add还须定义舍入与累加位宽。

两篇均首发2026-10-15，本次读v1全文中的方法/实验/局限相关节，作者实现仓库均未核实。Python标准库独立示例已运行，分别保存44B真实打包文件于忽略build、验证文本于results。不是完整模型复现、没有GPU/NPU速度结论。FPoT例子保留当前评估集上近似码本调参退化，论文不等于每个小样本必有收益。
