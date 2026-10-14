# TaSQ：让KV码本优化与query误差对齐

Minsoo Cheong、Donghyun Son、Sungjoo Yoo；[arXiv:2610.03027v1](https://arxiv.org/html/2610.03027v1)，2026-10-02首发/所读版本，按预印本处理。实际读§3动机、§4方法、§5表1及§6讨论。

论文用query统计为key通道加权，在pre-RoPE空间做VQ，并使用跨head共享scale与保留RoPE成对关系的协方差分组。核心近似为`E[(qᵀδ)²]≈δᵀdiag(E[qqᵀ])δ`，因此普通key MSE可能与注意力误差不一致。作者表1：Llama-3.1-8B-Instruct的六任务平均，TaSQ59.21、BF16 63.94；K/V实际1.266/1.250位，不能简写成所有缓存严格1bit。依赖校准统计和对角近似，变化的query分布仍是边界。[原文](https://arxiv.org/html/2610.03027v1)

作者[mscheong01/TaSQ](https://github.com/mscheong01/TaSQ)，commit`28532bc03266a87c4e079e2c3da52dab257c115a`，Apache-2.0根LICENSE正文已读（第三方另有许可）。2026-10-14实际阅读：

- [codebooks/make_tasq.py](https://github.com/mscheong01/TaSQ/blob/28532bc03266a87c4e079e2c3da52dab257c115a/codebooks/make_tasq.py)：`hook/install_hooks`和pass1 causal query moments，suffix sum对合法因果query-key对累计，并有完整einsum核对；已定位`det_cost/match_groups`入口，分组实现全文未逐行审计。
- [calibration/group_vq_codec.py](https://github.com/mscheong01/TaSQ/blob/28532bc03266a87c4e079e2c3da52dab257c115a/calibration/group_vq_codec.py)：`group_boundaries/_kmeans/_assign/GroupVQCompressor.encode_idx`及decode开头。这是辅助QPCA/VQ实现，不能把它称为全部正式TaSQ路径。

仓库可见校准、码本、SGLang和评估入口，但未构建服务后端或运行模型；主调用链核验局限于模型Q/K hook→校准统计→码本准备。正式入口会加载模型/数据，本次只读取，不执行下载。

独立[example.py](example.py)仅实现二维query加权k-means：128校准点、64独立评估点、4中心，20次中心更新；无RoPE、跨头scale、Fisher权重或matching，不是TaSQ复现。真实2bit索引4个装一字节，16B索引+32B FP32码本落盘48B；每通道索引1bit，但本小样本总开销3bit/channel。

```sh
sh systems_practice/paper/2026-10-14/02-tasq/run.sh
```

[实际输出](results/cpu.json)：普通/加权码本的对角QK误差19.33595→1.75108，而key MSE1.53190→4.13647。新query方向下误差7.74465→64.80857，保留校准失配反例。不测GPU、NPU、CPU或端到端性能。源码与五类验证界限见[source.json](source.json)、[verification.json](verification.json)。

复现难度：难。需已有LLM权重、校准语料、torch/transformers、networkx与SGLang匹配版本，审计码本、scale与后端完整部署链。先在本地小张量核对索引/码本和加权目标，再用独立样本验证QK/任务精度，最后确认Thor sm_110后端构建和解码计时；本次未核实SGLang/Triton对该固定目标的完整兼容组合，不照抄Ada执行命令。

故障链：①key MSE更好但attention更差→量化目标未包含query敏感度→在固定query上测QK误差→用校准权重并回归分布偏移；②容量号称1bit却OOM→忽略codebook/scale/残留缓存→按真实文件/张量字节拆账→长短context分别验收。③RoPE分组错配→频率与pair布局不一致→核对整对置换和原向量恢复→保持配对合同，此项只据源码/论文分析未运行。

追问：①key MSE为什么不是attention MSE？②对角近似忽略什么？③码本为何要摊销？④RoPE整对置换解决什么？⑤校准shift怎么设计？⑥索引压缩比为什么不等于端到端收益？
