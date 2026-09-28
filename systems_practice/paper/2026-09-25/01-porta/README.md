# Prune Once: Retraining-Free Task-Agnostic Pruning for Vision-Language Models

[arXiv:2608.06901v1](https://arxiv.org/abs/2608.06901v1) · [一手全文](https://arxiv.org/html/2608.06901v1)

作者：Minseok Kang; Hyunwoo Kim; Chanyoung Kim; Minwoo Kim; Jaekoo Lee; Dahuin Jung。首次公开2026-08-07，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-25。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

用校准特征方差而非单看均值幅度衡量通道信息，权重分数Sij=Var(Xj)*abs(Wij)，结合输出方差分配层稀疏率。

已读全文中的§3.1–3.3，表1/2。表2删除15%低方差特征检索准确率67.28，删高方差降至0.02；这个消融不能证明所有数据上方差最优，均值携带的偏置和跨模态分布变化仍须检查。arXiv作者备注Accepted ECCV2026，未另查会议录。

## 实现来源与复现路线

[作者仓库](https://github.com/cau-hai-lab/PORTA)。仓库树和prune.py请求可达；核心pruners算法阅读待补，示例只从论文公式独立实现，未声称调用上游。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：中：需PyTorch、CLIP/BLIP/Qwen2-VL与通用校准集；先复现固定层分数，再做跨任务稀疏分配、任务评估和稀疏后端验收。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

独立三通道方差/均值幅度选择，保留丢弃常数偏置的反例；没有模型级稀疏分配或重训。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-25/01-porta/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "variance": [
    9.564585851910356e-05,
    4.078599239877162,
    0.15212875202491943
  ],
  "scores": [
    9.564585851910357e-06,
    4.078599239877162,
    0.04563862560747583
  ],
  "variance_keep": 1,
  "mean_magnitude_keep": 0,
  "heldout_mse_by_single_kept_channel": {
    "0": 3.3209746525678208,
    "1": 1.004566282427348,
    "2": 3.862765314508538
  },
  "training_updates": 0
}
```
