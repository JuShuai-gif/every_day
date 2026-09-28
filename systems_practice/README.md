# 每日学习总入口

| 文件夹 | 内容 | 阅读入口 |
| --- | --- | --- |
| daily/ | 每日知识轮换：CUDA、C++、CPU、部署等 12 个方向 | [历史与下一主题](daily/index.md) |
| quantization/ | 每日一个量化方法，按日期/方法独立归档 | [量化索引](quantization/index.md) |
| arm/ | 每天一点 ARM，结合 RK3588 与 Jetson 逐步深入 | [ARM 索引](arm/index.md) |
| paper/ | 每天两篇剪枝、量化、模型压缩与边缘部署论文 | [论文索引](paper/index.md) |
| os/ | 每日两个 OS 小主题，从 xv6 到 Linux/边缘推理 | [OS 索引](os/index.md) |
| docs/ | 规范、学习路线、板卡说明、模板及参考资料 | [说明总览](docs/README.md) |

每课的 README 与代码、运行脚本和结果放在一起。学习路线、栏目规则等通用说明集中在 docs/。

当前入口：[2026-09-23 主课](daily/2026-09-23/README.md) · [HQQ](quantization/2026-09-23/hqq/README.md) · [ARM 第 02 节](arm/2026-09-23/README.md) · [两篇论文](paper/2026-09-23/README.md)。

旧规范和旧总索引文件保留为兼容导航，正文只有一份；历史日志中的旧路径保留原样。迁移对应表见 [目录说明](docs/LAYOUT.md)。

历史代码已按 C/C++ 规则回查；处理清单与验证边界见 [语言审查](docs/LANGUAGE_AUDIT.md)。

语言按教学目标选择：量化算法/模型实验优先Python/PyTorch，ARM/CPU底层机制使用C/C++。参见 [最新规范](docs/PRACTICE_SPEC.md)。

2026-09-28 新增独立[OS课程](docs/os/README.md)，首轮28节/56主题；[首节：系统调用与FD](os/2026-09-28/README.md)。随既有08:30任务执行。
