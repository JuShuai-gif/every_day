# 论文历史索引

每天两篇；以下日期是论文首次提交日期，交付日期另列。难度指完整实验复现，小示例难度单独说明。

| 交付日期 | 论文 / 首次提交 | 方向与阅读重点 | 完整复现难度 | 本地验证 |
| --- | --- | --- | --- | --- |
| 2026-09-21 | [SCULPT](2026-09-21/01-sculpt/README.md) / 2026-09-01 | 量化：在微调时改善后续 PTQ 的激活分布 | 中到难：未找到可核实的官方实现 | C++17机制示例通过；无训练/任务精度复现 |
| 2026-09-21 | [Large Models for Small Devices](2026-09-21/02-edge-deployment/README.md) / 2026-08-16 | 剪枝与部署：通道对齐、量化格式回退 | 难：公开仓库缺完整处理与评分流程 | C++17真实字节打包示例通过；非 GGUF/板端复现 |
| 2026-09-22 | [REAL-Q](2026-09-22/01-real-q/README.md) / 2026-08-30 | 量化：完整二次型与未量化列动态修正 | 难：作者完整实现未找到 | C++17梯度校验/4参数真实Adam更新通过；非全模型复现 |
| 2026-09-22 | [ESTS at WMT26](2026-09-22/02-ests/README.md) / 2026-09-11 | 剪枝：路由分歧、容量预算与专家重映射 | 难：公开推理提交，完整训练链未核实 | C++17的52容量案例通过；FP32 payload288→192B；无任务/设备性能 |
| 2026-09-23 | [Quantization-Aware Healing](2026-09-23/01-qah/README.md) / 2026-08-21 | 量化恢复：原始教师KL与真实STE更新 | 难：训练/导出源码未找到 | Python标准库3分支真实更新、chunk KL/零概率边界通过；非MXFP4复现 |
| 2026-09-23 | [Fisher Information Distances](2026-09-23/02-fisher-distance/README.md) / 2026-09-14 | 剪枝：局部Fisher、坐标路径与RMS分数 | 中到难：长扫描与作者依赖/许可待核验 | Python解析Fisher有限差分、独立heldout和边界通过；无稀疏加速 |
| 2026-09-24 | [Breaking the Compression Barrier: Cross-Architecture Compression Boundary Learning via Reverse Regrowth](2026-09-24/01-bridge/README.md) / 2026-08-17 | 先越过剪枝崩溃点，再从损坏严重的层恢复关键连接 | 中→难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-24 | [A Hardware-oriented Approach for Efficient Bayesian Inference Computation and Deployment](2026-09-24/02-bayes/README.md) / 2026-07-20 | 把不同形状的张量收缩并成规则批次，或展平并放入块对角矩阵 | 中：作者完整复现待补 | C++17 Release/ASan/UBSan机制小例子实际通过；非整篇复现 |
| 2026-09-25 | [Prune Once: Retraining-Free Task-Agnostic Pruning for Vision-Language Models](2026-09-25/01-porta/README.md) / 2026-08-07 | 用校准特征方差而非单看均值幅度衡量通道信息，权重分数Sij=Var(Xj)*abs(Wij)，结合输出方差分配层稀疏率。 | 中：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-25 | [TwinQuant: Learnable Subspace Decomposition for 4-Bit LLM Quantization](2026-09-25/02-twinquant/README.md) / 2026-06-01 | 把W拆成UV+R，并用可逆G以及全局正交Q重新参数化，使两个分支和激活的量化误差共同下降 | 难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-26 | [AlphaQ: Calibration-Free Bit Allocation for Mixture-of-Experts Quantization](2026-09-26/01-alphaq/README.md) / 2026-06-03 | 从权重谱估计Hill指数，构造重要性加权噪声eta=(median(alpha)/alpha)^gamma*Var(W)*2^(-2b)，在全局位预算内选择各层位宽。免校准指位分配，论文后续GPTQ仍用了校准样本。 | 中→难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-26 | [Q-DEQ: Discrete Solving and Quantization for Deep Equilibrium Models in Time Series Forecasting under Edge Deployment Coding Constraints](2026-09-26/02-qdeq/README.md) / 2026-09-21 | 在DEQ固定点附近用有限差分近似残差方向变化，编码局部系数为二进制，最小化二次能量。固定点求解保持连续精度，W8A8只加在re-forward，是另一阶段。 | 难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-27 | [Efficient Quantization-Aware Distillation with Cross-Modal Alignment for Edge Vision–Language Models](2026-09-27/01-edge-distill/README.md) / 2026-09-15 | 以冻结教师作为量化学生的语义锚，联合关系蒸馏与对称InfoNCE | 难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-27 | [BASC: Behavior-Aligned Quantization and Pruning for Low-Bit Spiking Neural Networks](2026-09-27/02-basc/README.md) / 2026-08-12 | LIF膜电位的阈值使小权重变化改变放电时间。TSC用时间任务损失学习scale，BIC重评剪枝边界附近通道间的相互作用。权重误差最小不一定对应行为误差最小。 | 中→难：作者完整复现待补 | Python标准库机制小例子实际通过；非整篇复现 |
| 2026-09-28 | [Rift](2026-09-28/01-rift/README.md) / 2026-09-24 | 图块剪枝与条件准确率/能耗预算 | 难：作者仓库未核实 | Python合成决策/偏移召回/边界通过；无设备数据 |
| 2026-09-28 | [Rate-Distortion Perspective](2026-09-28/02-rate-distortion/README.md) / 2026-09-02 | 固定分布与码率的VQ/PQ/SQ比较 | 中到难：实现审查待补 | Python真实Lloyd更新、训练目标/空簇检查通过；非作者训练 |
| 2026-09-29 | [Train Overcomplete, Deploy Compact: Scaling Recovery Capacity for Structured LLM Pruning](2026-09-29/01-overrep/README.md) / 2026-09-07 | 训练增容与退火后精确合并 | 完整复现难：作者实现未公开 | CPU独立小例子240次实际更新、合并检查通过；非模型复现 |
| 2026-09-29 | [Fine-Tuning Low-Bit Models with Gradient in Quantized Code Space](2026-09-29/02-gradcodes/README.md) / 2026-08-31 | 梯度引导离散候选、真实损失接纳 | 中到难：核心实现/环境待审计 | CPU小例子80次scale更新、2次码更新；非原生低位kernel |
| 2026-09-30 | [When Quantization Breaks Memory: Recurrent-State Write-Back in Low-Precision Temporal Inference](2026-09-30/01-writeback/README.md) / 2026-09-03 | 状态回写量化吞掉小更新；误差反馈与真实状态存储 | 完整复现难：作者实现未核实/未公开 | Python独立机制检查通过；无模型/硬件复现 |
| 2026-09-30 | [When Compression Scores Cannot Decide: Information Boundaries for Group-Robust LLM Pruning](2026-09-30/02-group-risk/README.md) / 2026-08-03 | 同局部分数可对应相反最差组决策；完整mask风险边界 | 完整复现难：作者实现未核实/未公开 | Python独立机制检查通过；无模型/硬件复现 |
| 2026-10-01 | [Joint Architectural/Quantization Search](2026-10-01/01-joint-search/README.md) / 2026-06-02；[Debias-SparseGPT](2026-10-01/02-debias/README.md) / 2026-09-02 | 联合选择/离散预算；成对Hessian与OBS | 官方实现缺口/全模型难；Debias master补丁已读 | 两个独立Python例子通过，无完整训练/GPU复现 |
| 2026-10-03 | [OPTQ泛化与正则](2026-10-03/01-optq/README.md) / 2026-09-25 | 校准零空间与正则几何；v1预印本 | 中→难：作者实现未找到 | Python标准库秩亏/独立调参及保留评估通过；非OPTQ实现 |
| 2026-10-03 | [COEC](2026-10-03/02-coec/README.md) / 2026-08-21 | 结构剪枝后双侧正交补偿；v1预印本 | 难：作者实现未找到 | 二维旋转与谱尺度反例通过；非模型剪枝复现 |


