# LAST：在传输前选择与问题相关且不重复的视觉token

## 论文与实际阅读

Feng Yang、Xinrui Ju等9位作者，[arXiv:2607.27952v1](https://arxiv.org/html/2607.27952v1)，首发2026-07-30，预印本，未核实同行评审接收。实际读Method的接口、评分/选择公式7–12，实验设置、表1/2与结论；详细元数据见[source.json](source.json)。标题/id的GitHub检索未找到可验证作者仓库，不能称已读作者实现。

## 方法与作者结果

边缘小模型用最后一个query token对视觉token的attention产生重要性；再用“重要性×到已选集合的最小余弦距离”逐个选点，并恢复原序。共享视觉编码器的接口兼容性是云端直接消费所选特征的条件，不适用于任意两个VLM。

作者在InternVL2-1B/8B设置、A800 80GB单卡模拟上报告保留12.5% token时相对综合表现95.4%。表2同时显示LAST的边缘阶段236.43ms，高于无proxy的Full Tokens118.55ms；2.51ms仅为评分聚合。因此减少云侧token不等于边缘阶段更快，更不能直接当真实网络端到端收益。[方法与表格](https://arxiv.org/html/2607.27952v1)。

## 现成小例子

[example.py](example.py)是独立Python标准库实现，只有4个二维特征、两个head提供的合成最后query注意力；不计算VLM attention、不访问模型。首点取最大权重，后续按`w_i*min(1-cos)`选点；预算2与top-k对照。运行：

```sh
sh systems_practice/paper/2026-10-22/01-last/run.sh
```

[真实输出](results/output.json)：top-k=[0,1]选择相似点，覆盖规则=[0,2]。预算0/全部、零向量、非法预算/权重通过边界检查。若真实需求换成token1，覆盖规则仍会漏掉它，反例保留。两点FP16 payload8B，但加u32索引又回到16B；这只是自定义协议的字节账，实际模型通常有更多维度和协议开销。没有训练或性能测试。

## 复现路线与迁移验收

难度：难。完整复现需对应InternVL模型/预处理/attention提取、11项基准、edge-cloud接口和硬件；现有例子只需Python3，无依赖安装。最小路线是先用本地已有checkpoint取得真实注意力和视觉特征，核对保留顺序，再对齐同输入的任务准确率，分测视觉编码、proxy prefill、选择、网络、云推理。未提供未经源码核实的原生API。CUDA执行始终Thor SM110；没有把作者A800运行命令移植过来。

两条排障链：①答案所需细节丢失→检查proxy权重是否错判与重复覆盖，而非只看保留率→增加预算或回退全token，重测任务精度；②token减少但延迟增长→分段查看proxy/attention抽取成本与网络节约→在真实带宽和模型上选择阈值。要求云端connector/位置映射兼容；吞吐不外推自定义CPU例。

追问：①为什么最后query位置能覆盖前文？②评分复杂度与完整prefill复杂度为何不同？③纯top-k会浪费哪些预算？④选择后为什么恢复原序？⑤代理模型偏差如何放大？⑥何时metadata使小payload压缩失效？

[验证](verification.json)：全文选段已读、独立CPU例运行通过；作者实现、完整模型、网络和Thor未验证。
