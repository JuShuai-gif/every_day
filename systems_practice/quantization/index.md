# 每日量化索引

[栏目说明](../docs/quantization/README.md) · [交付模板](../docs/quantization/LESSON_TEMPLATE.md) · [方法目录](catalog.json) · [进度](progress.json)

下一方法：**HQQ**。每日一个方法，按日期独立归档。

| 日期 | 类型 | 方法 | 源码 / 阅读 / 示例 / CPU / Thor | 证据 |
| --- | --- | --- | --- | --- |
| 2026-09-18 | 配置及预备拉取，非已交付课程 | AWQ | 均未完成；GitHub DNS 失败 | [原始记录](results/2026-09-18-awq-source.json) |
| 2026-09-19 | 当日AWQ clip子机制；本地获取/运行待补 | AWQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-19/awq/README.md)；[五项状态](2026-09-19/awq/verification.json) |
| 2026-09-20 | 当日GPTQ二阶补偿；本地获取/运行待补，AWQ重试失败 | GPTQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-20/gptq/README.md)；[五项状态](2026-09-20/gptq/verification.json) |
| 2026-09-21 | 当日AdaRound学习舍入；AIMET迁移核实，AWQ重试失败 | AdaRound | 本地拉取否 / 固定commit浏览器阅读是 / 原生API示例是 / CPU否 / Thor否；独立u4检查通过 | [课程](2026-09-21/adaround/README.md)；[五项状态](2026-09-21/adaround/verification.json) |
| 2026-09-22 | AutoRound原生低层舍入/范围优化；AWQ重试失败 | AutoRound | 本地拉取否 / 固定commit实现阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-22/autoround/README.md)；[状态](2026-09-22/autoround/verification.json) |

2026-09-22 历史四课已将独立存储/CPU验证迁入 [共用 C++17 后端](cpp/README.md)，Release/ASan/UBSan及合成协议检查通过；上表CPU状态仍指原生方法运行，保持否。上游Python仅用于校准/训练API；下一方法HQQ不变。
