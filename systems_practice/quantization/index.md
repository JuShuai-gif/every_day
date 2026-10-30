# 每日量化索引

[栏目说明](../docs/quantization/README.md) · [交付模板](../docs/quantization/LESSON_TEMPLATE.md) · [方法目录](catalog.json) · [进度](progress.json)

下一方法：**8-bit优化器状态**（optimizer_8bit，第二轮）。KIVI源码/原生用法已交付，CPU原生/Thor待补。

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

2026-10-09：[GPTQ第二轮：Hessian阻尼、act-order与分组](2026-10-09/gptq/README.md)。本地获取否/固定commit实现阅读是/原生示例交付是/CPU原生否/Thor否；GitHub raw 源码读取 `GPTQ.add_batch/fasterquant`、`Quantizer.find_params`、`Quant3Linear.pack` 与 `opt_sequential`，浅克隆失败事实保留。下一方法AdaRound。

2026-10-11：[AdaRound第二轮：正则与硬化交付](2026-10-11/adaround/README.md)。真实浅拉取6360e0c7、实现阅读与原生示例交付；CPU原生未运行（Python/torch/AIMET不足）、Thor未验。五项状态见[验证](2026-10-11/adaround/verification.json)。旧GPTQ仅重试一次，源码获取成功，未重新读/跑或推进游标。

2026-10-12：[AutoRound第二轮：舍入与范围同条件消融](2026-10-12/autoround/README.md)。原仓库7a660e16实际浅拉取，旧路径迁移核实；原生QDQ/SignSGD示例已交付，Python/torch不足未运行，Thor未验。旧HQQ仅重试获取成功，不推进其游标。[五项状态](2026-10-12/autoround/verification.json)。

2026-10-13：[HQQ第二轮：近端优化与分组打包](2026-10-13/hqq/README.md)。原仓库d88a488e实际获取并阅读，原生Quantizer/HQQLinear导出重载示例已交付；CPU因缺torch未运行，Thor未验。旧OmniQuant仅重试获取成功，不推进其课程游标。[五项状态](2026-10-13/hqq/verification.json)。

2026-10-14：[OmniQuant第二轮：LWC校准优化与硬导出](2026-10-14/omniquant/README.md)。源码实际获取feffe8ea、阅读/原生API交付是；CPU缺torch未运行，Thor后端未验。主课四位宽比较与实际STE训练独立运行，不能替代OmniQuant原生状态；只重试旧QuaRot获取成功。[五项状态](2026-10-14/omniquant/verification.json)。

2026-10-15：[QuaRot第二轮：在线旋转成本与i4导出](2026-10-15/quarot/README.md)。固定5008669b真实浅获取/阅读/原生API交付；CPU缺torch未运行，旧SM硬编码的Thor后端未验。SpinQuant旧待补仅重试获取，3文件成功/旧路径缺失，无阅读或运行推进。[五项状态](2026-10-15/quarot/verification.json)。

2026-10-17：[SpinQuant第二轮：原生SGDG与旋转交付成本](2026-10-17/spinquant/README.md)。固定8f47aa3f真实获取/阅读/示例交付；CPU缺torch未运行，Thor未验。旧SpQR仅重试获取成功，无阅读或运行推进。[五项状态](2026-10-17/spinquant/verification.json)。

| 2026-10-18 | 第二轮：稀疏覆盖与真实存储预算 | SpQR | 获取是 / 阅读是 / 示例是 / CPU否（缺torch） / Thor否 | [课程](2026-10-18/spqr/README.md) · [状态](2026-10-18/spqr/verification.json)；SmoothQuant仅重试获取失败 |

2026-10-19：[SmoothQuant第二轮：共享Norm与真实i8导出](2026-10-19/smoothquant/README.md)。浅克隆解析c61476d7后blob超时，连接器按commit恢复源码快照；获取/阅读/示例是，CPU缺torch未运行，Thor未验。旧LLM.int8仅一次获取重试DNS失败；下一方法LLM.int8。[状态](2026-10-19/smoothquant/verification.json)。

