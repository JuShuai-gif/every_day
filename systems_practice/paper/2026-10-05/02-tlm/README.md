# Telescopic Language Models：随机前缀与完整模型锚定

## 一手出处与范围

Zhilin Guo、Boqiao Zhang、Hakan Aktas等17位作者，arXiv:2609.35769v1，首次2026-09-28，预印本。2026-10-05实际读[全文§2/§3、§4.1开头、§4.3与结论](https://arxiv.org/html/2609.35769v1)，[作者名单和日期](https://arxiv.org/abs/2609.35769)。

[官方仓库](https://github.com/ZhilinGuo/telescopic-language-models)目前只有README、images、LICENSE，README写Code coming soon；因此作者训练/导出/评估实现都未公开可读，不能声称用过原生API。README声明Apache2.0，许可正文未单独审查，未复制作者代码。[source.json](source.json)记录读取范围。

## 方法与有上下文的结果

每步采一个深度k，目标`L=λℓ(F_k(x),y)+γℓ(F_N(x),y)`；前缀和完整模型用同一完整监督目标，full anchor每步保护最大模型。作者200M代理模型、20B FineWeb-Edu训练下，uniform方案20个前缀可用，AULB3.28；exit-grid方案AULB6.21，off-exit仍可能崩溃。最大模型14.99 PPL仍弱于独立vanilla的13.98，不把“匹配固定出口套件”说成无代价匹配独立模型。数据是作者报告，不是本机复现。[方法与消融](https://arxiv.org/html/2609.35769v1#S3)。

## 独立、真实更新的例子

[example.py](example.py)用4段共享线性前缀`F_k(x)=x*sum(w[:k])`，目标2x。每步先合并prefix与full两项解析梯度，再更新参数；uniform与固定{2,4}出口都跑2000步，用同一训练输入随机流，采样器另设seed避免影响训练输入。评估seed独立且不参与lr选择。这里只展示监督覆盖，没有Transformer、词表、RMSNorm或语言PPL。

```sh
sh systems_practice/paper/2026-10-05/02-tlm/run.sh
```

Python标准库实际运行通过，[最终输出](results/cpu-final.txt)。固定出口depth1覆盖为0且MSE约0.363，uniform覆盖所有深度且depth1误差显著降低。保留较早[cpu.txt](results/cpu.txt)作历史：早版两个模式共用输入/采样随机源导致输入流不同，最终修正为独立采样器，比较以cpu-final为准。full梯度每步到达所有参数，prefix梯度到达第j段的概率为(4−j)/4（j从0起），代码枚举该概率并验证真实参数变化。

## 复现难度、负面边界与路线

独立例子易，完整复现难：代码尚未发布，还需模型配置、tokenizer、20B token数据流、训练资源、各prefix评估与速度测量。最小复现先等源码发布并固定commit，核对prefix构造/head选择，再用已有小随机模型检查梯度覆盖，最后统一数据流与预算比较。不会自动下载数据或把作者A100时间当作Thor预测，任何未来CUDA命令仍限定sm_110。

故障链1：“支持截断”但中间深度输出失效→头部从未在这些隐藏状态上受监督→按每深度覆盖计数与loss定位→扩大采样支持，代价是共享梯度干扰。故障链2：小深度进步、完整模型变差→锚定权重/梯度覆盖不足或共享冲突→对照相同训练预算的anchor消融→调整权重并同时报告full与prefix，不只报面积指标。

本线性例子的capacity过强地集中到首参数即可拟合，不能推导深度模型真实容量、平滑质量曲线或部署速度。最小depth误差改善也不能保证全部任务优于固定出口，性能必须在真实目标独立测量。

追问：随机前缀的梯度到达概率如何随深度变化？为何还要full anchor？采样器支持集遗漏depth1会怎样？“同目标”与在线蒸馏有什么区别？面积指标会隐藏哪些出口退化？共享线性例子为何不能预测PPL？

[verification.json](verification.json)：方法已读、原生源码未发布、CPU独立训练通过、完整训练/GPU/板端未验。
