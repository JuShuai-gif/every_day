# GSQ：离散网格的可微选择与硬化后的误差

## 论文与阅读范围

**GSQ: Highly-Accurate Low-Precision Scalar Quantization for LLMs via Gumbel-Softmax Sampling**，[arXiv2604.18556v1全文](https://arxiv.org/html/2604.18556v1)。首发2026-04-20，距本日165天，在180天范围内；本期读v1的§3.1–3.5（算法1/2/3、式1–6）及§4.1–4.3、表1。v1作者Alireza Dadgarnia、Soroush Tabesh、Mahdi Nikdan、Michael Helcig、Eldar Kurtic、Dan Alistarh。摘要页另核实v2日期2026-05-15、增加Maximilian Kleinegger；没有把v1结果冒充v2重新核验。记录为预印本，未核实同行评审venue。

## 问题、步骤与公式

极低位宽下，最近舍入可能无法保留层输出。GSQ用logits表示每个权重的候选网格选择，加Gumbel噪声后按温度softmax，让离散决策可用梯度优化；同时学习组scale，最终argmax硬化。核心形式`p_j=softmax((κ*l_j+g_j)/τ)`，`w_soft=s*Σp_j*q_j`，重构目标是原层与压缩层输出差。2bit网格[-2,-1,0,1]，原方法从GPTQ开始，其他位宽使用相应参数化。此类校准优化属于论文的PTQ设计，不等同完整模型QAT，也不等同新推理数据类型。

作者表1：Llama3.1-8B-Instruct，五个零样本任务平均，GSQ 3.13 bit/param为72.32，FP16/BF16为73.71，GPTQ3.25 bit/param为59.18。位数口径排除未量化tensor，不能当整模型压缩率。实验主要使用8×H200或8×B300节点；这不是Thor复现或速度保证。随机优化的大模型结果报告单次配置，泛化与成本需独立复验。

## 作者源码与复现难度

[IST-DASLab/GSQ](https://github.com/IST-DASLab/GSQ)，main读取2026-10-02，commit未固定，Apache2许可证正文已读。实际读[src/quantization/gumbel_quantizer_2bit.py](https://github.com/IST-DASLab/GSQ/blob/main/src/quantization/gumbel_quantizer_2bit.py)全文92行：`GumbelQuantizer2Bit.forward→GumbelSoftmaxFunction.apply`，backward重放CUDA RNG噪声，`get_hard_weights`取argmax并按group索引scale。它直接调用CUDA RNG接口，所以不能声称把device换CPU即可原样运行。

仓库可见main.py、save_model.py、eval_model.py及配置/训练目录；仅核查入口存在及该核心实现，**未完成整套训练、导出和评估调用链审计**。原模型复现难：需要PyTorch/CUDA、适配模型与校准数据、训练预算、导出推理后端；固定commit/依赖/配置后先对单层有限差分和重构，再逐层训练并独立评估。不能从公开目录推断Thor扩展已支持。若后续做GPU运行，一律匹配JetPack/CUDA并固定sm_110，不沿用作者其他GPU目标。本次不安装依赖、不下载权重。

## 已写好的最小机制观察

```sh
cd systems_practice/paper/2026-10-02/03-gsq
sh run.sh
```

[example.py](example.py)用Python标准库，独立实现四个权重的soft选择、真实logit/scale梯度更新600步；固定同一噪声做有限差分检查，再用独立新噪声训练。目标只为四权重MSE，无真实Linear校准集、GPTQ初始化、Lion、Transformer层或模型任务；**不是作者API或完整GSQ复现**。没有冒充只算损失为训练。

实际[输出](results/cpu.txt)：梯度最大误差7.6338e-13，scale0.8→0.8009117；硬化codes=[1,1,2,3]，硬化MSE0.0405550。真正把四个2bit索引打包为1字节，加FP32 scale共5字节，并解包核对；原四个FP32权重为16字节。如此小的机制例不含模型元数据，也不预测GGUF模型压缩率。CPU/GPU/NPU/E2E性能均未测。

## 失败链、适用条件与追问

1. 软重构好、argmax后误差跃升→温度/硬化失配→同时记录soft/hard误差并在校准外评估→调整日程或保留高位；本例只报告硬误差，不宣称训练后模型改善。
2. 梯度校验不稳定→forward/backward重采不同噪声→固定RNG做有限差分→上游用RNG重放，本例显式复用noise；真实多设备重放还需要设备上下文。

迁移需固定版本、真实模型独立数据划分、完整payload与内存峰值、支持的推理格式及硬化后任务精度。未达标即回滚位宽/格式，不以soft loss代替验收。

追问：温度和噪声幅度分别改变什么？为什么学习logits仍可归为PTQ？backward为何重放RNG？硬化误差如何验收？bit/param为什么不等于整个模型文件大小？

[来源](source.json)与[验证](verification.json)分别记录阅读、独立示例运行、未做原模型复现。附加阅读，无第二个必做作业。
