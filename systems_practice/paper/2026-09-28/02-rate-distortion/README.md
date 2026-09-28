# 固定码率，才知道量化器改善了什么

**A Unified Rate-Distortion Perspective on Vector, Product, and Scalar Quantization**，Xianghong Fang、Wenlong Mou、Yuan Yuan、Dehan Kong、Tim G. J. Rudner；首次公开2026-09-02，所读arXiv:2609.02107v1。[元数据](https://arxiv.org/abs/2609.02107) · [一手全文](https://arxiv.org/html/2609.02107v1)。未确认同行评审，按预印本处理。

实际阅读§2–5、表2、附录G/H及表8。方法把预算写作 `R=T*log2(K)`，失真为 `E||x-Q(x)||²`；PQ的K是各子码本大小的乘积。控制输入分布和码率，才能隔离量化结构。码本利用率不直接决定失真；这个码率也不等于含码本与metadata的实际文件大小。

作者ImageNet-1K、固定T=512/K=65536条件下，最佳VQ/PQ/SQ失真分别0.201/0.209/0.231。训练系统、投影器与优化预算仍影响结果；结论不能直接变成LLM W4优于W8或硬件速度排序。原实验需要预训练tokenizer与数据，附录训练用两块H100；今天没有复现或转为别的CUDA执行目标。

[作者仓库](https://github.com/VQ-Research/Rate-Distortion-Perspective) 的README与目录已读，包含Pixel-Space和VQ-Transplant；实现子目录访问失败，**尚未逐函数审查训练、导出、评估完整性与代码许可证**。因此下方是独立数学实验，不调用猜测的仓库API。

**完整复现难度：中到难**。需要Python/PyTorch、预训练VAR tokenizer、图像数据、匹配作者环境与优化设置；先核实源码与许可证，再用本地小数据固定编码器输出，比较相同token与码空间，最后评估重建和完整成本。不会自动安装或下载。小例子几秒以内是本地观察，不是作者训练耗时。

```sh
sh systems_practice/paper/2026-09-28/02-rate-distortion/run.sh
```

[example.py](example.py) 用标准库与实际Lloyd中心更新，在256条训练/128条独立评估的相关4维向量上比较：SQ每维2码、PQ每2维4码、VQ整向量16码，都4bit/向量。VQ从PQ组合中心初始化，检查训练失真不增；不保证heldout排序。没有额外调参集，因为不选超参或最佳评估结果。

[真实输出](results/output.json)：heldout每向量MSE为SQ1.359864、PQ0.451349、VQ0.147151；PQ/VQ利用率同为0.375；VQ有33次中心变化。零输入与空簇保留检查通过。码本参数数量为8/16/64个浮点数；512bit是评估token名义预算，**没有生成packed文件**，不能当作实测压缩大小。此例不是MMD训练、VAR模型或硬件基准。

[来源](source.json) · [验证](verification.json)
