# Q-DEQ: Discrete Solving and Quantization for Deep Equilibrium Models in Time Series Forecasting under Edge Deployment Coding Constraints

[arXiv:2609.24042v1](https://arxiv.org/abs/2609.24042v1) · [一手全文](https://arxiv.org/html/2609.24042v1)

作者：Ruotong Yang; Hongdong Zhu; Qi Gao; Yin Ma; Hai Wei; Kai Wen。首次公开2026-09-21，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-26。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

在DEQ固定点附近用有限差分近似残差方向变化，编码局部系数为二进制，最小化二次能量。固定点求解保持连续精度，W8A8只加在re-forward，是另一阶段。

已读全文中的§3.1–3.4，§4/5.1–5.3，表2–5。96预测步、3种子，ETTh2 MSE0.3013→0.2978，但ETTh1 0.3866→0.3978；静态权重缩小不说明求解更快，每方向额外前向有成本。

## 实现来源与复现路线

全文及标题GitHub搜索未确认官方实现；不调用未知Kaiwu接口。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：难：需iTransformer、五时间序列数据、隐式反传和SA/CIM后端。先验证局部二次能量，再扩到真实DEQ并拆分求解/再前向耗时。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

独立二维收缩映射和16级系数穷举，只做一次局部求解；无W8A8/QAT或CIM。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-26/02-qdeq/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "coefficients": [
    1.0,
    -0.19999999999999996
  ],
  "local_energy": 0.0009999999999955609,
  "actual_energy": 0.0010000000000000018,
  "initial_energy": 0.32499999999999996,
  "codes_enumerated": 256,
  "training_updates": 0,
  "scope": "one local step; no implicit backward or W8A8 training"
}
```
