# Capability Scaling-Down Laws for LLM Compression

## 文献与实际阅读

Xueqi Cheng、Liang Wu、Kelly Wan、Liangjie Hong、Yushun Dong；[arXiv:2610.02462v1](https://arxiv.org/abs/2610.02462)，首发/所读版本2026-10-01，预印本，未确认会议接收。读取日2026-10-13：[全文](https://arxiv.org/html/2610.02462v1)第2节定义、4节公式、5节表1/表2及6节选择目标；并非声称逐字审阅所有附录。论文CC BY4.0。

## 问题、机制与作者结果

作者研究同样压缩预算为何损伤不同能力。剪枝响应写成状态幅度A(x)乘共享密度曲线`((1-d)/0.3)^gamma`；能力以固定探针上的条件交叉熵变化计量，不能跨tokenizer直接比较绝对值。新状态和QA不必适合相同曲线。表1的Pythia magnitude数学MAE为半网格0.073、全网格0.060 nats/token；这是预测误差，不是任务准确率。系数要对新设置重拟合；接近零变化时复杂预测未必胜过零基线。第6节在可行预算内选择预测损失最小配置，另比较固定方法优先级。[正文与表1](https://arxiv.org/html/2610.02462v1#S5.T1)。

## 作者实现与边界

论文旧链接LabRAI/scaling_down_law实际检索迁至[nokia-applied-research/Scaling_down_law](https://github.com/nokia-applied-research/Scaling_down_law)，读取commit `e5b1243c98d8fa016303b9cfcad1f6748db0e6ad`的[analysis/final_rule.py](https://github.com/nokia-applied-research/Scaling_down_law/blob/e5b1243c98d8fa016303b9cfcad1f6748db0e6ad/analysis/final_rule.py)中channel_delta/predict：状态分类→不同预测器→加参考损失→有限值检查，未知状态/域外值拒绝。未继续读取其所有import的拟合模块，不能说完整调用链已运行。

Readme与requirements.txt已读，分析依赖numpy1.26.4、scipy1.16.3、matplotlib3.10.3、pytest7.4.0；作者区分冻结产物重生成与重新测量，并披露原始轨迹/权重等未附带。仓库树没有LICENSE，LICENSE请求404，代码许可待明确，不复制作者源码。以下例子按公式独立编写。

## 现成例子与真实结果

```sh
sh systems_practice/paper/2026-10-13/01-scaling/run.sh
```

[example.py](example.py)使用标准库、3个合成幅度，每个只用density0.6/0.8拟合幅度，gamma固定2；在0.7/0.9评估。固定gamma不等同作者完整状态回归。独立QA反例响应跨零，强行拟合正曲线就失效；budget选择对比固定INT4优先级，展示精确预测可能没有额外决策收益。

[真实输出](results/cpu.json)：合成留出误差0；跨零QA误差0.1117647；0.5、1.0、NaN三个域外拒绝；固定优先级与oracle均选int4，regret0。这里没有LLM、校准、训练更新、压缩文件或设备计时，误差单位是本例合成标量，不能称nats/token实测。

## 复现路线、故障与验收

难度：独立机制易；作者冻结表格中等（版本/输入快照要配套）；重新测量完整模型难（探针、模型、训练阶段、GPU与数据配额）。最小路线先固定commit并用现成依赖重建作者表格，再挑一个本地已有模型和固定探针核对参考损失，最后才扩大密度网格。不自动下载数据/权重。本文未运行作者CLI；Readme提到的CUDA12.8是作者历史环境，不能当Thor兼容组合，任何新增CUDA执行仍须sm_110并另验。

故障链一：域内误差低、换模型后失效→幅度/任务分布变化→独立状态上检验残差与零/中位数基线→重拟合并限制域，不能用测试数据偷调参数。故障链二：MAE改善但选择没变→候选间距远大于误差或固定优先级已最优→报告可行集合和regret→保留简单规则，节省测量成本。

验收：划分开发/选择/最终评估；固定tokenizer和损失口径；拒绝域外参数；基准包含零响应/中位数/固定优先级；实际字节和端到端另测。

追问：①变化量为何比跨模型绝对损失适合比较？②gamma固定意味着省略什么？③共享形状何时失效？④系数迁移与形式迁移有何区别？⑤预测MAE与决策regret为何不同？⑥为什么budget可行集合要先定义？
