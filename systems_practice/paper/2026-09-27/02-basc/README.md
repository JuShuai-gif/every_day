# BASC: Behavior-Aligned Quantization and Pruning for Low-Bit Spiking Neural Networks

[arXiv:2608.19239v1](https://arxiv.org/abs/2608.19239v1) · [一手全文](https://arxiv.org/html/2608.19239v1)

作者：Linliang Chen; Yan Zhong; Xin Liu; Sai Li; Wang Kang。首次公开2026-08-12，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-27。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

LIF膜电位的阈值使小权重变化改变放电时间。TSC用时间任务损失学习scale，BIC重评剪枝边界附近通道间的相互作用。权重误差最小不一定对应行为误差最小。

已读全文中的§3.1–3.3、§4.1与图2扫描。作者冻结模型后scale扫描：重建误差在倍率0.90最小而验证准确率在1.00最好；VGG16裁剪率2.43%→0.38%，这不是本地测量。代理梯度和任务数据会改变结论。

## 实现来源与复现路线

全文与标题GitHub搜索未确认官方仓库；不编造训练API。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：中→难：需PyTorch/SNN训练框架、CIFAR或事件数据、展开时间步与代理梯度；先检查膜电位轨迹，再训练TSC，再验证结构剪枝真实收益。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

独立LIF轨迹和scale扫描，校准/评估拆开；无可学习scale更新、TET训练或BIC剪枝。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-27/02-basc/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "sweep": [
    {
      "alpha": 0.25,
      "weight_mse": 0.030270720498001138,
      "cal_spike_mismatch": 11,
      "test_spike_mismatch": 14
    },
    {
      "alpha": 0.35,
      "weight_mse": 0.013275978533980456,
      "cal_spike_mismatch": 16,
      "test_spike_mismatch": 15
    },
    {
      "alpha": 0.45,
      "weight_mse": 0.0030230889942722476,
      "cal_spike_mismatch": 4,
      "test_spike_mismatch": 6
    },
    {
      "alpha": 0.55,
      "weight_mse": 0.0017529944713588232,
      "cal_spike_mismatch": 7,
      "test_spike_mismatch": 7
    },
    {
      "alpha": 0.65,
      "weight_mse": 0.008615381160641323,
      "cal_spike_mismatch": 7,
      "test_spike_mismatch": 8
    },
    {
      "alpha": 0.75,
      "weight_mse": 0.0059295865476774075,
      "cal_spike_mismatch": 4,
      "test_spike_mismatch": 6
    },
    {
      "alpha": 0.85,
      "weight_mse": 0.00684659929216619,
      "cal_spike_mismatch": 4,
      "test_spike_mismatch": 9
    }
  ],
  "selected_on_calibration": 0.45,
  "training_updates": 0,
  "scope": "scale sweep only; no TSC surrogate-gradient training or BIC pruning"
}
```
