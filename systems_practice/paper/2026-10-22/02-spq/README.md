# SPQ：组合压缩之后，检查真实存储与执行路径

## 论文与实际阅读

Jiamin Yao、Eren Gultepe，[SPQ: An Ensemble Technique for Large Language Model Compression](https://aclanthology.org/2026.lrec-1.489/)，DOI 10.63317/3t98siww4xf2；arXiv:2602.18420v1首发2026-02-20，LREC2026正式论文5月11–16日。距今244天，使用365天例外：有正式会议版本与可读作者实现，适合审查部署存储边界；不把5月会议当首次公开。实际读会议PDF4.1–4.4、5.1、6.5表3、8局限，表格截图工具失败，不声称视觉校对成功。

## 方法与作者结果

框架在attention投影采用保留奇异值平方能量的低秩分解，MLP按激活统计剪枝，再做8-bit量化并以LoRA恢复。令累计奇异值能量达到阈值的最小rank为r；是否节省参数还要检查`r*(m+n)<m*n`。

作者表3的LLaMA-2-7B SPQ权重内存6.86GB、WikiText-2 PPL4.91，对比原模型26.95GB/5.47；同表C4 PPL从6.85升为7.11。论文设备为两张A100-40GB，不能只摘改善数据或当Thor结论。配置与恢复训练依赖任务，不能据此保证任意组合都更优。[会议全文](https://aclanthology.org/2026.lrec-1.489.pdf)。

## 源码审查与独立实现关系

旧作者URL实际迁移到[spq-compression](https://github.com/JiaminYao/spq-compression)，本次commit `5a745b8dc6cac8fd1c2608a77fb3878fc2b25bf1`。[svd.py](https://github.com/JiaminYao/spq-compression/blob/5a745b8dc6cac8fd1c2608a77fb3878fc2b25bf1/methods/svd.py)的`compute_cumsum_rank_ratios → apply_svd_compression → svd_compress_layer`有保留比例/删除比例转换及小矩阵、压缩收益守卫，不能只看变量名判断含义。

[linear_quant.py](https://github.com/JiaminYao/spq-compression/blob/5a745b8dc6cac8fd1c2608a77fb3878fc2b25bf1/methods/linear_quant.py)的`QuantLinearChannelWise`同时保留FP32 Parameter和INT8 buffer；forward转float反量化后调用functional.linear。这是代码观察，表3的权重内存统计能否覆盖这些持久副本仍待完整复现核对，不能用i8 buffer字节冒充整个模块驻留，也不能说当前forward是原生INT8 Tensor Core。

实际还读pruning的比例/MLP裁剪函数、main调用点、fine_tune中的真实AdamW/反传更新、wrappers与requirements。依赖指定torch2.8.0、transformers4.56.1、NumPy2.3.3等；本机没有torch，不运行作者pipeline。仓库树无LICENSE，许可待核实；本课未复制源码。取得文件/阅读与运行分开见[source.json](source.json)。

## 现成小例子与真实输出

[example.py](example.py)独立用NumPy构造8×8矩阵，能量阈值0.97选rank2，再将两个因子按行INT8打包，写自定义文件并重载；不调用作者API，没有MLP剪枝或LoRA更新，因此不是完整SPQ复现。

```sh
PYTHON=/Users/guhaoran/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 sh systems_practice/paper/2026-10-22/02-spq/run.sh
# 其他已有NumPy环境用 PYTHON=/path/to/python；不自动安装。
```

本机NumPy2.3.5，[输出](results/output.json)：原FP16权重128B，自定义文件88B，其中INT8因子32B、scale40B、头16B；若保留FP32因子另加128B。eval MSE截断0.1582386、打包0.1591261；沿被截断方向偏移后0.2834933/0.6401664，退化保留。2×2全秩双因子8参数反而超过原4参数，说明选rank还需空间账。只是合成重建误差，无任务精度、计时或GPU/NPU/E2E数据。

## 复现难度、故障与验收

难度：难。完整路线需作者固定版本的模型/校准/微调/评估与GPU内存；用本地已有权重先跑层级一致性，再记录所有parameter/buffer/临时量，最后对齐任务评估与真实导出文件。默认代码会下载模型/数据，本次未运行。设备迁移到Thor必须单独确认PyTorch/JetPack和算子支持，CUDA目标只用sm_110。

两条故障链：①声明压缩但进程内存上升→检查FP32影子/临时反量化与所有state_dict项→导出时明确定义持久量并验证重载，不能未经验证删训练依赖；②低秩误差在普通样本小、特定任务大→检查输入沿被丢弃奇异方向的能量→增加rank/代表校准与恢复训练，代价是存储和计算增加。迁移验收需原生层输出、任务分布偏移、实际文件/驻留峰值、同步计时和持续运行。

追问：①权重Frobenius误差为何不等于输出误差？②rank为什么不能只按能量阈值选？③INT8 buffer与完整模块存储有什么差别？④反量化float GEMM能否称INT8计算？⑤LoRA收益如何公平对照？⑥元数据何时使低秩量化不划算？

[验证](verification.json)：论文和选定作者实现已读，独立NumPy例已跑；作者完整pipeline、训练、模型导出及Thor未验证。
