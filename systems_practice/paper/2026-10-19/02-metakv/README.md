# MetaKV：预测预算、实际成功与公式差异

## 论文与实际阅读

**MetaKV: Adaptive KV Cache Compression for Constrained LLM Inference**；Michael Wang、Keith Li、Roozbeh Bostandoost。[arXiv:2609.07966v1](https://arxiv.org/abs/2609.07966)，首发/版本2026-09-07，预印本，未核实同行评审状态。实际读[全文](https://arxiv.org/html/2609.07966v1)§2.3、§3.1–3.2及Table1相关段落。

方法先预测每配置的时延、峰值KV内存、正确概率，再按预算筛选；可行FP16优先，否则每方法先留最温和压缩，再按正确概率选择。无可行配置时仍返回最小违约配置，**不是保证满足预算**。CSR以实际正确且实际时延/内存都合格计数，不能用预测值算成功。

作者在Llama3.1-8B、RTX PRO6000 Blackwell Server96GB、4数据集的1232测试prompt上报告平均ΔCSR约0.07、最高0.135；该GPU只是作者实验上下文，不是本课执行目标。延迟预测MAPE38.19%，平均预测开销10.96ms；说明预测与控制保障有距离。Table1标题写1232测试样本而邻接正文提8192总样本，阅读时保留此口径差异，不混用平均表与测试CSR。

## 作者实现与实际发现

实际读[MichaelWang0505/MetaKV](https://github.com/MichaelWang0505/MetaKV) README和[evaluate_metakv.ipynb](https://github.com/MichaelWang0505/MetaKV/blob/main/evaluate_metakv.ipynb)代码单元：`regression_predictions`、`correctness_predictions`、`smallest_combined_violation`与候选筛选循环。2026-10-19 main，blob见[source.json](source.json)，commit未固定。LICENSE获取404，许可未核实，不复制作者代码/模型。

论文§2.3写 `Lhat/Lmax + Mhat/Mmax`；实际notebook函数写 `max(Lhat/Lmax−1,0)+max(Mhat/Mmax−1,0)`，只累计超额。它们不是始终等价。预测A=(1.8,0.1)、B=(1.1,1.1)，预算=(1,1)：论文得1.9/2.2选择A；代码得0.8/0.2选择B。此处对照来自实际实现阅读，不擅自“修正”论文或代码。

README主流程是Colab/Drive和离线profiling CSV、已训练joblib；本次只读不运行安装/Drive单元，不读取不可信joblib。公开评估notebook不等于已核验在线LLM压缩后端；三个预测器训练notebook未审，profile数据生成与完整在线服务尚待核验。

## 独立实验与真实输出

[example.py](example.py)是Python标准库策略实验，输入为明确标注的合成候选字典，**没有训练LightGBM，没有实际压缩KV，没有作者模型数据**。

```sh
sh systems_practice/paper/2026-10-19/02-metakv/run.sh
```

[输出](results/cpu.txt)验证：FP16优先；同一方法先选q8而非概率更高的q4；无可行配置时论文选择A/仓库选择B；预测(.9,.9)可行而合成实际(1.2,.9)的CSR为0；空候选/零预算/NaN三种拒绝。这些数字是策略反例输入，不是实测时延/峰值内存。代码只输出布尔状态与选择，不能提供压缩比或设备速度结论。

## 复现路线、故障与边界

离线选择器复现难度**中**：需pandas/numpy/scikit-learn/LightGBM/joblib和作者固定profile拆分；完整在线复现**难**，还需LLM、各压缩后端、统一测量与跨设备重训。最小路线：先验证数据键/配置顺序一致→严格分训练/调参/测试→复现两个fallback规则→用真实执行重新计算CSR→把选择开销计入端到端。CPU标准库实验已经执行，其他步骤待验，不自动安装或下载模型。

故障链一：测试预测可行但生产超预算→分布或设备变化使预测低估→对照逐请求预测/实际/开销→重校准加保守余量，代价是更多请求降级；不称硬实时保证。故障链二：更换配置列表后选择反常→模型输出列顺序不一致→检查payload configs与数据列→固定协议并拒绝不匹配；不得用巧合相同长度放行。

迁移须固定模型/上下文/输出长度/并发/测量域，区别KV峰值与整个进程GPU内存。未来设备执行固定Thor sm_110；作者桌面GPU结果不外推到Thor。[verification.json](verification.json)记录仅独立CPU例通过。

追问：CSR与准确率怎样不同？无可行项的fallback是否还合规于预算？两种违约公式何时选择不同？预测开销应该计入哪个时间边界？更换设备后为什么不能直接复用延迟模型？
