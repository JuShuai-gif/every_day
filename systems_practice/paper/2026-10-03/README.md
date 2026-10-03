# 2026-10-03 · 校准泛化与剪枝后的正交补偿

今天两篇首次公开均在180天内、截至今日已公开；均为预印本。实际读取一手HTML正文的指定章节，不宣称逐页审完证明。尚未找到可核验的作者代码，保留搜索与待补项，不用候选仓库冒充作者实现。

| 论文 | 核心收获 | 本地证据 |
| --- | --- | --- |
| [Generalization behavior of OPTQ and the role of regularization](01-optq/README.md) | 低校准误差不保证总体误差低；正则参数要用独立数据选择 | 标准库二维秩亏/格点实验运行通过；非OPTQ复现 |
| [COEC: Calibrated Orthogonal-Equivalence Compensation for Structured Pruning of Large Language Models](02-coec/README.md) | 双侧正交自由度可补偿剪枝误差，但不能改变保留矩阵奇异值 | 二维双旋转/尺度反例通过；非模型剪枝或COEC完整求解 |

运行：在仓库根分别执行`sh systems_practice/paper/2026-10-03/01-optq/run.sh`与`sh systems_practice/paper/2026-10-03/02-coec/run.sh`。不需要额外安装，未测GPU、NPU、模型任务精度或部署性能；这些是现成阅读例子，不增加必做作业。
