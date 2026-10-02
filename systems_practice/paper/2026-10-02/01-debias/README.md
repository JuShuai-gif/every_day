> 本文与10月1日已登记论文重复，仅保留补充阅读与真实结果，不计10月2日两篇新论文。

# Debias-SparseGPT: Bias-Aware Pruning for Large Language Models

Irina Proskurina、Guillaume Metzler、Antoine Gourru、Julien Velcin。[arXiv2609.02496v1](https://arxiv.org/abs/2609.02496v1)，首次/所读版本2026-09-02，日期距本期30天；[全文](https://arxiv.org/html/2609.02496v1)。作者仓库自述EMNLP2026 Main Conference，未另核官方论文集，记录为作者声明，不由arXiv推断同行评审状态。阅读正文§1–6、算法1、表2–5、Limitations及附录C配置。论文CC BY4.0；代码许可未核实，未复制代码。

## 问题、方法与结果

论文给剪枝重建目标加入配对输入差异项：H=X0X0ᵀ+X1X1ᵀ+2ΔXΔXᵀ；单权重约束解为δw=−wp H⁻¹ep/(H⁻¹)pp。配对差异影响mask及误差补偿。表3里Qwen2.5-7B-Instruct在2:4、StereoSet校准下DTO从SparseGPT的0.616变为0.645，说明不能无条件概括为更好；表4补充UltraChat后作者报告改善。本文测试主要英语基准，不能外推所有任务或公平性定义。

## 复现路线与源码边界

[作者仓库](https://github.com/upunaprosk/debias-llm-compressor)README已读：需要Python3.11和patched llm-compressor0.8.1，区分StereoSet-only/mixed。两次尝试读取`patches/llm_compressor_0.8.1_stereoset.patch`（raw及blob）均Internal Error，因此**核心补丁未读**，不提供猜测原生API，不宣称代码审查完成。复现难度高：先取得固定commit/补丁/许可证，核对配对token对齐、damping与剪枝比例，再用本地checkpoint/校准数据跑作者流程；原文附录C使用双A100 80GB，这只是作者实验配置，不是已核最小显存需求。我们未下载模型或数据。

今后Thor移植先验证SM110后端与稀疏布局，任何CUDA构建只允许sm_110；论文A100数据不是Thor性能。不为这个CPU数学小例子额外伪造GPU代码。

## 本期现成例子与推导

[example.py](example.py)独立构造两维输入，比较alpha=0/1时保留方向。对任意误差δ，目标L=δᵀHδ/2；约束δp=−wp。先由H逆求解，再在剩余方向±0.1/±1扰动验证目标变大，同时检查实际目标等于预测saliency。相同配对时差异项必须为零；奇异矩阵拒绝。只研究一个约束的解，不实现完整块SparseGPT、N:M打包或模型公平性指标。

```sh
sh run.sh
```

标准库Python，无依赖；真实输出见[results/cpu.json](results/cpu.json)。没有训练、真实语言模型、GPU、稀疏存储或推理加速实测；合成二次目标改善不能叫社会偏差改善。

## 失效、验收与追问

故障一：差异项巨大→配对token错位→逐位置核对长度/替换区域→对齐后重算H；回归相同pair差异为零。故障二：H不可逆→样本少或相关性强→检查分解与damping→正则并报告扰动敏感性；不得把数值失败变成静默零权重。故障三：平均任务分数维持但子集退化→保留子集与整体评估，不以本例二次损失替代真实输出验收。

最小验收路线是固定源码/许可、独立calib/eval、检查目标和mask、复核模型/子集指标、最后目标kernel性能；今天只验证独立数学例子。追问：①ΔX为何带系数2？②约束解为何沿逆H列？③damping怎样改变排序？④相同pair退化为什么方法？⑤2:4与非结构稀疏为何不能共享速度结论？⑥代理目标为何不能保证任务表现？
