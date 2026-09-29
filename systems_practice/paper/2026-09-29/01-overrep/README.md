# OverRep：训练时增容，部署时合并

Seungmin Oh、Donggeon Lee、Jongbin Ryu；[arXiv:2609.06974v1](https://arxiv.org/abs/2609.06974v1)，首发/所读版本日期均2026-09-07；arXiv作者备注“EMNLP2026 accepted”，本次未独立核验会议录。2026-09-29实际阅读[一手HTML全文](https://arxiv.org/html/2609.06974)§3.1–3.3、附录B.5与表11；带v1的HTML入口失败后用无后缀入口，正文标明v1。

剪枝后的紧凑恢复模块可能容量不足。论文以辅助加性矩阵W与输出变换D扩展线性投影P：`D A_alpha((P+W)x)`；alpha最后归零，得到`P_merged=D(P+W)`。恒等初始化W=0/D=I保持原起点。训练早期的非线性不能任意合并，这是部署门禁。表11的LLaMA3-3B、25%剪枝、单RTX3090实验：OverRep20 epoch和Streamline100 epoch均报告4.6小时，二者使用缓存特征，其预计算另需计入；不能从这个表推断Thor训练耗时。

## 可运行机制实验

```sh
sh systems_practice/paper/2026-09-29/01-overrep/run.sh
```

[example.py](example.py)为独立Python3标准库实现：2×2矩阵、32个训练/32个独立评估输入、240次真实梯度更新W/D，P冻结，教学激活选ReLU。不是Transformer剪枝复现；省略蒸馏数据、注意力、模型选择和作者训练配置。末40步alpha=0，检查合并等价，同时检查alpha=1时强行合并产生差异。无新增编码作业。

[实际输出](results/cpu.txt)：heldout MSE从0.0794433321降到6.86063435e-8，合并最大误差1.11022302e-16，alpha=1错误合并差异0.7794723。仅Python双精度机制实验，无GPU/NPU/E2E计时，也没有声称存储或任务精度收益。

## 复现路线与限制

难度：机制例子易，完整论文难。需原始LLM、剪枝/蒸馏数据、匹配PyTorch/Transformers训练环境与足够GPU资源；不在这里猜显存下限。先通过本例合并检查，再取得作者实现、审计恢复/导出/评估，固定模型和数据，最后做同预算对照。[作者仓库](https://github.com/MMAI-Laboratory/OverRep)本次树只显示Apache-2.0 LICENSE，没有可核验训练/合并程序，因此没有捏造原生CLI。未来CUDA执行仍只能针对Thor SM110，并先核实后端支持；作者RTX3090结果仅作论文上下文。

[source.json](source.json)与[verification.json](verification.json)分别记录阅读范围和本机运行。作者代码缺失进入backlog；本例不代表整篇复现。
