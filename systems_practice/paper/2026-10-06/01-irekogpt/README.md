# IrekoGPT：从固定剪枝到多宽度校准

[原文v1](https://arxiv.org/html/2610.00426v1) / [arXiv记录](https://arxiv.org/abs/2610.00426)，Pietro Moriello、Pietro Buzzega、Angelo Porrello、Simone Calderara；2026-09-30首次提交，v1。仓库自称NeurIPS2026 AXIOM，当前只按预印本/作者标注处理，不独立确认评审状态。实际阅读2、3.1–3.3、表1。

问题是全宽校准的分布未覆盖窄模型。作者保留排序PCA基底供不同前缀宽度使用，合并多宽度激活流校准，并对保留输出宽度的层求带岭正则的残差权重修正。目标是各宽度输出匹配全宽输出，惩罚修正幅度。表1中Llama2-7B、25% sparsity，PCA/ECD/IrekoGPT perplexity为8.62/7.98/7.92；全宽IrekoGPT为5.51，对比原模型5.47，说明修正有折衷，不能声称所有宽度都改善。

## 源码与最小复现

作者[仓库](https://github.com/aimagelab/IrekoGPT)README与MIT LICENSE实际读取，目录说明涉及experiments/run_slicegpt.py；尝试main下该文件、slicegpt/rotate.py、src/slicegpt/rotate.py均Internal Error。核心实现未读成功，未声称参考作者实现，也未提供猜测API。完整SHA/依赖审计待补。[source.json](source.json)列事实。

完整复现难：需作者环境、Llama/Qwen本地权重、WikiText-2与校准激活缓存，以及多宽度层处理；设备内存/时间未估算。最小路线是先取可验证checkout和固定模型版本，选择最小本地已有模型，只复现两种宽度的一层校准，核对全宽等价性后再拓展。当前不下载、不安装；GPU若后续使用固定Thor SM110，并需再核验框架后端。

## 可运行独立例子

```sh
sh systems_practice/paper/2026-10-06/01-irekogpt/run.sh
```

[example.py](example.py)只用Python3.9标准库。固定二维基底（**没有PCA**），两种前缀宽度共同拟合一个权重，闭式2×2解真实更新参数。校准seed1/调参seed2/评估seed3分开，反相关seed4只测试；按调参集选lambda，不在测试集择优。原权重(1,2)，共享修正后(2.43319,0.393388)。[真实输出](results/cpu.txt)：窄宽度iid MSE2.72046→0.370891，全宽0→0.288614；shifted窄宽度2.68398→7.92872。无PCA、Transformer、LayerNorm吸收或作者模型复现，没有训练迭代；闭式更新明确不是QAT。

## 故障、边界与验收

校准只含一种相关性→shifted性能下降→独立holdout对照→扩大校准覆盖或保留原权重，不能用测试集重新挑lambda。全宽退化→多宽度共享修正产生冲突→分宽度记录误差→设置全宽约束/上线门槛，可能牺牲窄模型收益。这是本地例子反例，非作者生产事故。

零残差输入验证权重不变；奇异问题需正则。完整复现应记录每宽度任务指标、驻留权重/激活峰值和端到端延迟，而非把裁剪维度比当加速比。追问：多宽度数据为何改变PCA？共享修正何时冲突？正则保护什么？为何全宽基线不能略过？怎样验证闭式解与原始目标一致？缓存多流需要多少存储？

[verification.json](verification.json)：独立CPU通过，作者代码/完整模型/Thor未验证。
