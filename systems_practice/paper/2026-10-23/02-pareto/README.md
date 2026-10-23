# 多目标结构剪枝：预算、质量与延迟分别验收

原文：[arXiv:2607.22583v1](https://arxiv.org/html/2607.22583v1)，**Multi-Objective Structured Pruning of LLMs for Latency and Model Size Optimization**，Muhammad Junaid Ali、Smail Niar、El-Ghazali Talbi。arXiv元数据首发2026-06-08（不能由ID前缀猜日期），最新v3为2026-10-17并标注Accepted for presentation at ICTAI2026；本课实际读v1，不把新修订当新首发。处于180天内。2026-10-23读§III/算法1、§IV、§V/TableI及方法限制；作者仓库未从全文/精确标题检索核实，许可不明，独立代码不调用猜测API。

## 问题、关键步骤与作者结论

第一阶段删除整个MHA/MLP子块，以KL和参数数目形成Pareto候选；第二阶段通过并行贝叶斯优化分配剩余层内删减预算，再按重要性去掉关联head/neuron。结构组须一起处理Q/K/V/O或gate/up/down切片，不能只置零某个张量。

作者在四类模型、37.5%/50%比例比较，§V/TableI报告整体平均分较强，同时承认部分单项由其他方法更高；不能解释为每任务均赢。§IV把“Jetson Nano”与Ampere/1024 CUDA cores/64GB描述混在一起，平台身份有明显核验缺口；**本课不采用其板端延迟作为可迁移结论**，应要求设备型号和原始日志。论文参数预算也不能直接替代Thor延迟。

## 独立小例与实际输出

[example.py](example.py)仅用Python标准库，3个2×2残差tanh块，不含attention、Transformer或贝叶斯优化。枚举8个结构，cal计算KL，提取参数数目/KL的Pareto前沿，8参数预算下由独立tune选方案，独立test只在最后评价。导出只写保留的矩阵和1B结构mask，不保留零化的原矩阵；重载逐输出检查。零块/零输入是边界。

```sh
sh systems_practice/paper/2026-10-23/02-pareto/run.sh
```

[真实输出](results/run.txt)：选(1,0,1)，文件33B，对比完整FP32权重载荷48B；test KL约0.0001390。预热10次后采31个“31输入整批”样本，CPU Python批耗时P50完整79.166µs、删块56.834µs。它是合成CPU解释器测量，不是每请求P95、LLM吞吐或GPU/NPU/E2E。两方案数学输出不同，质量差异通过KL报告，不能当作等价kernel优化。

## 复现难度与最小路线

完整复现难：需作者搜索/分组删除/模型重载/评估代码、对应模型与数据、PyTorch2.1/Transformers/lm-evaluation-harness（原文未给完整lockfile）及搜索预算。作者实验A10080GB不能复制为本课执行命令；本项目后续CUDA仅Thor SM110，先确认框架和SDK支持。最小路线先在本地小模型核对组依赖和结构导出，再在目标设备采延迟，重新构建候选集合，最终留出测试评估。

- 参数数变少但延迟不降→矩阵形状不适配kernel或小batch启动占比高：检查目标profile和真实shape，重新量测候选，不能按稀疏率估速度。
- 内存不降→只绕过forward但checkpoint仍保留矩阵：比较导出文件/加载后tensor storage与峰值RSS，物理移除并重载回归；本例专门覆盖此区别。
- 结构删除后shape异常→关联切片不一致：用小shape检查组依赖/残差维数，禁止静默padding掩盖问题。

追问：Pareto支配如何定义？KL小是否保证任务分数不变？head为何必须关联删除？forward跳过和物理移除有什么不同？为什么目标设备上必须重新评估？搜索与测试数据如何隔离？

[verification.json](verification.json)区分CPU独立机制与作者完整复现；原仓库/真实硬件身份问题进入backlog。
