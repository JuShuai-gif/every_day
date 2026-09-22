# REAL-Q: E2E LLM Quantization via Dynamic Gradient Descent

[arXiv元数据](https://arxiv.org/abs/2609.00049) · [本次阅读v1全文](https://arxiv.org/html/2609.00049v1)

Qian Zhang、Yaoming Li、Zhewen Tan、Yanshu Wang、Heng Lu、Kun Su、Zongwei Lv、Wenhan Yu、Yongge Ma、Yinjun Han、Ruikuang Liu、Tong Yang。首发 **2026-08-30**，本次读 **v1**（同日），元数据还列 v2 **2026-09-10**；不把修订日期当首发。当前按 arXiv 预印本处理，未核实同行评审录用。读取 §3、§4.1–4.4、§6.3/Table2 的方法和结果。源码搜索没有找到可核实的作者实现，不能声称原仓库复现；检索记录见 [source.json](source.json)。

## 问题、核心思想和结果边界

逐列量化会改变剩余权重面对的误差。论文在每128列量化后，以块输出上的完整聚合 Fisher 二次型做一次 Adam 修正，已量化列保持锁定，并跨块混合损失。形式是 `F=mean(g gᵀ)`、`L=mean(ΔyᵀFΔy)/2`；聚合采用近似，不能等同真实全模型 KL。Table2 的 Qwen3-8B W3A16、group128、256校准序列设置中，WikiText-2 KL（×10⁻²）从 GuidedQuant 11.6 到 REAL-Q 10.8；这是作者数值，不是本机结果，也不是任务准确率的同义词。[方法与表格](https://arxiv.org/html/2609.00049v1)

## 最小复现路线与难度

完整复现**难**：需要真实 LLM、校准语料、PyTorch/Transformers、聚合 Fisher 与 GPTQ 管线，且尚未找到已核实作者代码；模型量级、完整前反向和矩阵存储使本机小示例无法替代。优先先实现/验证小层梯度与冻结掩码，再在已许可本地模型上区分校准、调参和测试，最后验证真实 KL/任务指标。没有估算显存或时间收益，依赖精确版本待作者实现确定。

[example.py](example.py) 为**独立实现的机制实验**：2×4权重、64×4相关输入、人工正定2×2度量。前两列按0.25网格离散并冻结，后两列做一次真实 Adam 更新，校准和评估使用独立随机种子。人工矩阵并非实际 NLL Fisher；省略 GPTQ 解析补偿、Transformer、损失滑窗、最后全量离散导出以及低位 GEMM。此例不是 QAT、不是 AutoRound，也不是全论文复现。

```bash
sh systems_practice/paper/2026-09-22/01-real-q/run.sh
```

仅 Python标准库，本机3.9.6已跑通。验收校验解析梯度与中心差分、冻结列不变、4个剩余参数真实改变、结果有限。示例不以改善损失作为普适正确性断言，允许不同输入产生退化。

## 真实输出与关注点

[原始输出](results/output.json)：梯度最大偏差 `1.53855e-11`；校准损失 `0.0378106→0.0194614`，独立评估 `0.0397109→0.0214000`。两个同欧氏范数误差的二次型惩罚分别2.5与0.5，说明交叉通道项改变优化方向。这里的损失是人工二次型，不能叫语言模型 KL，更不能声称约49%的模型收益被复现。

未测模型准确率、压缩文件、内存峰值、性能或功耗；无 GPU代码，本期不生成 PTX/SASS。未来 CUDA 实验只允许 Thor SM110，禁止照抄其他架构执行命令。状态见 [verification.json](verification.json)。
