# D-Quant: Driftable Entropy Coding for KV Cache Quantization

Yi Su、Hong Liu、Guanghua Yu、Jianchen Zhu；[arXiv:2609.19880v1](https://arxiv.org/abs/2609.19880)，首发/版本日期2026-09-17，预印本。实际阅读[一手全文](https://arxiv.org/html/2609.19880v1)第3节、第4.1–4.3与4.4开头、第5.2/5.3；未声称阅读每条参考文献。论文/精确作者题名搜索未找到可核实作者实现，源码、许可、训练/导出/评估完整性待补；没有猜测仓库/API。

## 方法和有边界的作者结果

每token使用固定容器，优化`Σ(x_i-recon(m_i))²`并约束码长≤预算。给定λ，逐元素选择`D_i(m)+λr(m)`最小符号，再搜索满足长度的λ；论文使用rANS，K/V预算不同。第5.3在H20 96GB、Qwen3-8B上指出小batch因解码成本可慢于BF16；比较各自最大可行batch时才报告高吞吐。不能把容量收益当固定batch低时延收益。[原文实验](https://arxiv.org/html/2609.19880v1#S5.SS3)。

## 独立可运行例子

```sh
sh systems_practice/paper/2026-10-04/02-dquant/run.sh
```

[example.py](example.py)是独立四符号前缀码，不是rANS或作者kernel。固定8个数、4个重建值、前缀码长度3/1/2/3，二分λ选可行符号并打包到真实2字节payload，解码知道元素数以跳过padding。独立穷举65536种组合给小规模预算oracle；本例λ方案恰与oracle一致，不保证所有离散输入都达到全局最优。

[实际输出](results/cpu.txt)：最近舍入18bit、平方误差0.7；预算16bit后误差2.7；真实payload2字节，往返一致，7bit不可行预算被拒绝。代码本/元素数/scale固定在程序中，2字节仅payload，**不是总KV存储或BPV**。没有实际KV矩阵、attention、旋转、rANS状态/renormalization、训练更新或GPU实现，不能称论文复现。

## 复现难度与故障诊断

完整复现难：先需要作者可审查代码及格式说明，再准备模型/数据与匹配框架；普通CPU即可跑本例，模型显存和运行时间未实测，不给虚构估算。最小路线是先验证真实rANS编码长度上界/状态与往返，再实现attention接入与任务误差，最终在Thor sm_110上测固定batch及最大容量两种口径。当前没有GPU性能候选，不把这个CPU概念例子当已交付压缩注意力kernel。

1. 理论平均码长符合预算但容器溢出：实际码流还含状态/对齐；必须记录真实写入字节并测试最坏符号分布，显式预留metadata/状态空间，不能只检查熵。
2. 最大batch吞吐提高而单请求变慢：核对并发数与解码成本，固定batch单独计时，低并发时允许BF16回退，记录容量阈值。

迁移验收：每个stream真实边界、bit序与反向解码次序、状态开销、attention数值、压缩布局直接参与推理、设备实测；本例仅验证前缀码payload。追问：①熵为何不是实际码长？②λ怎样换失真和长度？③离散二分一定最优吗？④为什么padding需要已知元素数？⑤K/V预算可否同设？⑥跨batch吞吐比较的混杂因素是什么？

[source.json](source.json)与[verification.json](verification.json)保留作者源码待补和非完整复现状态。
