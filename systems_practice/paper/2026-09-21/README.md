# 2026-09-21：每日两篇论文

今天关注从训练到部署的两个环节：先让激活更适合量化，再检查剪枝后的形状是否仍适合存储格式。

| 论文 | 核心收获 | 阅读与示例 |
| --- | --- | --- |
| SCULPT，2026-09-01 | 微调阶段约束激活分布，为后续 PTQ 准备更稳定的范围 | [讲解、难度、运行命令](01-sculpt/README.md) · [代码](01-sculpt/src/example.cpp) |
| Large Models for Small Devices，2026-08-16 | 剪掉参数后仍须检查格式对齐、最终文件大小与实际质量 | [讲解、难度、运行命令](02-edge-deployment/README.md) · [代码](02-edge-deployment/src/example.cpp) |

两篇的标准库示例已在本机运行，不需下载模型。它们分别演示裁剪/正则统计和自定义分块存储；均不是完整论文复现，也没有 Thor、RK3588 或 Raspberry Pi 性能结果。

从仓库根目录运行：

```bash
bash systems_practice/paper/2026-09-21/01-sculpt/run.sh
bash systems_practice/paper/2026-09-21/02-edge-deployment/run.sh
```

原文：[SCULPT](https://arxiv.org/abs/2609.01743v1)、[Large Models for Small Devices](https://arxiv.org/abs/2608.15693v1)。
