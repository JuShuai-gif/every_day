# Influence-Inspired Spectral Rotations for Extreme Low-Bit LLM Quantization：旋转等价性与校准能量缩放

## 论文与证据

[Influence-Inspired Spectral Rotations for Extreme Low-Bit LLM Quantization](https://arxiv.org/abs/2605.25203)，Gorgi Pavlov（Lehigh University），首发2026-05-24，读v1预印本。名称以arXiv元数据为准；本日实际读取[全文](https://arxiv.org/html/2605.25203v1)§2式1–3、§3.1表1与复现设置、§3.2失败案例及限制。主题是在极低位权重量化中，让校准激活能量参与旋转后的通道尺度分配。

作者报告SmolLM-135M的W2A16/g64 WikiText2 PPL从81.03降到45.11。环境为torch FP16、transformers4.57.6、auto-round0.12.2、enable_alg_ext=False；128×2048校准token，8192评估token/1024窗口。单seed、小模型/有限数据结果，没有跨seed显著性证明。W4收益接近±0.5波动；Qwen3可失败。OpenVINO演示把权重解码回FP16，不能视作原生W2速度证据。Boolean influence术语不自动构成LLM量化误差定理。

## 实际读过的仓库

[gogipav14/spectral-llm](https://github.com/gogipav14/spectral-llm)，commit `792d3347792aaa7916da70e465c366b3cdbc546a`，2026-10-21读选定实现与MIT LICENSE；未运行作者AutoRound/LLM流程。

- [`boolean_fourier/bbt_quant/influence.py`](https://github.com/gogipav14/spectral-llm/blob/792d3347792aaa7916da70e465c366b3cdbc546a/boolean_fourier/bbt_quant/influence.py)：1–225行，`_SpectralEnergyHook`采集、`compute_layer_influences`聚合、`bbt_channel_scales`产生scale。
- [`autoround_bbt.py`](https://github.com/gogipav14/spectral-llm/blob/792d3347792aaa7916da70e465c366b3cdbc546a/boolean_fourier/bbt_quant/autoround_bbt.py)：1–180行，`prepare_model_for_autoround → _apply_column_scales/_set_input_inverse_scale → quantize_with_autoround`。

核查发现：实现按batch均值累计，batch大小不一时不等于逐token平均；非二次幂维度的能量先slice回d_in再归一化，与论文保留padding坐标的描述需对照；函数正文scale含d·rho，不能照抄旧注释的(1+rho)^alpha；wrapper默认enable_alg_ext=True，与表1设置False不同，复现必须显式指定。源码阅读不是对这些差异影响量级的实测。

## 耦合机制与独立反例

正交归一化Hadamard H满足HᵀH=I。输入xH、权重行wH保持内积；若对权重乘正对角D，输入就须除以D，才有 `(xH D⁻¹)·(wH D)ᵀ=x·wᵀ`。激活旋转能量rho_j=E[(xH)_j²]/ΣE，scale d_j=(1+4rho_j)^alpha。它用校准分布改变权重量化误差落点；scale不是免费提升，输入逆变换与元数据都需要付成本。

本地`example.py`是论文机制启发的独立4维/3输出演示，不调用AutoRound：Python FP64计算、归一化H、每行min-max u2 RTN（非对称，4个码，显式FP32 min/scale），不是论文g64。真实把12个u2码打包成3字节，并保存6个FP32量化元数据及4个FP32通道scale。校准64、调参32、eval31、shift31样本不同seed，alpha只从调参集选；没有训练更新，AutoRound更新未复现。量化前后误差只对同一玩具矩阵，不是语言任务PPL。

```sh
# EveryDay根目录，Python标准库
sh systems_practice/paper/2026-10-21/02-spectral/run.sh
```

[实际结果](results/cpu.txt)：未量化等价性最大误差1.78e-15，调参选alpha0.5，打包重载输出精确一致，全零权重边界通过。

| 数据域 / MSE | 普通u2 | 仅旋转 | 旋转+选定scale |
| --- | --- | --- | --- |
| 独立同分布eval | 0.147610 | 0.593425 | 0.027168 |
| 能量主轴偏移shift | 0.158380 | 0.284501 | 0.895014 |

**存储也退化**：文件43B（码3+量化元数据24+通道scale16），对照FP16权重payload24B。文件含恢复矩阵所需数值元数据，但shape/格式为脚本固定约定，不是通用模型容器；FP16对照也只是权重payload，不含容器。不能只说码值缩8倍而忽略元数据。没有测host/GPU/NPU延迟，标量FP64 MAC不代表原生2bit推理。

## 工业故障链与复现路线

1. 加权重scale却遗漏输入逆scale → 未量化输出先失配 → 先验收变换等价性，再谈量化误差；实际模型需为每个Linear注册正确输入变换且导出保存它。
2. 调参/评估用同一分布并选最优 → 校准能量主轴改变时误差暴涨 → 本例shift独立保留退化，生产按请求域监控误差与分布，回滚到普通量化/高位。
3. 只数packed bits忽略scale/rotation → 小层占用和延迟反增 → 统计真实文件、内存、在线Hadamard和逆scale成本，不能只报GEMM核心吞吐。

复现难度中高：锁作者commit及表1环境，显式enable_alg_ext=False、固定数据/seed/窗口，分别比较FP16、普通AutoRound、旋转、scale四组，核对g64/尾组/padding和模块替换范围；多seed及任务评估后再迁移实际后端。不得用本例RTN证明作者训练流程已复现。无模型/依赖下载；目标设备扩展一律Thor sm_110，当前没有原生2bit后端验证。

追问：①旋转为何须同时作用于权重与输入？②scale乘/除放反如何检测？③padding后裁剪为何可能改变rho？④batch均值与token均值何时不同？⑤分布偏移为什么会反转收益？⑥打包字节数为何不等于模型文件或运行内存？

[source.json](source.json)和[verification.json](verification.json)分别记录论文/代码阅读、本机实验与未复现部分。