下一期继续检索新论文；不重复已归档 arXiv ID。完整进度见 [progress.json](progress.json)。

2026-09-22 历史四例均已迁移为 C++17，并通过 Release 与 ASan/UBSan；旧 Python 输出保留为历史，新结果在各课 cpp-output.json。未新增论文或推进游标。详见 [语言审查](../docs/LANGUAGE_AUDIT.md)。

2026-10-02：[DAMP：衰减感知状态精度](2026-10-02/02-damp/README.md) + [GSQ：Gumbel网格优化](2026-10-02/03-gsq/README.md)。主文选段已读，两个标准库机制例实际通过；GSQ核心源码已读，均未复现原模型。Debias重复材料保留为补充，不计新论文。[当日入口](2026-10-02/README.md)。

| 2026-10-04 | [HOPE](2026-10-04/01-hope/README.md) / 2026-09-16 v1 | 专家交互矩阵与预算剪枝 | 难：迁移新仓库API/完整复现待验 | 独立4专家枚举通过，分布变化退化；非作者模型 |
| 2026-10-04 | [D-Quant](2026-10-04/02-dquant/README.md) / 2026-09-17 v1 | 定长容器的失真/码长约束 | 难：作者源码未找到 | 独立前缀码18→16bit、误差0.7→2.7；非rANS/注意力复现 |

