# Small LLMs: Pruning vs. Training from Scratch

2026-10-07阅读；Yufeng Xu、Taiming Lu、Kunjun Li、Jiachen Zhu、Mingjie Sun、Zhuang Liu。[arXiv2606.14150](https://arxiv.org/abs/2606.14150)首发2026-06-12，本期读[HTML v1全文选段](https://arxiv.org/html/2606.14150v1)的§3.1/3.2、§4/表2及局限讨论；页面最新v3为06-29，未把修订当新论文，未声称读完全部附录。首发117天，位于180天窗口；本期按预印本讨论，发表状态未另核实。

## 问题、方法与结果边界

已有大模型时，剪枝后重训练是否优于同尺寸随机初始化？关键不是只比压缩前后，而是把初始化来源和总token成本分开。论文比较S50与P200-R50，再用S250对照整个预训练+重训练预算。这里数字单位B tokens；不同大小模型每token算量不同，因此token相同不等于FLOPs相同。

作者表2中50%剪枝的Minitron-D：WikiText-2 PPL从随机50B的10.77到预训练200B+重训50B的9.41，但随机250B为9.01。这个具体反例说明初始化优势依预算而变，不能推出所有结构/稀疏方式都应从头训练。数据为DCLM，模型Llama-3.1-8B，结论没有证明Thor部署延迟。原论文报告非本机复现。

本期独立机制公式：固定mask m，梯度更新 `w←m⊙(w−η∇L)`；保留父模型权重作为一种初始化。以独立调参集选择lr，最终评估集只评价。预训练成本单列，不能隐藏在“只训40步”里。工作问题是压缩方案评审如何避免把上游预算遗漏。

## 源码审计与最小复现路线

作者仓库 [zlab-princeton/llm-pruning-collection](https://github.com/zlab-princeton/llm-pruning-collection)README实际读到pruning/training/eval结构与Minitron、Wanda等入口；页面标Apache-2.0，但**具体实现未取得**。尝试 `pruning/wanda/lib/prune.py`、`pruning/minitron/prune.py`和`.gitmodules`均Cache miss/Internal Error，不声称读过作者算法代码或确认完整训练可复现。完整commit/许可证正文/依赖锁仍待补。

完整复现难：先固定作者仓库及子模块、逐个核对剪枝与训练框架环境；准备合法本地Llama权重、DCLM不重叠数据分片、训练token计数与八任务评估；再按作者同架构和优化器日程复测。作者仓库含不同方法独立环境，不能拿单套安装替代核查。本任务不下载权重/数据、不安装依赖，不给未经源码核实的原生API。目标若选择GPU仍只能Thor SM110；现有JAX/PyTorch后端的Thor兼容与资源需求未审计，不伪造显存/时长。

## 现成独立例子

```sh
sh systems_practice/paper/2026-10-07/01-prune-budget/run.sh
```

[example.py](example.py)仅Python标准库，三维线性回归，无模型下载；pre/train/tune/test分别100/100/60/80样本，父模型200次真实全批更新；两个目标权重参与重训练，第三项固定mask为0。准备40步随机、40步父初始化、240步随机三种方案，每种同候选lr集合。步数只是小实验预算，调参成本另有多次候选训练，不能换算论文token成本。

[真实输出](results/run.txt)：测试MSE为0.00206345（pruned40）、0.01025153（scratch40）、0.00136384（scratch240），固定mask检查与实际更新通过。额外预算反转排序，保留这个无优势条件；不是LLM/PPL或作者模型的验证。未测CPU/GPU/NPU性能、存储压缩或端到端部署。

## 故障链与迁移验收

预算遗漏→剪枝“免费”→记录父模型tokens、重训、校准、搜参及模型尺寸→分别报沉没成本与新增成本→重新比较两种决策场景。

掩码只在初始化应用→优化器重新长出权重→检查每步mask不变量→每步投影或实现结构删除→回归最终稀疏度与导出后布局。玩具逐步投影不代表作者所有方法如此实现。

验收：先固定目标尺寸/数据/预算边界；调参集和测试集分离；检查导出后实际算子/存储，不能把零元素数量当速度。追问：token公平为何不等于算量公平？父模型成本什么时候算沉没？固定mask怎样约束更新？结构与非结构剪枝的部署代价有何不同？