2026-10-21：[LLM.int8第二轮：离群列与量化状态](2026-10-21/llm_int8/README.md)。原仓库83364904实际获取/阅读/原生API交付；CPU未运行（Python/torch），Thor基线/共享候选已写、未编译。固定sm_110，理论对照Ada，下一Turing。一个旧calibration获取重试失败；下个方法calibration。[五项状态](2026-10-21/llm_int8/verification.json)。

2026-10-22：[校准感知缩放：EMA顺序偏置](2026-10-22/calibration/README.md)。真实拉取/源码阅读/原生示例交付；缺torch，CPU原生/Thor未验。独立标量真i8文件8B，偏移MSE退化保留。下一方法QAT；仅重试旧QAT获取一次，DNS失败。

2026-10-23：[QAT第二轮：固定网格STE与打包](2026-10-23/qat/README.md)。实际浅拉取/读取AO9e9dca96，原生示例交付；缺torch未运行，Thor未验。独立两候选各160更新、真u4文件24B，比FP16载荷16B大，eval与shift误差退化保留。一个旧NF4获取重试DNS失败；下一方法NF4/QLoRA。[五项状态](2026-10-23/qat/verification.json)。

2026-10-24：[NF4第二轮：nested scale状态与原生重载](2026-10-24/nf4_qlora/README.md)。真实拉取QLoRA7f4e95a并阅读，bnb0.48.1/7e16503e原生API与CMake已读；获取/阅读/示例是，CPU缺torch、Thor未验。旧KIVI只重试获取一次DNS失败；下一KIVI。[五项状态](2026-10-24/nf4_qlora/verification.json)。最终核验10月25，不消耗额外25日游标。

2026-10-26：[KIVI第二轮：残留窗口与真实pack/unpack](2026-10-26/kivi/README.md)。实际浅拉取876b4d2d并读实现，原生CPU示例已交付；两Python环境缺torch未运行，Thor后端待补。五状态是/是/是/否/否；仅重试一个旧optimizer_8bit获取失败、无可验证缓存；下一optimizer_8bit。[状态](2026-10-26/kivi/verification.json)。

2026-10-27：[8-bit优化器状态](2026-10-27/optimizer_8bit/README.md)。bitsandbytes 当前提交83364904实际浅拉取并阅读；独立32参数40步block8更新通过，payload 256B→96B；native torch/CUDA/Thor未运行，五项状态见[verification](2026-10-27/optimizer_8bit/verification.json)。下一方法FP8动态缩放。


2026-10-28：[FP8 scaling](2026-10-28/fp8_scaling/README.md)。torchao Float8Linear/config/utils 实际网页源码已读；浅克隆因 GitHub DNS 失败。独立 E4M3 小例 CPU 通过，native torch/Thor 未运行；下一方法 MXFP4/NVFP4。

2026-10-29：[MXFP4/NVFP4 分块浮点](2026-10-29/block_fp4/README.md)。Model Optimizer 浅克隆因 GitHub DNS/cache miss，独立 block-scale codec CPU 通过；native API、CUDA/Thor 未验证。下一方法 AWQ。

2026-10-29 Old_Thor 补充验证：固定源码缓存的 HQQ、OmniQuant、SpQR、SmoothQuant、KIVI 原生 CPU 示例通过；GPTQ 在 Thor GPU 上运行原生 QDQ 评估通过，打包 CUDA 扩展仍缺失。[范围与待补](../validation/2026-10-29-thor/README.md)。

2026-10-29 后续：2026-10-28 FP8 原生示例在 Thor 既有 PyTorch 26.06 / torchao 0.18 容器确认 `Float8Tensor` 转换并与 FP16 比较通过；这不是原读 torchao 0.13 的复现，ncu/指令/性能待验。[记录](../validation/2026-10-29-thor/fp8-ao018-final.txt)。

2026-10-30：[AWQ第三轮：激活感知通道缩放与分布外退化](2026-10-30/awq/README.md)。固定提交源码实际阅读；浅克隆尝试见 `source-fetch.json`；独立真实u4打包/重载/CPU对照通过，原生torch、Thor、ncu、PTX/SASS待验。下一方法 GPTQ。
