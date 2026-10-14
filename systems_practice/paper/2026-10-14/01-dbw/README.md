# DBW：把0-bit剪枝放入统一预算

Hankyul Kang、Jongbin Ryu；[arXiv:2610.06026v1](https://arxiv.org/html/2610.06026v1)，2026-10-05首发/当前阅读版本。本文按预印本阅读；仓库标注NeurIPS'26，本次没有独立核实会议状态。实际读§2方法、§3实验、表1/5/7与§5局限。

论文把权重分解到SVD分量，分量位宽可以为0，于是剪枝与量化共用一个预算。先将非负分配分数归一化，乘预算后取整，再补最大余数；块级重建损失配合奇异值熵项优化。仅取floor会漏掉预算。作者表1中LLaMA-1-7B、1.61bpw的八任务均值为48.98，FP16为63.06；压缩后仍有精度损失。§3.2也记录64 tokens时多组GEMM启动成本可能令DBW慢于OmniQuant。以上为作者结果，非本机实测。[原文](https://arxiv.org/html/2610.06026v1)

实际作者源码：[MMAI-Laboratory/DBW](https://github.com/MMAI-Laboratory/DBW)，commit`a45f26e1d153ab6bc64dd27d056a3710a33f2e7a`，2026-10-14获取并阅读[dbw/fake_dbw.py](https://github.com/MMAI-Laboratory/DBW/blob/a45f26e1d153ab6bc64dd27d056a3710a33f2e7a/dbw/fake_dbw.py)的`floor_ste/apportion_softmax/fakeDBW.get_bit/get_quv`，以及`dbw/utils/quantize.py`的参数分组、set_quant_state和quant_inplace。调用链是分量分数→ReLU归一化→floor_ste/5bit封顶→余数补配→get_quv保留正位宽分量。仓库树可见训练、fake/real、Triton文件，但只读上述范围，不声称全训练/推理路径审计。LICENSE请求404、树中无license路径，代码复用许可待补；本课不复制其代码。

[example.py](example.py)为独立Python标准库硬化实验，无可微训练、无STE更新、无真实SVD或作者GEMM。输入分数[9,4,1,0.1]、预算8、cap5，floor只给7bit，补配得到[5,2,1,0]，剔除已知对角SVD的尾分量能量0.01。三种非法预算/全零分数拒绝，未声称复现DBW训练收益。

```sh
sh systems_practice/paper/2026-10-14/01-dbw/run.sh
```

[实际输出](results/cpu.json)、[来源](source.json)、[验证](verification.json)。独立算法按剩余理想差值逐次分配；对饱和/多轮余数场景可能与上游批量topk策略不同，不声称逐位相同。0bit意味着删除分量的两侧向量，不是把原矩阵中任意单个元素删掉。这个微例子没有packed权重，不能从预算直接推出实际存储或速度。

复现难度：难。完整路线需要固定源码/许可证、torch与对应模型实现、预训练模型、校准集、足够训练设备，再运行训练→硬化→打包→任务评估。原训练默认大模型，不自动下载。先核验每矩阵预算与scale/索引开销，再独立校准、调参、评估；Thor只允许sm_110，作者Triton/混合GEMM后端尚未审计，今日不调用。

工程检查：①预算硬化后变少→检查floor损失和cap饱和→补配并重新求总bit→对全零分数/不可行预算显式失败；②码字更少而小batch更慢→分组launch数与packing成本可能主导→分别计量kernel/E2E→合并小组或回退，目标未实测。迁移验收需导出格式、任务精度、small-M启动成本及硬件兼容全部补齐。

追问：①为什么要允许0bit？②平均bpw与每分量bit相同吗？③floor会漏多少预算？④cap饱和时如何处理？⑤分组启动为什么影响small-M？⑥独立预算例子距离作者训练还缺哪些步骤？
