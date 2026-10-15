# MultiAlloc：把层精度和token保留放进同一预算

## 论文与实际阅读

[arXiv:2610.18642v1](https://arxiv.org/abs/2610.18642v1)，Yangchengyu Zhou、Zhiping Wu、Runchang Jiang、Dongdong Ren、Youfang Han、Wei Zhao、Dongqi Cai、Wenbin Li；首次/v1均2026-10-13，读取2026-10-15，预印本，未核实接收。实际读[全文](https://arxiv.org/html/2610.18642v1) §4、§5.1–5.2表1、§7与附录A协议选段。

## 核心机制与作者证据

作者用校准profile衡量层位宽损失及token保留需求：固定token保留候选后，把剩余预算交给层位宽求解器，再按代理损失选策略。推理不重新搜索分配，但组内top-k选择仍存在。表1在A100、Llama-3-8B、423MB KV预算下，MultiAlloc综合分46.35，PM-KVQ为44.95；FP16参考1024MB为46.17。这是作者任务组合结果，非本机/Thor测量。§7承认profile成本及校准代表性限制。[方法与结果](https://arxiv.org/html/2610.18642v1#S4)。

## 真实作者源码

[RL-MIND/MultiAlloc](https://github.com/RL-MIND/MultiAlloc)，实际commit `ae2451cff712224223defd701d8423ebc72d4fed`，MIT。读取 `allocation/layerwise.py::allocate_memory_budget`（多选择背包）、`allocation/joint.py::estimate_outlier_memory_mb/estimate_layer_scale_zero_memory_mb/dynamic_split_budget`选段及`runtime/cache.py`反量化缓存路径。永久链接与哈希见[source.json](source.json)。README声明解析预算不等于进程峰值；运行时保留反量化缓存说明实测峰值必须另查。仓库有profiling/allocate/runtime/evaluation入口；仅阅读选定实现，未审计所有训练/导出/评估流程。

## 现成独立示例与真实结果

工作目录本课；Python3.9+标准库，`sh run.sh`。`example.py`人工构造两层profile，枚举2/4bit与0/1/2个保留token；每层16token，KV各4维。示例是**独立预算模型**，没有原生量化/校准，不生成packed KV，人工profile不当真实激活统计。简化存储中保留token不再放进低位主体，省略residual/current-group；与作者实际缓存计费不完全相同。

[实际输出](results/cpu.json)：224B预算下选bits=[4,2]、keep=[2,1]，213B；仅算低位payload的128B会掩盖另一方案完整260B超限。冻结策略到变化profile得23，变化profile诊断oracle为3.5；后者只展示失配，不能回填为部署参数。1B预算明确拒绝。此例全部字节是**解析示例模型**，不是实际内存分配或真实存储收益。

## 复现难度、故障与迁移

难度中到高：需要兼容PyTorch/Transformers、本地7B+模型、独立校准/候选选择/评估数据与GPU；原论文A100结果不可迁移为Thor收益。最小路线先运行本预算例，再在已有小模型收集真实profile，固定预算/分区后跑作者分配与评估入口；没有模型/torch，未执行后两步，不下载。若采用CUDA扩展，只能用支持sm_110的工具链，须审计原后端目标列表，当前未验。

故障链一：解析预算通过但OOM→漏计临时反量化/allocator/保留索引→同时记录解析各项与进程峰值→给安全裕量并限制缓存→相同上下文长度回归；不是调小bit就必能解决。

故障链二：校准代理更好任务退化→profile分布不匹配或层间耦合→保留独立评估集并与固定均匀策略对照→回滚不稳定策略→新任务重新校准，禁止用测试集调参。

追问：①层bit与token保留为何竞争？②top-k是否等于在线搜索？③scale/index如何计费？④解析内存与峰值为何不同？⑤profile失配怎样暴露？⑥同预算比较还须控制什么？

阅读、代码交付、CPU示例运行是；原生作者运行、完整精度、延迟、Thor否。[verification](verification.json)。源码检索经作者原文链接；Google近期关键词搜索最初返回无关旧文，改读arXiv recent；未采用二手摘要。