2026-10-05：[FlexPosit](2026-10-05/01-flexposit/README.md)（2026-09-04首发，v1方法/表II，最新v2另标）＋[Telescopic Language Models](2026-10-05/02-tlm/README.md)（2026-09-28 v1）。独立Posit预算/分布偏移与2000步前缀训练已运行；作者实现分别访问失败/尚未发布，无完整模型/硬件复现。[当日入口](2026-10-05/README.md)。

2026-10-06：[IrekoGPT](2026-10-06/01-irekogpt/README.md)（2026-09-30 v1，多宽度校准/岭修正）＋[S²Prune](2026-10-06/02-s2prune/README.md)（2026-09-01 v1，空间覆盖与容量分配）。方法/表1选段已读；独立CPU例子运行，保留分布变化退化；无完整模型/设备复现。[入口](2026-10-06/README.md)。

2026-10-07：[Small LLMs: Pruning vs. Training from Scratch与Quantization-Triggered Backdoors](2026-10-07/README.md)。前者首发06-12，本次v1（最新v3另标）；后者08-27v1，作者备注ARES2026接收。实际读方法/表格，独立预算训练与部署margin例运行通过；作者算法/完整模型/硬件未复现。

2026-10-08：[Gated DeltaNet NVFP4](2026-10-08/01-gdn/README.md)（首发2026-09-03）与[Putri结构剪枝](2026-10-08/02-putri/README.md)（首发2026-05-18）。v1全文已读，均预印本；二维状态/融合scale与真实最小二乘更新例子通过。Putri源码实际拉取阅读；两篇完整复现难，未验证LLM/Thor性能。

2026-10-09：[G²PTQ](2026-10-09/01-g2ptq/README.md) 与 [EdgeVLN](2026-10-09/02-edgevln/README.md)。两篇 v1 的 arXiv 元数据/摘要已读，独立 Python 边界例子通过；未读全文、未复现作者模型或硬件结果。

2026-10-11：[WRP与TOGA](2026-10-11/README.md)。分别首发2026-09-09/06-05，v1方法与实验正文选段已读；独立Gram置换反例与联合预算枚举通过，保留无收益/偏移退化；作者实现未核实，未完整复现模型或设备。

2026-10-12：[RAZOR与CoRePrune](2026-10-12/README.md)。分别首发09-24/09-22，v1方法/实验正文选段实际阅读；RAZOR固定commit作者实现已读，CoRePrune作者代码未核实。独立1000公式与16子集例通过，负救回边际保留；完整模型/设备未复现。

2026-10-13：[Capability Scaling-Down Laws](2026-10-13/01-scaling/README.md)（首发10-01）与[P4Q](2026-10-13/02-p4q/README.md)（首发09-28）。v1方法/实验选段实际阅读；前者作者预测实现已读、代码许可待核实，后者作者实现未核实。独立CPU拟合/符号反例与QDQ选token/保留分布校准已运行，保留无收益和误差退化；未复现完整模型/Thor。

2026-10-14：[DBW / TaSQ](2026-10-14/README.md)。2610.06026v1（10-05）与2610.03027v1（10-02），方法/实验及选定作者源码已读；独立预算硬化与query加权VQ示例实际通过；DBW代码许可/两篇完整模型与Thor复现待补。

