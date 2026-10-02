# Debias-SparseGPT: Bias-Aware Pruning for Large Language Models

## 元信息、论文与源码阅读

Irina Proskurina、Guillaume Metzler、Antoine Gourru、Julien Velcin，[arXiv2609.02496v1](https://arxiv.org/abs/2609.02496v1)，2026-09-02首发；作者页面标注EMNLP2026录用。实际读[正文](https://arxiv.org/html/2609.02496v1)第1–6节、Limitations、式2–5、算法1、表2–5及附录C部分配置。工作聚焦剪枝引入的社会偏差，不能将bias误译为Linear的加性bias项。

实际访问[官方仓库](https://github.com/upunaprosk/debias-llm-compressor)，2026-10-01初读目录；跨日后2026-10-02更正分支并读取master：[补丁](https://github.com/upunaprosk/debias-llm-compressor/blob/master/patches/llm_compressor_0.8.1_stereoset.patch)中format_calibration_data、accumulate_hessian、sparsify_weight的原始副本与增量；[pyproject.toml](https://github.com/upunaprosk/debias-llm-compressor/blob/master/pyproject.toml)说明Python≥3.10、CLI入口debias_sparsegpt.cli:main，README给Python3.11环境。补丁针对llm-compressor0.8.1，不能随意套到其他版本。最初main路径请求失败，检查仓库分支后改master已读成功；精确commit未固定。仓库页面标Apache2.0，LICENSE正文Cache miss，许可全文仍待核实。

## 两个耦合机制

论文以成对输入的响应差异约束剪枝：原有重建损失外，再加入差异方向的惩罚；随后沿二阶代价选择删权重并补偿剩余权重。关注的是保持成对响应差异，不是令所有响应相等。作者表3的Qwen在2:4情形，UnQover从28.45降至24.94、DTO从.616升至.645，提示一些指标退化；不能宣称总能改善公平性。作者用了两张A100 80GB，英语数据范围等限制也需保留。

源码链为成对数据→保持顺序的batch→层输入hook/Hessian累计→带阻尼的逆与Cholesky→按块剪枝/补偿。已读补丁里仅`ALPHA != 0`且`inp.shape[0] == 2`才增加差分项，并关闭shuffle。误把batch改成1可能静默失去机制。代码的Hinv变量在Cholesky后是逆矩阵的因子，不能直接拿其对角与下文数学逆矩阵公式混用。补丁累计带样本归一化，参数alpha与论文/简化例子系数须核对。

## 独立二维公式例子

[example.py](example.py)纯Python标准库，不是作者SparseGPT调用；无训练与模型下载：

```sh
sh systems_practice/paper/2026-10-01/02-debias/run.sh
```

输入两组3×2配对向量和w=[.5,1]。自行定义目标`L(δ)=1/2 Σ[(δ·x0)^2+(δ·x1)^2]+αΣ[δ·(x0-x1)]²`，因此H=Σ[x0x0ᵀ+x1x1ᵀ+2αΔxΔxᵀ]。这是明确归一化的教学目标，不声称α数值直接等同作者CLI。约束删第p个权重时，δ=-w_p H⁻¹[:,p]/H⁻¹_pp，损失w_p²/(2H⁻¹_pp)。计算显式目标与二次型相等，检查被剪分量为0及奇异矩阵拒绝；相同配对退化为普通H。

实际[输出](results/cpu.txt)：α0时H=diag(12,4)、分数(1.5,2)、删0；α1时H=diag(60,4)、分数(7.5,2)、删1。这只证明差异项能改变选择与闭式目标相符，不证明社会公平、整网困惑度或稀疏加速。示例严格拒绝奇异H；作者实现包含阻尼及失败退化，不能混淆两者。

## 复现难度、故障与验收

完整复现需真实成对token数据、对齐/padding约定、作者补丁后端、校准与评估拆分、按层统计与N:M导出。未运行这些，也未核实Thor稀疏后端支持；稀疏权重的零数不等于推理提速。原库环境不自动安装；本课不提供未读完整CLI的猜测参数。

故障一：调高ALPHA结果不变→打印配对batch形状及差分H范数→batch1跳过项/同对重复→固定配对及顺序，回归alpha0和同对退化例；代价是数据管线受配对约束。故障二：困惑度尚可但某群体指标恶化→分组检查公平指标及置信范围→校准覆盖或目标冲突→保留原始模型对照与独立分组评估，不能仅调到测试集好看。故障三：H求逆失败→检查秩、非有限及阻尼→按版本诊断退化路径并记录，而非静默宣称二阶方法仍完整执行。

验收清单：固定仓库commit和许可正文；补丁匹配0.8.1；配对顺序与shape断言；对称/正定/阻尼检查；独立公平和质量评估；稀疏存储与真实kernel分开测；CUDA若执行仅Thor sm_110。追问：1.ΔX项保护什么方向？2.为什么不等于去均值？3.归一化如何影响alpha？4.Cholesky因子与H逆有何差别？5.batch1为何可能关闭方法？6.公平指标冲突时如何决定上线？

[source.json](source.json)记录失败路径与后来成功阅读；[verification.json](verification.json)仅确认公式例子运行，作者整模型、GPU性能和许可全文仍未验。
