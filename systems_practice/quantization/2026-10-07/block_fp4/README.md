# 2026-10-07 每日量化：NVFP4的双层scale与真实打包

## 方法与应用场景

今天只深入 **NVFP4动态块缩放PTQ**：边缘Linear权重与激活如何用FP4码保存，为什么只记录“4bit”不足以重载。算法是absmax驱动的分块浮点映射；数值格式E2M1；位宽W4A4；训练范式PTQ，无QAT/梯度更新。MXFP4仅格式对照：本次所读ModelOpt配置的块32、E8M0 scale，与NVFP4块16、E4M3 scale及全局FP32 scale不可互换。它们也都不是INT4或NF4。

原生示例W[32,64]、X[16,64]，FP16输入、行优先、K轴块16；输出用解码后的FP32矩阵乘对照，明确没有原生低位Tensor Core。独立例X[8,65]/W[17,65]演示尾块padding，不能把它当上游支持任意K的证据。

## 原仓库与实际读过的实现

仓库 [NVIDIA/Model-Optimizer](https://github.com/NVIDIA/Model-Optimizer)，tag **0.35.0**、commit **c359cb774db4daab623cddde6c7e0399a49cf7d2**，读取2026-10-07，Apache-2.0文件SPDX与setup.py已核实；`LICENSE`直访Cache miss，完整仓库许可文件待本地拉取。release页面解析到完整commit，但源文件实际读自tag，未声称全hash raw请求成功。当前规范仓库可访问；setup.py仍写旧TensorRT-Model-Optimizer URL，不能据此把旧路径视为当前地址。

具体永久链接与调用链：

- [NVFP4QTensor.quantize / get_weights_scaling_factor / _cast_fp4 / dequantize](https://github.com/NVIDIA/Model-Optimizer/blob/c359cb774db4daab623cddde6c7e0399a49cf7d2/modelopt/torch/quantization/qtensor/nvfp4_tensor.py)：输入→padding→双scale→E2M1舍入→两码一字节→反量化。
- [config.py NVFP4_DEFAULT_CFG/MXFP4_DEFAULT_CFG](https://github.com/NVIDIA/Model-Optimizer/blob/c359cb774db4daab623cddde6c7e0399a49cf7d2/modelopt/torch/quantization/config.py)：核对格式/块长，不直接调用整个量化模型流程。
- [backends/utils.py fp4_compatible](https://github.com/NVIDIA/Model-Optimizer/blob/c359cb774db4daab623cddde6c7e0399a49cf7d2/modelopt/torch/quantization/backends/utils.py) 与 [setup.py](https://github.com/NVIDIA/Model-Optimizer/blob/c359cb774db4daab623cddde6c7e0399a49cf7d2/setup.py)：核对设备查询和依赖。

[获取原始记录](source.json)保留DNS失败；[阅读记录](source-read.json)独立保存网页证据。没有可验证本地缓存。BaseQuantizedTensor文件未取到，构造签名由已读quantize内部 `cls(shape,dtype,packed)`调用核验；原生示例依赖该版本内部 `_quantized_data`，升级需重审。

## 如何接入我的代码

依赖：该版本Python>=3.10,<3.13、torch>=2.6及setup.py依赖（numpy、pydantic>=2、torchprofile等）；本机Python3.9且缺torch，不自动安装。Torch最低版本不等于支持Thor；目标必须已有CUDA13兼容的aarch64 PyTorch及SM110支持，运行前核对实际wheel/驱动。固定源码准备命令只在可达网络执行：

```sh
# 仓库根，缓存必须位于systems_practice；不会自动安装依赖。
git clone --depth 1 --branch 0.35.0 --filter=blob:none https://github.com/NVIDIA/Model-Optimizer.git systems_practice/.tmp/quant_sources/modelopt-035
git -C systems_practice/.tmp/quant_sources/modelopt-035 rev-parse HEAD
# 必须是c359cb774db4daab623cddde6c7e0399a49cf7d2，再使用对应已准备环境
export TORCH_CUDA_ARCH_LIST=11.0
sh systems_practice/quantization/2026-10-07/block_fp4/run.sh native
```

[example.py](example.py)原样调用已读 `NVFP4QTensor.quantize(...block_size=16,try_tensorrt=False)`，传入安全的正global scale；`dequantize(scale=...,double_scale=...,block_sizes={-1:16},fast=False)`重建。原生返回payload、block scale、global scale，保存到忽略的build/weight.pt后重载并检查逐位一致；输出既报告tensor物理字节，也报告torch容器真实文件大小。CPU入口不能保证可用：条件表达式先执行fp4_compatible，其内部无条件查询CUDA0，故本例要求Thor而非MonkeyPatch它。

接入已有 `nn.Linear`：取其 `weight.detach()`（形状out×in），使用本例quant并保存三部分；计算时以 `x @ dequantized_weight.T` 接入，bias在输出后添加。当前示例无bias/自动模块替换/真实TensorRT导出；这是完整的原生张量存储API用法，torch容器是自定义checkpoint而非TensorRT引擎。激活校准64×64与评估16×64独立随机生成（评估标准差0.5，校准1，另有常量100的包络失败检查）；没有训练/调参集（未训练、不搜参）。模型级任务指标需要用本地真实数据另验。

数值语义：全局g≈amax/(6×448)，块scale编码 `s=E4M3(amax_block/(6g))`，E2M1值乘 `s×g`恢复；无整数zero-point，舍入为最近偶数。每个uint8低四位保存偶数列、高四位保存奇数列，scale每16值一字节。独立例将scale饱和到最大有限E4M3；上游直接float8 cast在严重超范围时可能得到NaN，因此本课原生包装显式拒绝超出校准包络的输入，不把独立shifted结果冒充上游行为。独立例对全零/极小scale显式兜底，FP32文件scale先舍入再参与数值，避免“内存算一个scale、文件存另一个”。源码注释把若干边界写错时以实际索引/表值为准，不能复制注释推导舍入。

## 量化前后比较

[独立标准库例](independent.py)运行：`sh systems_practice/quantization/2026-10-07/block_fp4/run.sh independent`。算法层独立实现，不调用原仓库；Python的matmul按double累加，FP16参考只量化输入/权重，**不是硬件FP16累加或GPU测试**。

| 同一X/W | 输出NRMSE | 最大绝对误差 | 余弦 |
| --- | --- | --- | --- |
| FP16输入/权重参考 | 0.000324 | 0.007428 | 0.999999956 |
| per-tensor absmax INT4 QDQ基线 | 0.340942 | 4.49803 | 0.941938 |
| 独立NVFP4语义 | 0.147782 | 2.17423 | 0.989072 |
| 激活×4、冻结校准global scale | 0.370674 | 34.84045 | 0.946618 |

不同格式基线比较的是同一矩阵重建误差，不能隔离“块scale”的单因素因果，也不是任务精度。尾块补到80：权重payload680B、scale85B、含global/shape的header20B，实际文件785B；FP16未padding权重本体2210B。文件节省不等价运行时峰值，解码后FP32还要分配。缩放后超出最大E2M1的计数W40/X19/shift189；这是逐元素范围越界计数，scale舍入也可能造成轻微越界。

[原始输出](results/independent.txt)记录CPU Python整批P50：FP基线0.233750ms，在线解码+matmul0.682084ms，后者更慢。均预热3次、11样本，不是GPU/NPU或服务E2E。原生结果、原生存储大小、Thor延迟均未验证。零值/1/15/16/17/31/32/33尾部、4类非法shape/非有限值、ties-even与文件重载实际通过。

## Thor SM110 与优化

[decode.cu](decode.cu)提供独立SIMT解码 `decode_baseline`（每线程一值）与最终 `decode_pairs`候选（每线程一字节两值、共享scale），输入为本课E2M1/E4M3编码。输出FP32，处理奇数n与零n。减少重复的逻辑取数/scale计算；事务减少量和收益待测，线程数减少也可能使短输入更慢。没有声称Tensor Core GEMM，没有仿冒CUDA/PTX/SASS产物。

[GPU.md](GPU.md)提供完整SM110构建、ncu过滤/采样/源码关联、潜在热点和Thor对照Ada。`bfe.u32`是实际inline PTX源码；无nvcc/ncu，不存在已生成PTX/SASS或GPU正确性结果。原生API后端兼容函数仅判断能力>=10，不能证明其TensorRT-LLM扩展或机器码可在SM110运行；本例关闭这些快路径。任何需要专属后缀的FP4矩阵指令都未启用。

## 验证与待补

[verification.json](verification.json)五项：源码本地获取否、实现阅读是、原生示例交付是、CPU原生运行否、Thor否。独立CPU实验另记是，不能替换原生状态；原生尝试缺torch，[日志](results/native.txt)；GPU构建缺nvcc，[日志](results/thor-build.txt)。只重试一个旧项AWQ，仍DNS失败，见[记录](results/awq-retry.json)。本日游标只推进一次至下一轮AWQ，失败保持backlog，不因绕完目录就标全部方法完成。

故障链一：K=65原生quantize补到80、dequantize末尾按旧shape reshape→维度不合→检查padding路径→本版本原生示例限定K%16=0；独立容器显式保存padded_k，回归65尾块。

故障链二：校准scale遇到更大激活→range超出、NRMSE上升→分开看block/global scale与范围计数→重新校准只能用新校准集，评估集不能回流搜参；记录旧/新结果，不保证一定优于基线。

故障链三：只存uint8→重载值不对→核对低高nibble、两层scale、shape→版本化容器并逐位重载验证；加元数据带来固定开销，小矩阵未必划算。

迁移验收：固定源码/依赖；非有限输入与尾部合同；保存scale字节/shape；原生重载一致；held-out输出误差；分别报告离线量化/在线解码/GEMM/传输/E2E；在Thor实测前不替换生产后端。追问：NVFP4为什么不是INT4？E4M3 scale与global scale各做什么？padding为何影响真实压缩率？QDQ能证明Tensor Core吞吐吗？两值线程为何可能更慢？量化后还需哪些模型行为检查？
