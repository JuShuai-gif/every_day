# LLM Compression with Jointly Optimizing Architectural and Quantization choices

## 元信息与实际阅读

Hoang-Loc La、Truong-Thanh Le、Amir Taherkordi、Phuong Hoai Ha，[arXiv2606.04063v1](https://arxiv.org/abs/2606.04063v1)，2026-06-02首发，距归档日121天。阅读[HTML正文](https://arxiv.org/html/2606.04063v1)第1–5节、式1–9、表1–2及图5；未声称逐条读完参考文献。按arXiv版本归档，不以待核实的会议书目当独立评审证据。标题+GitHub检索与正文未确认作者官方实现；没有虚构源码路径/许可证。

## 工业问题与核心机制

工业模型可能有多组宽度/深度与量化位宽选择。逐步先裁结构再量化，会在前一步丢掉后一步可用的组合。论文将架构与权重/激活位宽纳入可微搜索，并使用设备成本约束；概率mask避免枚举大量重复张量操作。图5报告在作者A100 80GB的一个40%压缩目标对照中最高约1.4倍的准确率比值，不能改写为1.4倍推理加速或Thor结果。

从工程合同推导：实际部署只取一个离散候选，软概率下的期望预算可满足，argmax导出仍可能超预算；因此最后必须测离散图、真实shape和后端。设备LUT如果不包括packing、调度或图融合，也不能直接代表产品E2E。

## 已写好的最小反例

[example.py](example.py)为独立教学代码，不调用作者NAS。工作目录EveryDay根，Python标准库，无torch、无下载：

```sh
sh systems_practice/paper/2026-10-01/01-joint-search/run.sh
```

四个手造候选的cost无单位，不是毫秒；loss是人为反例而非模型准确率。预算3时wide4的cost3/loss.15优于narrow4的cost2/loss.8，说明先删wide候选可损失组合最优。W[3,4]的输入/输出宽度概率mask与显式切片补零加权逐元素一致，是线性代数恒等式核对，不证明离散网络函数等于软网络。另一反例概率(.4,.6)、代价(2,4)，期望3.2≤3.3但argmax代价4越界。

真实[结果](results/cpu.txt)：mask_equivalence=true，expected_cost=3.2，discrete_cost=4，training_updates=0。无实际训练、无位打包、无压缩模型，也没有kernel/端到端计时。简单代码便于隔离决策问题，完整复现难度高：仍需搜索训练、校准/调参/测试分区、算子库成本表、量化后端与导出验证；缺官方代码难以确认所有训练细节。

## 故障、失效与复现验收

故障一：搜索日志预算达标、导出却超时→先核对soft期望与argmax离散成本→在冻结图上重新选择/约束候选→实际平台无profiler测E2E；代价是可能放弃训练最优点。故障二：另一个GPU上准确率/速度排名翻转→检查校准分区及设备LUT→替换LUT并重新调参→独立测试，不能把A100结果视为Thor已支持。

复现验收：作者实现若公开先固定commit/许可；训练数据与成本测量分开；mask小例子通过；导出形状合法；量化格式和kernel真正支持；记录训练预算与测试精度；将静态payload、峰值内存和E2E分别测。本文无自研GPU代码，未来CUDA目标固定Thor sm_110，后端兼容性仍待核实。

追问：1.联合选择为何可能优于贪心串联？2.软mask恒等式能证明什么？3.期望预算为何不保证argmax？4.LUT遗漏同步会怎样？5.搜索数据是否可兼作最终评估？6.没有官方实现时哪些结论只能叫机制复现？

[source.json](source.json)和[verification.json](verification.json)分别记录正文范围、来源缺口与独立例子执行；不把代码交付叫整篇复现。
