# AlphaQ: Calibration-Free Bit Allocation for Mixture-of-Experts Quantization

[arXiv:2606.04980v1](https://arxiv.org/abs/2606.04980v1) · [一手全文](https://arxiv.org/html/2606.04980v1)

作者：Wanqi Yang; Yuexiao Ma; Alexander Conzelmann; Xiawu Zheng; Michael W. Mahoney; T. Konstantin Rusch; Shiwei Liu。首次公开2026-06-03，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-26。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

从权重谱估计Hill指数，构造重要性加权噪声eta=(median(alpha)/alpha)^gamma*Var(W)*2^(-2b)，在全局位预算内选择各层位宽。免校准指位分配，论文后续GPTQ仍用了校准样本。

已读全文中的§3.2/3.3，§4.1和结果表。Qwen1.5-MoE在平均2.5bit时表中AlphaQ平均准确率65.17，Uniform51.99；非专家层固定4bit，不能把平均专家位宽当全模型实际字节。谱度量是代理而非任务损失保证。

## 实现来源与复现路线

[作者仓库](https://github.com/Superone77/AlphaQ)。树确认quant/models/评估目录；categories.py raw请求internal error，核心算法/许可证/commit待核实。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：中→难：先求小矩阵谱并解预算，再用PyTorch/FARMS、ILP求解器、MoE权重及WikiText2校准GPTQ，最后测任务与元数据存储。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

合成谱Hill估计+三层穷举预算；gamma固定1，无FARMS、GPTQ、打包或模型推理。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-26/01-alphaq/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "alpha": [
    1.6968534938244006,
    4.149082688439194,
    2.061633772642998
  ],
  "bits": [
    4,
    2,
    4
  ],
  "payload_budget_bits": 96,
  "used_bits": 96,
  "objective": 0.0390239412069643,
  "uniform3_objective": 0.06292906717498943,
  "scope": "nominal bit budget only; no packed model or inference"
}
```
