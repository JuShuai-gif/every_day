# HOPE：Higher-order pruning of experts in mixture-of-experts language models

Alex M. Tseng、Prannay Kaul、Luca Zancato、Wei Xia、Stefano Soatto；[arXiv:2609.18916](https://arxiv.org/abs/2609.18916)，首发2026-09-16；本次读[v1全文](https://arxiv.org/html/2609.18916v1)第3节、4.1–4.2、附录C.7/D。页面列最新v3为2026-09-29，本课不把修订当新首发；预印本，未另核实同行评审发表。

## 方法和作者结果

令每token专家贡献幅度`a_i=g_i||f_i||`，统计交互矩阵F，固定剪枝数量求`min pᵀFp`。非对角项惩罚同时删除共同贡献的专家。理论式用全样本均值，实践改成共同激活条件均值，两者不是相同统计量；对角项也不能严格等同REAP均值再平方。作者第4.2在54种配置报告总体平均排名2.07；跨层扩展可能因早期层剪太多而崩溃。它优化替代目标，不能保证所有分布上的真实模型误差。[正文依据](https://arxiv.org/html/2609.18916v1#S3)。

## 实际源码与复现路线

作者原仓库[hybrid-model-factory/HOPE](https://github.com/awslabs/hybrid-model-factory/tree/main/examples/research/HOPE) README实际提示迁至[awslabs/HOPE](https://github.com/awslabs/HOPE)。新仓库存在，但solve.py正文直访Internal Error；旧路径[hope/solve.py](https://github.com/awslabs/hybrid-model-factory/blob/main/examples/research/HOPE/hope/solve.py)正文实际读到`build_f_matrix`、`solve_qp`、`solve`。main/2026-10-04，未固定commit；旧仓库Apache-2.0 LICENSE读过，新仓库LICENSE正文失败，README标Apache-2.0。

调用链是HDF5计数/幅度→按共选计数归一化→SLSQP松弛→取最大若干分量形成删除集合。源码的`solve(obs_path,prune_frac,out_path,task_id)`与迁移README的示例API不同；不混用两版接口。旧solve_qp没有在取result.x前检查success，生产复现应记录求解状态和可行性。没有实际运行作者校准/导出/评估，只确认这份求解实现；不能据README断言新仓库全流程完整。

完整复现难度高：PyTorch、transformers匹配版本、NumPy/SciPy/h5py、已准备的MoE权重与独立校准/测试数据，显存随模型而定，未估造数值。先在四专家统计上核验F，再验证求解/物理删除router与expert权重一致，最后任务集和E2E。任何CUDA扩展只针对Thor sm_110；原README的CUDA12命令不作为Thor方案。

## 独立可运行例子和真实结果

```sh
sh systems_practice/paper/2026-10-04/01-hope/run.sh
```

[example.py](example.py)只用Python标准库，独立枚举4选2，比较全F/仅对角并核对平方和恒等式；不是作者SLSQP、没有MoE前向/训练更新/模型导出。校准选(0,2)目标0.81333，逐个排名选(0,1)目标1.33333；固定不同分布的评估目标分别16.81与0.04，**联合选择在此退化**。条件归一化另算2.44，空/全预算与非法预算均检查。[原始输出](results/cpu.txt)。没有存储/速度或任务精度结论。

## 排障、验收与追问

1. 离线F目标好而任务掉分：区分归一化改变与分布漂移，记录计数和heldout路由；换独立调参/评估集并保留回退，不能用评估集重选集合。
2. 求解输出越界/数量错误：看success、约束残差、目标与取整后预算；小规模枚举oracle先验收，再决定重试/回退。取整可破坏松弛收益。

验收需要矩阵有限/对称、零共选处理、预算准确、校准/评估分离、物理导出重载正确；本例仅覆盖前半段。追问：①非对角项表示什么？②条件均值与总体均值相同吗？③松弛解为何要取整？④为何校准改善不能保证测试改善？⑤如何证明实际文件变小而非仅置零？⑥共同激活计数为零怎么办？

[source.json](source.json)与[verification.json](verification.json)分别记录阅读、独立运行和未复现边界。
