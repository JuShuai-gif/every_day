# 2026-09-28 OmniQuant：原生 LWC 的校准更新与导出边界

## 方法与应用场景

今天只深入 **Learnable Weight Clipping（LWC）**：固定模型权重，用小校准集的输出重建损失学习裁剪上下界。OmniQuant 是 PTQ 方法；优化少量量化参数并不等于完整权重 QAT。LET 是同一方法的另一组件，利用等价变换调整量化难度，本例关闭 LET，避免把整层图改写塞进一个小例子。

算法、格式、位宽分别看：本例使用均匀仿射整数码域 0..15、每行每16权重一组的 scale/zero，round-to-nearest 的 torch.round/STE；实际 `QuantLinear` 输出是 FP32 QDQ，激活保持 FP32。另提供输入与权重 FP16 存储往返、FP32 累加参考。这里不是原生 W4A16 Tensor Core 测试，也不是 INT4 压缩 checkpoint。输入 `[64,32]`、权重 `[8,32]`、输出 `[64,8]`，合成层误差不等于语言模型任务精度。

## 原仓库与实际读过的实现

原仓库 [OpenGVLab/OmniQuant](https://github.com/OpenGVLab/OmniQuant)，网页历史解析的固定 commit `feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14`，读取 2026-09-28，未发现仓库迁移。许可证文件实际叫 **LICENCE**，main 读取为 MIT、Copyright 2024 Mengzhao Chen；固定 commit 的 LICENCE/README 请求失败，已单列版本核实边界。获取失败原样记录在 [source.json](source.json)，网页阅读证据在 [source-read.json](source-read.json)。本地无可验证缓存。

已读固定版本具体实现：

- [int_linear.py / QuantLinear.__init__, forward, set_quant_state](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/int_linear.py)：包装已有 Linear，先 QDQ 再调用 F.linear。
- [quantizer.py / UniformAffineQuantizer、per_token_dynamic_calibration、fake_quant、round_ste](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/quantizer.py)：分组 min/max 乘 sigmoid 裁剪因子，生成 scale/zero，再舍入、夹紧与重建。
- [omniquant.py / omniquant、get_named_linears、add_new_module](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/omniquant.py)：完整模型入口逐层重建，更新 LET/LWC 参数，真实导出分支调用 AutoGPTQ pack。本例调用前两个原生类，训练循环与评估为独立教学驱动，并非完整层级 OmniQuant 复现。

## 如何接入我的代码

[完整 upstream_api.py](upstream_api.py) 和 [run.sh](run.sh) 已交付。原 README 推荐 Python3.10；本例最低 Python3.10，PyTorch **2.6 或更新**作为 `weights_only=True` 的保守运行候选，另需 numpy/tqdm（上游 quantizer 直接 import）。本机实际 Python3.9.6 且三包均缺；不把候选版本写成已测试矩阵。原项目整模型依赖与该最小类调用不同，setup.py/requirements.txt 等尝试失败，之后已实际读到 main 的 pyproject.toml：包版本0.1.0、Python>=3.8、torch>=2.0.0、transformers>=4.31.0；其余整模型依赖很多且非严格锁定。固定commit包装文件访问仍失败；本例选择Python3.10是教学运行约束，不是上游硬性最低版本。另发现classifier标Apache而LICENCE正文为MIT，应在再分发前核实固定版本。未安装任何东西。

联网环境可在 EveryDay 根目录准备固定源码（本次未成功；不自动运行安装脚本）：

```sh
mkdir -p systems_practice/.tmp/quant_sources
git clone --filter=blob:none --no-checkout https://github.com/OpenGVLab/OmniQuant.git systems_practice/.tmp/quant_sources/omniquant-pinned
git -C systems_practice/.tmp/quant_sources/omniquant-pinned fetch --depth=1 origin feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14
git -C systems_practice/.tmp/quant_sources/omniquant-pinned checkout --detach feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14
sh systems_practice/quantization/2026-09-28/omniquant/run.sh
```

若源码已有其他路径，设置 `OMNIQUANT_SOURCE` 为绝对路径；若依赖在已有环境，设置 `PYTHON` 为该解释器。运行会核对干净的固定 commit。缓存与 checkpoint 都在忽略目录；不下载预训练模型。

执行路线：构造固定种子 Linear → 128条 calibration 用来更新裁剪 → 两档学习率各80步 → 64条 tuning 选配置 → 冻结后仅一次使用64条 heldout及其分布偏移对照 → 导出并重载浮点重建权重。原始权重冻结，逐步输出 loss 与非零参数更新量；两候选各从相同状态重启。实际更新是否发生须以运行日志为证，今天因依赖缺失还没有训练输出。

已有 Linear 的接入点是 `layer`，要求二维权重且输入维度可按16分组；保留你的权重与代表性独立校准数据，替换这里的随机张量。原生 `QuantLinear(layer, weight_quant_params=..., disable_input_quant=True)` 后调用 `set_quant_state(True, False)` 才启用量化。部署接入示例为把导出 `weight` 拷入普通 Linear；这是精度验收接口，实际驻留仍为 FP32。不要把 calibration 与最终任务测试集混用。

## 量化前后比较

本例会产生 `build/native/comparison.json` 与 `build/native/reconstructed.pt`，包含 FP32、FP16存储参考、absmax、原生 RTN、原生 LWC 的 NRMSE/最大误差/余弦、码域裁剪比例、真实 checkpoint 文件大小、权重和 scale/zero 张量字节数。持久 checkpoint 明确保存 FP32 QDQ，**不压缩为 INT4**；实际 packed后端导出仍待补，不能把理论128B的4位权重当成已测文件大小。

| 项目 | 今日状态 |
| --- | --- |
| 原生校准、梯度更新、 heldout/shift误差 | 未运行，缺checkout与依赖 |
| 零权重、重载输出等价检查 | 已写代码，未运行 |
| 实际存储/精度/性能数字 | 未产生，不用推算值补表 |
| CPU框架计时 | 10预热50采样代码已备；FP32、重建Linear、动态QDQ分开 |
| 校准优化时间 | 计时包含两学习率搜索，未运行 |

无收益或偏移退化会原样写入结果，脚本不要求 LWC 一定优于 absmax。它不是第二个编码作业。

## Thor SM110 与优化

今天只交付原生算法 CPU 路径，没有自写 CUDA kernel。[NVIDIA当前兼容页](https://developer.nvidia.com/embedded/jetpack/downloads) 显示 Thor/T5000 搭配 JetPack7.2.1、L4T39.2.1、CUDA13.2.2；不等于旧 AutoGPTQ/Triton 打包后端已经支持该目标。原仓库真实导出分支的 W2/W3/W4 + A16 限制已读，后端实现与现代 torch 的兼容未验，因此不提供未经审查的扩展安装命令或声称 Thor 原生低位加速。以后扩展构建必须显式固定 `TORCH_CUDA_ARCH_LIST=11.0` / `sm_110` 并确认构建脚本确实消费此设置，不能改用专属后缀。

PTX/SASS、ncu 与低位kernel优化尚不适用此 CPU QDQ 示例；没有伪造 ISA、周期或提速。完整设备后端审查进入 backlog。

## 验证与待补

[verification.json](verification.json) 五项：源码本地获取否、固定commit实现网页阅读是、原生API例子交付是、CPU例子运行否、Thor验证否。[实际失败输出](results/native-attempt.txt) 保留。当天仅重试一个旧项 AWQ：[记录](../awq-retry-source.json)，同样 DNS 失败。下一自然日轮到 QuaRot；本方法仍在 backlog，不能标作完整运行成功。
