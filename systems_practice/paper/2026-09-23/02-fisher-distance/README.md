# Optimal Pruning for Neural Architectures using Fisher Information Distances

David S. Berman、Yen-Yu Fu、Edward Hirst、Thelma Chiwete Obirai。[arXiv:2609.16129v1](https://arxiv.org/abs/2609.16129)，首次/所读版本2026-09-14，预印本，未核实同行评审发表。2026-09-23阅读[一手全文](https://arxiv.org/html/2609.16129v1)§2.3–2.5、§3推导、§4实验及表4.1/4.2、§5总结。

## 核心思想与证据

剪掉参数是沿其坐标从θ_k走到0，局部Fisher可能变化。论文Eq3.7的实际分数为`|θ_k| sqrt(mean_j I_kk(θ with θ_k←α_j θ_k))`；它与`∫sqrt(I_kk)dθ_k`的长度积分不同，其他参数固定也不是求解全空间最短测地线。作者表4.2中SimpleViT/CIFAR-10，iterative和exact的归一化准确率曲线AUC均约0.791，剪枝扫描中位耗时约37秒与4.59天；相近质量下计算成本很悬殊，非推理时间。实验是五种子、小网络和两数据集、无重训练；不能把结论推广为边缘LLM最佳压缩方案。[原文](https://arxiv.org/html/2609.16129v1)

## 作者仓库与复现路线

[edhirst/Fdist_Pruning](https://github.com/edhirst/Fdist_Pruning)，main，读取2026-09-23；实际查阅仓库文件列表和README，确认存在`src/train_model.py`、`src/run_pruning.py`、pruning/utils目录、configs与测试入口。未逐行读算法实现，未运行作者API，因此下面没有伪称上游原生调用。仓库README称MIT而GitHub许可证区显示Apache-2.0；许可证尚需固定commit读取LICENSE裁定，不复制源码。访问`/tree/main/src/pruning`的web工具返回Internal Error，源码深入阅读保留待补。

完整复现**中到难**：需要Python/PyTorch及作者requirements、MNIST/CIFAR-10、已训练checkpoint、多种子和较长的逐坐标Fisher扫描。先准备作者`configs/nn_mnist.yaml`对应CPU小实验，核对Fisher样本集和同一密集checkpoint，再比较one-shot/iterative，最后才运行expensive coordinate path。当前无依赖、未下载数据；尚不能保证一条未经实现核验的CLI在该版本可用。只有函数等价性和完整日志支持后才转板端；置零权重本身不会让dense算子加速。

## 可运行的小例子

[example.py](example.py)为独立Python标准库Bernoulli模型，FP64 Python算术，权重3维，Fisher输入[64,3]、独立测试[128,3]。解析`I_kk=mean_x p(1-p)x_k²`对模型标签分布取期望，不用观测标签梯度平方替换。计算magnitude、Fisher-only、one-shot、逐坐标RMS；另用梯形积分显示“sqrt均值”与“均值sqrt/积分”的区别。3/9/33节点只做收敛观察，不用测试集挑节点数。

```sh
./systems_practice/paper/2026-09-23/02-fisher-distance/run.sh
```

[真实输出](results/output.json)：有限差分对照标签期望梯度平方的最大误差2.0528e-11；零参数分数和非法路径长度检查通过。magnitude删除第1坐标、测试KL=0.0418013；其余三种删除第0坐标、KL=0.00501537。这个例子并未显示路径法优于one-shot，不能拿它宣称新算法处处更优。

只演示一个参数置零的分数和分布变化，没有训练更新、Transformer、稀疏存储格式或加速内核；不报告GPU、NPU、板端或端到端收益。Python选择基于数学教学目的，若扩展为真实ARM稀疏内核则另用C++17。来源/状态见[source.json](source.json)、[verification.json](verification.json)。
