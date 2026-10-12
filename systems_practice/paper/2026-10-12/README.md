# 2026-10-12 两篇论文：删除后的计算由谁补回来？

两篇都在最近180天内首发，且未出现于既有论文进度；今日分别关注专家删除的路由补位和视觉token联合删除的条件边际。它们都涉及归一化，但对象、预算和执行阶段不同，不应把一种分数直接迁移到另一种系统。

| 论文 | 核心收获 | 证据 |
| --- | --- | --- |
| [RAZOR: Pruning Replaceable Experts in LLMs](01-razor/README.md) | 删除专家后幸存权重重归一化，补位专家残差可抵消或放大误差 | 方法/实验选段及作者实现实际阅读；独立1000次恒等式检查 |
| [From Token Importance to Conditional Removability: Rethinking Visual Token Pruning in Multimodal Large Language Models](02-coreprune/README.md) | 同一token的救回收益依赖当前删除集合；单点排名并不固定 | 方法/实验选段已读；独立16个子集检查，未找到可核实作者实现 |

本机两个Python标准库例子实际运行，完整作者模型、任务精度和设备收益均未复现。没有训练权重下载，也没有CUDA kernel实现或运行。本栏目为现成阅读材料，不增加必做任务。
