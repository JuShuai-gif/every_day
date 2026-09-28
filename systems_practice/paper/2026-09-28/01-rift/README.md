# Rift：先筛选图块，再分配 token

**Exploiting answer-invariant redundancies in satellite imagery for efficient VLM inference on edge**，Ishani Janveja、Davis Zhang、Seoyul Oh、Deepak Vasisht。首次公开及所读版本：2026-09-24，arXiv:2609.29029v1；[元数据](https://arxiv.org/abs/2609.29029)、[一手全文](https://arxiv.org/html/2609.29029v1)。正文带 ML for Systems workshop 字样，但没有另行核实录用，按预印本处理。

实际阅读 §2.2–2.3、§3、图3及附录A/B。场景是卫星高分辨率图像 VQA：先按查询相关性过滤瓦片，再为保留瓦片选择视觉token预算。决策公式是 `Ahat(c)=p*alpha_pos(c)+(1-p)*alpha_neg(c)`，最大化 `Ahat(c)-lambda*E(c)`。概率、准确率曲线与设备成本需要独立校准，不能用当前样本真值决策。

作者在60W模式 Jetson AGX Orin、RemoteCLIP与LLaVA1.5-7B、xView/GLH-Bridge上报告，相对全瓦片基线节能78%、延迟降69%；阈值0.37偏向召回，误删不可在后级恢复。这是作者场景数据，不是Thor测试，也不是普适提速。附录公开任务构造；当日全文与定向搜索未找到可核实作者训练/部署仓库，不能提供猜测的原生 API。缺失项进入 backlog。

**完整复现难度：难**。需要对应视觉/语言模型、图块数据与标签、概率预测器训练、每档token的条件精度和板上能耗标定。最小路线是先在本地少量已授权影像上保存查询/瓦片分数和标签，划分校准与评估集，再固定策略评估误删，最后在 Thor SM110 单独重测能耗与延迟；不自动下载模型。作者 Orin结果只作对照，不生成Orin CUDA命令。

**现成小例子**：[example.py](example.py) 仅用 Python 标准库，运行：

```sh
sh systems_practice/paper/2026-09-28/01-rift/run.sh
```

本地真实输出 [results/output.json](results/output.json)：概率 `[.05,.25,.65,.95]` 的预算选择 `[16,16,64,64]`；合成阈值保留图块1/2/3；原分布召回1.0，偏移分布2/3。4个lambda单调性案例、空输入/非有限输入拒绝通过。等分数时全留是本例自己的保守策略。

示例直接给定合成概率、条件准确率和任意单位成本，**没有预测器训练、图像推理或真实能耗**；验证的是选择公式及不可逆误删风险。没有设备性能、任务准确率或完整论文复现结论。它用数学决策解释部署取舍，未调用作者源码。

[来源记录](source.json) · [验证](verification.json)
