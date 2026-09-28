# TwinQuant: Learnable Subspace Decomposition for 4-Bit LLM Quantization

[arXiv:2606.01556v1](https://arxiv.org/abs/2606.01556v1) · [一手全文](https://arxiv.org/html/2606.01556v1)

作者：Haodong Wang; Junjie Liu; Zicong Hong; Qianli Liu; Jian Lin; Song Guo; Xu Chen。首次公开2026-06-01，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-25。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

把W拆成UV+R，并用可逆G以及全局正交Q重新参数化，使两个分支和激活的量化误差共同下降；浮点等价并不保证量化后等价。

已读全文中的§3、§4.1，表2。表2 LLaMA3-8B rank32→256：平均零样本准确率68.0→71.1，Wiki PPL11.3→9.3，同时有更大分支成本。arXiv作者备注ICML26接受，未另查会议录。

## 实现来源与复现路线

全文与标题GitHub检索未确认作者官方仓库，不虚构代码链接。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：难：需LLaMA3/Qwen3权重、校准集、流形优化与融合低位kernel；先确认分解等价，再训练变换，最终在Thor移植验收，不能把论文设备收益当本机结果。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

独立2×2因子缩放和离散网格搜索，无SVD/全局Q/流形训练；共享量化组是教学简化。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-25/02-twinquant/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "selected_G": 0.25,
  "calibration_scores": [
    [
      0.2396205057400629,
      0.25
    ],
    [
      0.2396205057400629,
      0.5
    ],
    [
      0.47626030370110406,
      1
    ],
    [
      3.4987743593986598,
      2
    ],
    [
      21.740924620026473,
      4
    ]
  ],
  "test_mse_baseline": 0.542150141119502,
  "test_mse_scaled": 0.27817285624694105,
  "training_updates": 0,
  "scope": "grid search; no manifold optimizer, no SVD or CUDA"
}
```
