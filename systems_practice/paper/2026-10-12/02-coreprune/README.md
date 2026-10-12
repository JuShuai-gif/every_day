# CoRePrune：救回token的收益取决于删除集合

Shengli He、Yongchao Liang、Roumeng He、Junjie Zeng、Jiyuan He、Xin Fang、Can Wu、Li Zheng，**From Token Importance to Conditional Removability: Rethinking Visual Token Pruning in Multimodal Large Language Models**，[arXiv:2609.26484v1](https://arxiv.org/abs/2609.26484v1)，首发/所读版本2026-09-22；读取2026-10-12，预印本，未核实接收状态。实际读[一手全文](https://arxiv.org/html/2609.26484v1)III的Eq1–7、IV诊断、V方法、VI-G表VII及VII讨论选段。

## 问题与机制

视觉token过多增加prefill成本；一个token当前分数低，不说明在任何层、任何删除组合中都可安全删。固定head/receiver，`Y=Σ ai Vi`，删除集合S的注意力质量`M=ΣS ai`。重归一化后局部误差为 `||ΣS ai(Vi-Y)||/(1-M)`。救回i的边际是`D(S)-D(S\{i})`，可以为负，因为原先相互抵消的残差被打破。

方法第一阶段在视觉编码器不同深度刷新删除分数，第二阶段在视觉与文本交互后按当前集合救回候选。作者默认批次B=4，每批后刷新；它是启发式，不依赖子模性或保证全局最优。最后按原顺序gather缩短实际序列，单把mask设零不等同于节省后续计算。

## 作者结果与复现边界

VI-G表VII在Qwen3.5、1500个TextVQA样本、每样本16步解码、3次配置重复中，预算KL=128/KV=256：aggregate prefill从323.4±2.5秒到158.3±1.8秒，包含选择开销；decode为23.8→24.3秒，并没有同幅度加速。不能把这个总时间当单请求延迟。主要存储仍是权重，因此峰值内存下降有限。这些是作者报告，未在本机或Thor复现。

正文链接和`CoRePrune github`检索没有找到可核实的作者实现；检索结果里的同名图算法无关，未冒充仓库。不提供猜测的作者API。代码、导出/评估链和许可证仍待核实，见[source.json](source.json)。完整复现难，缺公开实现使架构对齐候选单元、attention取得方式与层索引都需独立实现核对。需PyTorch/Transformers、对应VLM权重和图文数据、足够GPU内存；具体版本/最低显存未核定。小机制示例仅Python标准库。

最小路线：先固定head/receiver验证Eq4→审计目标VLM的patch merge与位置编码→实现逐层刷新及batch rescue→按顺序实际gather→相同输入预算比较原模型、静态选择和动态选择→记录选择开销与整段prefill/解码。未来CUDA仅Thor SM110；作者表中GPU结果不是Thor工具链兼容证据。

## 可运行独立示例

```sh
sh systems_practice/paper/2026-10-12/02-coreprune/run.sh
```

[example.py](example.py)用4视觉token加1个始终保留的文本token，16个子集核对残差公式和直接归一化结果。静态保留[2,3]误差0.370714，条件救回保留[0,1]误差0.165，本例恰与穷举最优相等，**不是全局保证**；真实日志还保留6个负救回边际以及删除全部质量的拒绝，[输出](results/output.json)。B=1、单head/单receiver、固定attention，没有深度刷新、位置编码、多模态模型或训练更新，不能叫完整CoRePrune复现。

## 故障分析、迁移与追问

1. 每轮都沿用单点排名→联合删除后误差反增→固定候选只改变S，重算边际与静态排名对照→刷新集合统计；代价是选择计算，必须计入prefill。
2. 选对token却精度突降→破坏原序/merge单元或位置编码→先做全保留恒等回归，再检查candidate到LLM token映射→保留架构一致单元与原顺序，不能任意扁平重排。
3. token数少但耗时未降→只mask而未缩短，或选择开销更大→记录实际shape与选择/后续计算分段时间→物理gather；小预算/短输入允许回退密集执行。

验收需全保留恒等、空候选/零剩余质量、批次最后不足B、多个图像与视频位置编码、精度/latency同输入；本例只完成局部数学项。追问：为什么救回会使误差变大？深度与集合条件分别改变什么？B=4付出什么近似？保留一个文本token有何作用？选择更慢为何仍可能降低prefill？
