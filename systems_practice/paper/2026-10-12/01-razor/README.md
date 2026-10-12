# RAZOR：专家贡献大小不等于删除代价

Mingyang Song、Mao Zheng，**RAZOR: Pruning Replaceable Experts in LLMs**，[arXiv:2609.30465v1](https://arxiv.org/abs/2609.30465v1)，首发/所读版本2026-09-24，读取2026-10-12。按预印本处理，未核实同行评审接收。实际阅读[原文](https://arxiv.org/html/2609.30465v1)第2节Eq1–4、第3节实验配置/表1及限制段；未声称逐页审过所有附录。

## 问题、推导与作者结果

MoE只激活少量专家却仍存整池权重，剪掉专家可减少存储。但专家输出小不等于可替代：删除还会改变存活专家权重，并可能把下一个专家补进top-k。

固定层输入，混合输出 `c=Σ wi fi`，残差`ri=fi-c`。删专家i并补入r，局部改变范数为 `||wi ri - wr rr||/(1-wi+wr)`；不补位就是`wi||ri||/(1-wi)`。作者再对路由到该专家的校准token做条件RMS，并按层预算保留高分者。单专家恒等式不能保证联合删除最优，分母和残差抵消使代价不可简单相加；部署后的多层激活也会改变。

作者表1：GLM-4.7-Flash删除50%专家时，九任务宏平均RAZOR 40.1、匹配REAP 34.5、原模型44.8。这是作者在该模型/任务聚合口径下的结果，不是本机复现，更不是时延数字；生成格式、终止行为仍需单独评估。

## 作者代码与复现路线

[作者仓库](https://github.com/nick7nlp/Razor)，实际固定commit `e83ca5c2701108b6158ce10c6c5d719bb7f4f1dc`，Apache-2.0。实际读：

- [collect.py](https://github.com/nick7nlp/Razor/blob/e83ca5c2701108b6158ce10c6c5d719bb7f4f1dc/razor/collect.py)的collector残差/refill段：先做向量差再求范数，累加sum/square_sum和routed_count；分母有下限。
- [metrics.py](https://github.com/nick7nlp/Razor/blob/e83ca5c2701108b6158ce10c6c5d719bb7f4f1dc/razor/metrics.py) `canonical/resolve/_validate_moments/score`：RAZOR映射RCS-refill，默认RMS，检查统计一致性及路由支持条件。
- [prune.py](https://github.com/nick7nlp/Razor/blob/e83ca5c2701108b6158ce10c6c5d719bb7f4f1dc/razor/prune.py) `resolve_target_experts/validate_keep_indices/select_keep_indices`：预算、top-k、重复索引和路由组配额约束。

目录可见模型adapter、checkpoint和评估相关代码，不等于今日完整审核训练/导出/评估。实际下载名为`geometry.py`的内容是数据打包/分片统计，未据文件名声称读到几何评分，随后追到collect/metrics。无恢复训练是方法设定，不是“缺训练代码”的缺陷。来源哈希见[source.json](source.json)。

完整复现难：需匹配PyTorch/Transformers、相应本地MoE权重、MoECal和评估数据、足够设备内存；今天未核定精确依赖矩阵与最低显存。最小路线：固定commit→审查adapter路由重构→小层比较直删与残差公式→真实校准→保存物理剪枝权重→独立任务评估/自由生成→设备分阶段测量。不安装或下载大模型。CUDA若开展只允许Thor SM110，作者原平台结果不能当Thor支持证据。

## 可运行独立例子

```sh
sh systems_practice/paper/2026-10-12/01-razor/run.sh
```

Python3.9.6标准库；[example.py](example.py)独立实现固定标量混合，不调用作者API。1000个随机例核对公式与直接重算；两组相同输出范数`(8,3,±10)`最小删除对象发生变化；补位抵消得到0；全删无剩余质量拒绝。[真实输出](results/output.json)。省略向量网络、跨token RMS、模型导出和数据集，无参数训练或设备计时。

## 故障分析、局限与追问

故障一：把两项残差范数相减→丢失方向导致剪枝排名错→比较直接重构与向量差→保留先相减后求范数；示例1000次是局部正确性回归。故障二：分片重复token或RMS口径变成均值→分数失真→检查routed_count、sum/square_sum及样本ID→按作者统计合同合并，额外保存覆盖记录。故障三：任务分数保留但自由生成更早停止→局部距离不约束生成动态→另测终止/格式，不用单一困惑度代替。

迁移验收必须记录固定支持/补位路由、保留数≥top-k、独立校准/评估、精度与实际存储、冷/热加载和端到端时延；小例子不代表已完成。追问：为什么有`1-wi`分母？补位何时抵消？条件RMS与全token均值差什么？单删分数为什么不可相加？模型缩小为何未必降低单token计算量？
