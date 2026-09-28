# Breaking the Compression Barrier: Cross-Architecture Compression Boundary Learning via Reverse Regrowth

[arXiv:2608.16010v1](https://arxiv.org/abs/2608.16010v1) · [一手全文](https://arxiv.org/html/2608.16010v1)

作者：Zhaocen Liu; Satvik Praveen; Yi Sheng。首次公开2026-08-17，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-24。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

先越过剪枝崩溃点，再从损坏严重的层恢复关键连接；论文用层表征相似度筛选和策略梯度分配恢复预算。离散二阶准确率差用于识别性能骤降。

已读全文中的§3.1–3.3，§4及表2。作者报告CNN/Transformer高稀疏区间恢复有效，摘要最高提升1.49/4.77个百分点分别对应非结构/结构剪枝；并非任意网络保证。RL搜索和微调成本不应忽略，非结构零权重也不自动加速。

## 实现来源与复现路线

[作者仓库](https://github.com/EnumaCaliber/BRIDGE)。仓库树确认训练/剪枝/恢复脚本存在；regrowth_greedy.py raw请求internal error，未读到核心实现，许可证/精确commit待核实。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：中→难：标准库例子秒级；完整复现需PyTorch、CIFAR10或TinyImageNet、对应网络checkpoint及训练GPU，先复现一条稀疏率曲线，再加RL控制器。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

独立贪心恢复小线性模型，保留校准误差和heldout检查；没有SSIM、REINFORCE或微调。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-24/01-bridge/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "path": [
    {
      "restored": 5,
      "kept": 1,
      "cal_mse": 24.43033562712139,
      "heldout_mse": 14.562779731714143
    },
    {
      "restored": 4,
      "kept": 2,
      "cal_mse": 10.80283015217998,
      "heldout_mse": 6.095272844279125
    },
    {
      "restored": 2,
      "kept": 3,
      "cal_mse": 5.1778573024165695,
      "heldout_mse": 6.236198985415327
    },
    {
      "restored": 1,
      "kept": 4,
      "cal_mse": 0.21404865459352798,
      "heldout_mse": 0.3138364568591224
    },
    {
      "restored": 3,
      "kept": 5,
      "cal_mse": 0.045513214591232,
      "heldout_mse": 0.03850620801332547
    },
    {
      "restored": 0,
      "kept": 6,
      "cal_mse": 0.0,
      "heldout_mse": 0.0
    }
  ],
  "training_updates": 0,
  "scope": "greedy restoration only; not BRIDGE policy"
}
```
