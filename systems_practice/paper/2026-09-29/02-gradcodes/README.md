# GradCodeS：在可部署量化码上选择更新

Shiguang Wu、Zhouchen Lin、Quanming Yao；[arXiv:2608.30908v1](https://arxiv.org/abs/2608.30908v1)，首发/所读版本日期均2026-08-31。2026-09-29实际阅读[一手全文](https://arxiv.org/html/2608.30908v1)§3–4、Algorithm1、§5.1–5.2与Table1。当前按预印本记录，不宣称已通过同行评审。

部署权重由码本索引Z和scale决定；权重梯度必须乘scale与下降方向的相邻码本间距，才能衡量一次码移动。梯度只引导候选，最终把当前状态也纳入集合，按真实损失接受更新。Table1报告Qwen3-0.6B GSM8K：GradCodeS LoRA全4位45.72±0.42，FP16 SFT39.65±0.54（三种随机种子）；这是所选任务、模块和训练协议的作者结果，不说明低位普遍更准或Thor更快。

## 可运行机制实验

```sh
sh systems_practice/paper/2026-09-29/02-gradcodes/run.sh
```

[example.py](example.py)独立实现2权重回归、4值非均匀教学码本，训练/评估各32样本且种子分离。80步实际scale更新、每步8个带梯度偏置的相邻候选，以当前训练损失筛选；验证论文式(4)的一阶项等价和每次离散选择不增损失。候选采样简化为Bernoulli，不是作者采样器；码本为教学2bit，不能称NF4/INT4/MXFP4。真实码打包到1字节，额外码本+scale序列化24字节，清楚展示小张量metadata成本。

[实际输出](results/cpu.txt)：2次离散码变化，heldout MSE从0.521886995降到1.10914416e-5。没有优化器/内核吞吐或LLM任务复现结论。本例只用Python3标准库，不需torch、不下载模型。

## 复现路线与源码边界

完整复现难度中到难：需已有Qwen/Llama权重、数据、torch/transformers/datasets、作者评估环境与兼容GPU；资源下限未实测。先通过小例子，再固定源码与数据、核对量化模块集合、训练预算和导出重载，最后做任务评估。

[作者仓库](https://github.com/ovo67/GradCodes)main：已读README、`src/train_gradcodes.py`入口/import/parse_args范围。训练入口导入GradcodesLinear、离散采样和state导出；其文件开头明确说是实用研究框架，不是论文每项细节的直接复现。仓库有src/eval/baselines，但本次未完整审核核心gradcodes文件，requirements请求失败，根树未见许可证。精确commit和完整导出/评估状态待补，不提供猜测的小层原生API。任何后续CUDA构建/执行固定Thor SM110；本例是CPU数值算法，无原生低位Tensor Core或SASS声明。

[source.json](source.json)、[verification.json](verification.json)区分全文阅读、源码局部读取与独立示例运行。代码/许可证/后端审计进入backlog。
