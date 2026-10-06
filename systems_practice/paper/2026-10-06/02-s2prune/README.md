# S²Prune：空间覆盖约束下的视觉token预算

[原文v1](https://arxiv.org/html/2609.01224v1) / [记录](https://arxiv.org/abs/2609.01224)，Yuanyuan Jia、Shunpu Tang、Qianqian Yang，2026-09-01首发v1，预印本。实际阅读引言、3节动机、4节方法及表1。未把搜索摘要当全文阅读。

方法把“哪里需要更多token”和“哪个token代表该区域”分开：先以图像Laplacian方差决定局部容量并保留覆盖，再用首decoder block的Early Representation Change选择。表1 Qwen2.5-VL-7B、576→32 tokens，作者报告Acc55.9与Rel79.3%；Rel是十个benchmark各自相对比的平均，不能直接把55.9/68.9当79.3%。该数字是论文报告，不是本机复现。

## 源码与机制

实际读[作者仓库main allocation.py](https://github.com/yuanyuanjia71-spec/S2Prune/blob/main/s2prune/allocation.py)的`build_coarse_regions`、`laplacian_region_complexity`、`largest_remainder_allocation`，2026-10-06；后者检查分数/容量，先保底，再按容量截断最大余数分配。前者灰度四邻域Laplacian、区域方差与归一化，不能用原图亮度均值替代。完整SHA未固定；LICENSE raw请求Internal Error，许可正文待补，不复制源码。qwen.py完整hook与ERC实现未读，故不声明完整调用链已审查。

## 独立小例子与输出

```sh
sh systems_practice/paper/2026-10-06/02-s2prune/run.sh
```

[example.py](example.py)是覆盖/容量机制的独立实现，**使用简化离散边际贪心，不是原作者最大余数算法**；分数为手设，无Laplacian、ERC或模型。4区域各4token，预算8，输出容量[1,1,2,4]；全局Top8仅覆盖2区域，本例覆盖4区域。通过39预算/零分数/集中分数组合，拒绝不可行预算。[实际日志](results/cpu.txt)。假设hidden=64/FP16时，保留payload1024B vs2048B，另32B INT32索引；是由实际选择长度计算的张量payload，非设备峰值/序列KV总内存。

## 复现难度、故障与边界

独立示例易，完整复现难：作者发布协议针对Qwen2.5-VL-7B-Instruct、672×672图像、576视觉token，需要transformers/torch、模型、本地评估数据与原始评分工具，仓库不附权重/数据。先固定源码/许可证，读qwen hook和ERC，用已有一张图跑作者smoke_test，再比较固定seed与相同预算，最后复现表1；当前没有猜测CLI参数，没有下载依赖模型，也没有整模型执行。

故障链一：区域数大于预算→覆盖约束不可行→检查B≥G→减少区域或拒绝输入，不能默默漏区域。故障链二：容量已满仍按分数加token→超预算/重复索引→验证唯一索引及各区上限→剩余额度只分给可用区域。故障链三：纹理复杂但语义不相关→容量倾斜仍可能伤害任务→用独立task评估区分覆盖代理与语义收益→保留uniform/global baseline。本例只证明前两类合同，不证明召回提升。

上线需计算选取/重排成本、首decoder仍完整处理的成本、后续prefill与decode分别计时；没有GPU/NPU测量。CUDA后续只允许Thor SM110并重新核验kernel。追问：coverage为何不同于均匀采样？B<G如何处理？方差为零时怎样分配？容量截断影响最大余数什么步骤？ERC为何不能用随机分数冒充？token减少为何不等于等比端到端加速？

[source.json](source.json)与[verification.json](verification.json)保留阅读、独立CPU与原模型验证边界。
