# Prune, Update and Trim: Robust Structured Pruning for Large Language Models

作者Diego Coello de Portugal Mecke、Tom Hanika、Lars Schmidt-Thieme；[arXiv:2605.18331](https://arxiv.org/abs/2605.18331)，首次公开2026-05-18。2026-10-08实际读取[全文v1](https://arxiv.org/html/2605.18331v1)第3.1/3.2节和实验表1/2；v2在2026-07-13修订，本课未读v2，不把修订日期称为首发。预印本，未核实同行评审发表。

## 问题与两个机制

对边缘LLM仅按幅值删除MLP通道会改变下一层输入，而保留权重原值通常无法利用剩余通道携带的相关信息。Putri把结构选择与输出投影更新耦合，并按层传播更新后的激活。核心不是一个“更小mask”文件，而是真正改变矩阵形状和剩余权重。

机制一：根据校准激活的重要性选择要保留的MLP通道，同时裁剪配对的输入/输出投影维度；GQA则必须按共享KV head及其query组的关系裁剪。只改一个权重张量会导致shape不匹配或语义错位。本课只实现两通道线性模型，不实现GQA或完整SwiGLU。

机制二：令校准激活为X，原输出Y=XW，保留列后的激活为Xp，重拟合`W' = argmin ||Xp W' - Y||² + lambda ||W'||²`。满秩时解为`(Xp^T Xp + lambda I)^(-1) Xp^T Y`，实际算法应通过分解/求解处理病态性而非盲目求逆。源码带阻尼和回退路径。后续层要用已修改网络重新采集输入；拿全原模型激活给每层独立拟合会低估误差传播。

本例固定剪到一个通道，用训练校准seed1的128个样本求和得到闭式权重，用独立调参seed2选择lambda∈{0,.1,1,10}，仅最后使用测试seed3；seed4反转通道相关性，专门检测泛化失败。该闭式更新把权重从1改到2.607178，是**真实参数更新**，不是只算正则项；没有SGD或完整网络训练，也不是QAT。

知识图谱：`校准激活 → 通道排序 → shape联动裁剪 → 剩余投影最小二乘 → 后层重采样`；`相关性/条件数 → 阻尼 → heldout验证 → 分布漂移回退`。

## 作者结果与边界

作者表1在50%稀疏率的Qwen3-14B上报告WikiText困惑度2SSP为23.53、Putri为18.19，原模型8.641；同一表的Llama3.1-8B，2SSP为34.75而Putri为39.25，Putri反而更差。**这些是作者完整模型实验，不是本地实测，且并非所有模型都提升。** 极高剪枝率仍有很高困惑度，有限数值不等于可用质量。参数减少也不必然线性缩短设备延迟。

## 真正读过的作者实现

仓库[Coello-dev/Putri](https://github.com/Coello-dev/Putri)浅克隆成功，固定commit **a840e31c7ea11cbbacf37a5ba13d05835f7f7167**。以下为2026-10-08实际读取，不把仓库首页当算法阅读：

- [src/widthmerge_aux.py](https://github.com/Coello-dev/Putri/blob/a840e31c7ea11cbbacf37a5ba13d05835f7f7167/src/widthmerge_aux.py)：hooks收集中间量、逐层修改后重新forward，追踪调用pruner统计与更新。
- [src/widthmerge_utils/twossppruner.py](https://github.com/Coello-dev/Putri/blob/a840e31c7ea11cbbacf37a5ba13d05835f7f7167/src/widthmerge_utils/twossppruner.py)：`TwoSSPPruner.add_batch`累计H/XY及通道统计，`get_prune_mask`和`get_linear_output_updated_weight`执行选择与有阻尼的权重更新。
- [src/widthmerge_utils/basepruner.py](https://github.com/Coello-dev/Putri/blob/a840e31c7ea11cbbacf37a5ba13d05835f7f7167/src/widthmerge_utils/basepruner.py)：`update_layer`把保留索引落实到权重形状。
- [main.py](https://github.com/Coello-dev/Putri/blob/a840e31c7ea11cbbacf37a5ba13d05835f7f7167/main.py)与[requirements.txt](https://github.com/Coello-dev/Putri/blob/a840e31c7ea11cbbacf37a5ba13d05835f7f7167/requirements.txt)：读取入口和依赖；torch2.7.0、transformers5.3.0、numpy1.26.4、datasets3.2.0等。列出的依赖组合未在本机安装或验证。

仓库根目录未发现LICENSE；**代码许可未核实**，不把论文CC BY-SA4.0自动当源码许可证。本例仅从论文最小二乘机制独立实现，未复制作者实现。源码原场景是完整LLM结构剪枝；本例保留“剪列后更新剩余权重”，简化为单输出、一维求解，不包含逐层hooks/GQA/原始数据集。

## 复现路线与运行

本地例子易，只需Python3标准库，无下载。完整复现难：须已有本地LLM及tokenizer、可验证的校准与独立任务评估数据、足够内存/显存，以及作者依赖环境。先用作者入口的`--help`核对当前参数，再在最小一层上核对保留索引、权重shape和输出误差，逐层扩展并保留未剪枝基线；许可未清楚前不分发衍生实现/模型。本课未执行作者入口，不声称它兼容Thor。

```sh
# 工作目录：EveryDay根目录；现成示例，不增加每日编码任务。
sh systems_practice/paper/2026-10-08/02-putri/run.sh
```

输入shape[128,2]与W[2,1]，Python双精度；[example.py](example.py)的中文注释标出校准/调参/最终测试分离。[真实输出](results/output.json)：保留通道0，weight1→2.607178149；test MSE `0.807648083→0.003655477`，shift MSE `0.991686802→3.982276137`。参数2→1只是本例参数计数，不包含文件头/框架开销。零激活的奇异校准路径被拒绝，未把除零当成功。未测性能或全模型困惑度。

GPU迁移执行目标只允许Thor SM110，需重新核实torch与其CUDA工具链构建和后端支持；作者torch2.7.0依赖清单不能直接视为Thor兼容性证明。CPU机制例子不产生GPU kernel、PTX/SASS或NPU性能结论。[source.json](source.json)与[verification.json](verification.json)分开记录阅读、运行及未完成全模型复现。

## 工业故障链与验收

| 触发→信号 | 根因/诊断 | 修复与回归 |
| --- | --- | --- |
| 校准重建很好，线上误差更高 | 被剪通道与保留通道的相关性变了；独立shift评估 | 加入代表性校准、阻尼及保留通道候选；不能用测试集反复选lambda |
| 剪完shape正确却出现NaN/异常权重 | H近奇异；检查条件性与求解残差 | 合理阻尼、分解失败回退与零输入测试；记录回退比例 |
| 多层单独测试好，串联后退化 | 下游仍用原网络校准激活 | 每层更新后重采集下一层输入，记录逐层误差及任务分数 |

追问：1. 为什么只删权重不更新会浪费相关性？2. 何时最小二乘不可辨识？3. 阻尼改善了什么又偏置了什么？4. GQA为何不能独立剪一个query或KV head？5. 为什么重采样能影响下游mask？6. 参数减少怎样转换成板端延迟验收？
