# Efficient Quantization-Aware Distillation with Cross-Modal Alignment for Edge Vision–Language Models

[arXiv:2609.16689v1](https://arxiv.org/abs/2609.16689v1) · [一手全文](https://arxiv.org/html/2609.16689v1)

作者：Jinwoo Jeon; GyuYeop Do; Yubin Lim; Nam-Joon Kim; Hyun Gon Ryu; Hyuk-Jae Lee; Byung-Jun Lee。首次公开2026-09-15，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-27。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

以冻结教师作为量化学生的语义锚，联合关系蒸馏与对称InfoNCE；非RGB查询RGB键值做跨模态注意力。仅关系距离无法约束整体语义旋转。

已读全文中的§3.1/3.2，§4.1和表1/3。表1 INT8 DAT-T ScanNet非RGB47.9→49.0；表3 ViT-S训练12→2.25小时但吞吐461→351图/秒，不能宣称全面提速，适配器还增加存储。

## 实现来源与复现路线

全文及标题GitHub检索未核实官方训练代码，不把其他EdgeVL仓库当本文实现。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：难：需PyTorch/OpenCLIP ViT-G教师、学生骨干、同步RGB-D/多光谱样本，先验损失再做30epoch量化训练与导出。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

四个二维向量的整体旋转反例，计算真实对称InfoNCE和关系误差；无参数更新或QAT。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用Python3标准库，无第三方依赖。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-27/01-edge-distill/run.sh
```

[代码](example.py) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；没有神经网络训练更新，不能当作完成QAT。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
{
  "distance_mse_rotated": 0.0,
  "teacher_anchored_nce_rotated": 1.6265233750364456,
  "teacher_anchored_nce_aligned": 0.6265233750364456,
  "training_updates": 0,
  "scope": "loss invariance counterexample; no QAT or cross-attention training"
}
```
