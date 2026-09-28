# A Hardware-oriented Approach for Efficient Bayesian Inference Computation and Deployment

[arXiv:2607.17855v1](https://arxiv.org/abs/2607.17855v1) · [一手全文](https://arxiv.org/html/2607.17855v1)

作者：Nikola Pižurica; Matteo Risso; Nikola Milović; Alessio Burrello; Igor Jovančević; Conor Heins; Miguel de Prado。首次公开2026-07-20，阅读v1（版本日期同首发），实际阅读/补课2026-09-28，归档2026-09-24。均在近180天内且早于归档日期。发表状态以arXiv记录为准，会议接受备注不当作已独立核验会议录。

## 问题、机制与作者结论

把不同形状的张量收缩并成规则批次，或展平并放入块对角矩阵；用分组限制填零开销。合并两块新增零元素数为r1*c2+r2*c1。

已读全文中的§III-C/D，§IV/V，770配置实验说明。作者在Jetson AGX Orin上770个POMDP配置报告典型2–2.5倍、最高5倍；该数值不能外推Thor。只支持平凡B依赖、padding会放大工作集，收益依赖形状。

## 实现来源与复现路线

v1明确双盲阶段不公开链接；不能宣称已读作者实现。v2日期2026-07-21，本课只读v1。 [source.json](source.json)记录实际读取边界，来源未完整核验的部分进入backlog。

复现难度：中：本地C++仅矩阵布局等价；完整路线需JAX及FPI/VMP/MMP实现、770配置生成和目标设备profiling。作者Orin仅历史对照，新增CUDA执行始终Thor SM110。 不安装依赖、不自动下载模型或数据；小示例与论文复现分别验收。

## 已写好的机制示例

C++17小块对角布局与原始两次矩阵向量乘比较，是真实CPU布局检查，不是GPU复现。 这是独立教学实现，不声称参考了未读到的仓库函数。输入是代码中的固定小张量/合成数据，使用C++17编译器。

在EveryDay根目录运行：

```sh
bash systems_practice/paper/2026-09-24/02-bayes/run.sh
```

[代码](src/example.cpp) · [真实原始输出](results/cpu.txt) · [验证状态](verification.json)。本次退出码0，实际输出已归档。计算训练或校准指标时，不使用heldout选择参数；不把标量数学例子或CPU存储模型称为GPU/NPU加速。

## 阅读边界

只有机制例子在Mac运行。没有复现作者完整模型、任务指标、设备吞吐或能耗；只验证CPU布局等价，没有生成GPU代码或冒充GPU性能。 后续若涉及CUDA/PTX/SASS，目标固定Thor SM110，需独立提供基线、优化候选与ncu证据。本文作者使用其他设备的结果仅作原论文背景，不切换本项目执行目标。

### 本次小例子的真实输出

以下来自本机 2026-09-28 执行，只代表上述教学范围：

```text
max_error=0 original_values=10 merged_values=20 padding_values=10
max_error=0 original_values=10 merged_values=20 padding_values=10
```