2026-10-15：[MultiAlloc/误差反馈](2026-10-15/README.md)，均首发10-13，2610.18642v1与2610.18139v1方法/实验选段已读；前者作者预算与缓存源码已读，后者作者仓库未核实。独立预算213B/224B及联合trace5→4但687/1521样本退化实际通过；未复现完整模型/Thor，首版失败保留。

2026-10-17：[AIQ与Kashin-DCT](2026-10-17/README.md)。2610.12494v1（元数据首发09-25）与2609.11687v1（09-10），方法/实验选段已读；作者实现未核实。独立整数系数/44B打包与DCT/60B双因子例通过，两者量化误差均保留退化；无完整模型/Thor复现。

2026-10-18：[RoleQ/FPoT](2026-10-18/README.md)，均首发10-15，2610.21808v1/2610.21257v1方法/实验/局限已读。独立CPU三值prefix/行列scale与整数shift-add/近似网格例实际通过，均44B文件；FPoT评估误差退化保留。作者实现/完整模型/Thor待验。

2026-10-19：[VLM结构剪枝/MetaKV](2026-10-19/README.md)。2604.24380v1（2026-04-27扩展，承接2025工作）、2609.07966v1（09-07）；方法/实验选段与作者选定源码已读。独立CPU真实200步projector恢复MSE0.44235→6.19e-11，MetaKV论文/源码fallback选择A/B反转通过；非完整模型/Thor复现，MetaKV许可待核实。

2026-10-21：[Apertus蒸馏与量化](2026-10-21/01-apertus/README.md) · [Influence-Inspired Spectral Rotations for Extreme Low-Bit LLM Quantization](2026-10-21/02-spectral/README.md)。两篇一手全文选段/作者源码已读；独立CPU示例通过，160步STE与u2打包重载。偏移MSE与元数据存储退化保留；完整模型/设备未复现。[总览](2026-10-21/README.md)。

2026-10-22：[LAST与SPQ](2026-10-22/README.md)。LAST首发07-30v1，SPQ首发02-20、5月LREC版本（365天例外）。全文选段已读，SPQ作者源码已读；独立CPU选择/NumPy打包通过，偏移退化与metadata/FP32影子成本保留。完整模型/Thor未验。

2026-10-23：[DRQ与多目标结构剪枝](2026-10-23/README.md)。2610.11226v1(10-08)与2607.22583v1(元数据首发06-08，最新v3为10-17)一手方法/实验选段已读；作者实现未核实。独立CPU真2位打包/物理删块重载通过；普通eval退化、metadata成本与论文设备描述不一致保留，未复现完整模型/Thor。

2026-10-24：[Quantization Amplifies Determinism, Not Bias / KV Cache Compression Through the Lens of Transform Coding](2026-10-24/README.md)。2609.07901v1（09-07）/2608.14191v1（08-14）一手方法/结果/局限已读；独立CPU测量与真混合位打包例通过，AATC代理目标改善但实际attention误差退化如实保留。作者实现、完整模型/Thor未复现；最终核验10月25。

2026-10-26：[Minima-KV与CompressKV](2026-10-26/README.md)。2608.23834v1（08-24）/2606.24467v1（06-23），一手方法/实验选段已读；CompressKV作者selected源码已读，许可待核实。独立CPU稳定softmax合并9例与真实12B FP16 KV/索引输出通过，shift保留质量0.7→0.04退化；Minima表3算术不一致已标注。完整模型/Thor未复现。

2026-10-27：[两篇](2026-10-27/README.md)：Large Models for Small Devices（2608.15693，作者仓库已读）与PolyQ（2607.14618，全文已读但无核实作者仓库）。独立CPU布局例通过，完整模型/设备未复现。


2026-10-28：[LayerTrim](2026-10-28/01-layertrim/README.md) 与 [HQP](2026-10-28/02-hqp/README.md)。一手全文选段与独立 CPU 预算例通过；作者完整实现、模型、Thor/RK3588 未复现。

## 2026-10-29

- [Edge continuum measurement](2026-10-29/01-edge-measurement/README.md) · [Green AI quantized inference](2026-10-29/02-green-ai/README.md)
