# 2026-10-01 两篇压缩论文：联合决策与约束失效

[主课](../../daily/2026-10-01/README.md)之外的现成阅读，不新增编码任务。

| 论文 | 核心问题 | 复现与证据 |
| --- | --- | --- |
| [Joint Architectural/Quantization Search](01-joint-search/README.md) | 宽度、深度与位宽的联合选择；连续预算不保证离散可部署 | Python标准库合成反例运行通过；未训练NAS、未确认官方源码 |
| [Debias-SparseGPT](02-debias/README.md) | 成对输入差异加入Hessian后改变剪枝选择；不保证所有公平指标改善 | 二维OBS公式例子通过；作者master补丁已读；未运行作者整模型 |

两篇首发均在180天内，按不带版本arXiv ID与旧进度去重。预选2606.22935（Hybrid Compression）发现与SOICT2024旧发表相关，未作为新论文计数；不把上传日期直接当新研究日期。数据/模型和依赖均未下载，论文结果是作者平台报告，不是Thor实测。
