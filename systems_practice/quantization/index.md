# 每日量化索引

[栏目说明](../docs/quantization/README.md) · [交付模板](../docs/quantization/LESSON_TEMPLATE.md) · [方法目录](catalog.json) · [进度](progress.json)

下一方法：**GPTQ**（gptq，第二轮）。AWQ源码获取与阅读已补齐，原生依赖和Thor运行仍在backlog。

| 日期 | 类型 | 方法 | 源码 / 阅读 / 示例 / CPU / Thor | 证据 |
| --- | --- | --- | --- | --- |
| 2026-09-18 | 配置及预备拉取，非已交付课程 | AWQ | 均未完成；GitHub DNS 失败 | [原始记录](results/2026-09-18-awq-source.json) |
| 2026-09-19 | 当日AWQ clip子机制；本地获取/运行待补 | AWQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-19/awq/README.md)；[五项状态](2026-09-19/awq/verification.json) |
| 2026-09-20 | 当日GPTQ二阶补偿；本地获取/运行待补，AWQ重试失败 | GPTQ | 本地拉取否 / 固定commit网页阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-20/gptq/README.md)；[五项状态](2026-09-20/gptq/verification.json) |
| 2026-09-21 | 当日AdaRound学习舍入；AIMET迁移核实，AWQ重试失败 | AdaRound | 本地拉取否 / 固定commit浏览器阅读是 / 原生API示例是 / CPU否 / Thor否；独立u4检查通过 | [课程](2026-09-21/adaround/README.md)；[五项状态](2026-09-21/adaround/verification.json) |
| 2026-09-22 | AutoRound原生低层舍入/范围优化；AWQ重试失败 | AutoRound | 本地拉取否 / 固定commit实现阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-22/autoround/README.md)；[状态](2026-09-22/autoround/verification.json) |
| 2026-09-23 | HQQ近端权重量化，Dropbox迁移已核实；AWQ重试失败 | HQQ | 本地拉取否 / 固定commit实现阅读是 / 原生API示例是 / CPU否 / Thor否 | [课程](2026-09-23/hqq/README.md)；[五项状态](2026-09-23/hqq/verification.json) |
| 2026-09-24 | 顺序补课，实际交付9月28日 | OmniQuant | 本地获取否 / 固定commit阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-09-24/omniquant/README.md)；[状态](2026-09-24/omniquant/verification.json) |
| 2026-09-25 | 顺序补课，实际交付9月28日 | QuaRot | 本地获取否 / 固定commit阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-09-25/quarot/README.md)；[状态](2026-09-25/quarot/verification.json) |
| 2026-09-26 | 顺序补课，实际交付9月28日 | SpinQuant | 本地获取否 / main实现已读，commit待补阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-09-26/spinquant/README.md)；[状态](2026-09-26/spinquant/verification.json) |
| 2026-09-27 | 顺序补课，实际交付9月28日 | SpQR | 本地获取否 / main实现已读，commit待补阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-09-27/spqr/README.md)；[状态](2026-09-27/spqr/verification.json) |
| 2026-09-28 | 保留补充：OmniQuant LWC；不重复推进，AWQ重试失败 | OmniQuant | 本地获取否 / 固定commit阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-09-28/omniquant/README.md)；[状态](2026-09-28/omniquant/verification.json) |
| 2026-09-29 | 当日SmoothQuant；AWQ仅重试一次 | SmoothQuant | 获取否 / main实现阅读是（commit待补） / 示例是 / CPU否 / Thor否 | [课程](2026-09-29/smoothquant/README.md)；[状态](2026-09-29/smoothquant/verification.json) |
| 2026-09-30 | LLM.int8；AWQ仅重试一次失败 | LLM.int8离群混合分解 | 获取否 / 0.48.1源码阅读是 / 原生示例是 / CPU否 / Thor否 | [课程](2026-09-30/llm_int8/README.md)；[状态](2026-09-30/llm_int8/verification.json) |
| 2026-10-01 | HistogramObserver校准；AWQ单次重试失败 | 校准感知缩放 | 获取否 / 固定commit实现阅读是 / 原生API交付是 / CPU否 / Thor否 | [课程](2026-10-01/calibration/README.md)；[状态](2026-10-01/calibration/verification.json) |
| 2026-10-03 | NF4原生打包/状态重载与冻结主干低秩适配；AWQ重试失败 | NF4 / QLoRA | 本地获取否 / 固定commit阅读是 / 示例是 / CPU否 / Thor否 | [课程](2026-10-03/nf4_qlora/README.md)；[五项状态](2026-10-03/nf4_qlora/verification.json) |

2026-09-22 用户纠正：四课默认使用 Python/PyTorch 完成原生算法、模型精度、重载和框架级耗时对比；C++位布局/CPU内核为可选补充（native-cpp），不再强制主流程构建。现有C++独立检查通过；原生方法/新torch评估仍因依赖缺失而未运行，HQQ游标不变。

补课失败均单独进入 backlog；24–27是历史课程日期，源码实际读取和尝试日期为2026-09-28，不伪造历史运行。原28日OmniQuant保留。

2026-10-02：[QAT正式栏目](2026-10-02/qat/README.md)：v0.13.0实现已读、原生训练/导出示例已交付；获取否/CPU否/Thor否，完整commit与tag许可待补。[五项状态](2026-10-02/qat/verification.json)。早期[calibration](2026-10-02/calibration/README.md)仅补充；当日只计QAT，旧AWQ仅重试一次。

2026-10-04：[KIVI：KV分组轴与残留](2026-10-04/kivi/README.md)，获取否/阅读是/示例交付是/CPU原生否/Thor否；独立packed QK CPU964行通过，不能替代原生运行。[五项记录](2026-10-04/kivi/verification.json)。只重试旧AWQ一次，DNS失败；下一方法optimizer_8bit。

2026-10-05：[Adam8bit分块状态](2026-10-05/optimizer_8bit/README.md)，获取否/实现阅读是/原生示例是/CPU原生否/Thor否。独立均匀8bit真实80步更新与失败反例通过，非bnb性能；Thor SM110 codec基线/优化/ncu/ISA命令齐备但未运行。旧AWQ只重试一次，DNS失败。[五项状态](2026-10-05/optimizer_8bit/verification.json)。

2026-10-06：[FP8动态per-tensor缩放](2026-10-06/fp8_scaling/README.md)。获取否/局部阅读是/原生示例交付是/CPU原生否/Thor否；独立E4M3FN真实235B权重文件与误差对照已运行。Thor SM110编码基线/向量候选、ncu/ISA命令已交付，理论对照Hopper；旧AWQ仅重试一次失败。

2026-10-07：[NVFP4双层scale与真实打包](2026-10-07/block_fp4/README.md)。获取否/固定tag实现阅读是/原生示例是/CPU原生否/Thor否；独立文件785B与FP16权重2210B，CPU QDQ更慢，分布偏移退化保留。Thor SM110解码基线/候选、ncu/PTX/SASS方案，理论对照Ada；下一轮AWQ选新设计点。旧AWQ仅重试一次失败。

2026-10-08：[AWQ第二轮：缩放融合与分布偏移](2026-10-08/awq/README.md)。获取是/实现阅读是/原生示例交付是/CPU原生否/Thor否；独立CPU真实332B文件，误差0.051529→0.022090，分布偏移反而退化。Thor SM110基线/warp候选、ncu/ISA教程齐备未实测，理论对照Turing。AWQ进入已读已交付列表，运行待补；旧GPTQ仅重试一次失败。下一方法GPTQ。
