# 2026-09-23 · HQQ：不使用激活校准的权重近端优化

## 方法与应用场景

为已有`Linear(64,16,bias=False)`替换权重表示。HQQ是量化算法；本课使用均匀INT4码、每16权重一组、axis=1，是PTQ而非QAT。默认原生CPU路径为W4A32：真实u4存储→FP32反量化→PyTorch matmul。额外FP16输入/权重舍入参考用于观察W4A16数值，不代表原生低位Tensor Core执行。HQQ不使用激活校准；normal/outlier/zero三种权重、heldout/shifted/zero_input三种输入均为随机小张量，不下载模型。

优化固定组scale，交替计算量化重建、残差收缩和zero更新。该版本默认legacy求解器的`p=0.7, beta=10, kappa=1.01, iters=20`，按平均绝对误差停止；并非autograd训练，也不是调用较慢的v2回滚实现。初始化`round_zero=True`不保证优化后的zero仍为整数。源码内部先用逆scale编码，保存时取倒数，重建是`(q-zero)*scale`。不要将HQQ名称、INT4格式与W4A16执行后端混为一谈。

## 原仓库与实际读过的实现

原地址[Mobius Labs HQQ](https://github.com/mobiusml/hqq)实际重定向到[Dropbox HQQ](https://github.com/dropbox/hqq)。固定commit **d88a488ec8aa2d58362ef2038a52bca862db2e74**，读取2026-09-23；`setup.py`版本0.2.8.post1，Apache-2.0（Dr. Hicham Badri/Mobius Labs署名）。

| 文件永久链接 | 实际阅读符号/作用 |
| --- | --- |
| [quantize.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/quantize.py) | `BaseQuantizeConfig`、`HQQLinear.initialize/quantize/dequantize/forward_pytorch/state_dict/load_state_dict`、`Quantizer.quantize/dequantize` |
| [optimize.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/optimize.py) | `optimize_weights_proximal`实际别名为legacy；`legacy_step`、`shrink_lp_op` |
| [bitpack.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/bitpack.py) | `BitPack.pack_4bit_u8/unpack_4bit_u8`，首维前半组进高nibble、后半组进低nibble，不是相邻元素配对 |
| [utils.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/utils.py) | `is_divisible`、状态的`encode_safetensor_type/decode_safetensor_type` |
| [Readme.md](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/Readme.md)、[setup.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/setup.py)、[LICENSE](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/LICENSE) | 用户入口、依赖/安装hook、许可证 |

调用链：Linear权重→HQQLinear→Quantizer分组/minmax→legacy近端优化→BitPack→W_q/meta→dequantize→浮点matmul。`state_dict`编码元数据，恢复时重建量化层。示例**原样调用这些上游API**；数据、absmax对照、误差/耗时统计是本课独立Python/PyTorch代码。不是上游全模型复现，也不包含其GemLite/ATEN/CUDA内核。

本地原地址与迁移地址浅克隆均DNS失败，忽略缓存中无可验证源码；网页阅读成功不能记成可执行检出成功。[source.json](source.json)记录阅读，[首次拉取](source-fetch.json)与[迁移后拉取](source-migrated-fetch.json)保留原始失败。

## 如何接入我的代码

[upstream_api.py](upstream_api.py)和[run.sh](run.sh)已完整交付。工作目录为仓库根目录。先由用户在具备依赖的环境准备固定检出（以下未在本机成功执行）：

```sh
# 源码限定在忽略缓存；只检出HQQ核心与包入口，无模型。
git clone --depth=1 --filter=blob:none --no-checkout https://github.com/dropbox/hqq.git systems_practice/.tmp/quant_sources/hqq-pinned
git -C systems_practice/.tmp/quant_sources/hqq-pinned fetch --depth=1 origin d88a488ec8aa2d58362ef2038a52bca862db2e74
git -C systems_practice/.tmp/quant_sources/hqq-pinned sparse-checkout set hqq
# sparse-checkout保留顶层文件，随后固定HEAD。
git -C systems_practice/.tmp/quant_sources/hqq-pinned checkout --detach d88a488ec8aa2d58362ef2038a52bca862db2e74
HQQ_SOURCE="$PWD/systems_practice/.tmp/quant_sources/hqq-pinned" PYTHON=python3 ./systems_practice/quantization/2026-09-23/hqq/run.sh
```

上游说明要求PyTorch2，setup声明numpy>=1.24.4、tqdm>=4.64.1、einops、accelerate、transformers>=4.36.1、huggingface_hub、termcolor。本例仅直接使用核心模块；建议准备Python>=3.10、PyTorch2.6或更新兼容版本、numpy与termcolor（该组合未运行验证，不能称锁定可复现环境）。运行会记录真实版本。源码安装hook可能自动编译CUDA；若用户另行安装CPU包应显式`DISABLE_CUDA=1`，本例直接从固定检出导入，不执行安装。本机Python3.9.6，torch/numpy/termcolor均不存在。

接入已有代码的位置是`model.block.linear`或`Sequential`中的Linear：先保留FP32参考，再传`copy.deepcopy(linear)`给HQQLinear，赋回目标模块。本例实际构建Sequential(recovered)并核对输出。`del_orig=True`会清除传入层的参数，不能对仍需保留的参考层直接调用。`HQQLinear.to()/cpu()`在本版本是占位实现；设备在构造/恢复时指定为cpu，不依赖这些调用搬运。

参数固定`nbits=4/group_size=16/axis=1`；FP32权重[16,64]被分成64组，首维可两半打包。没有训练集或激活校准集需求，没有用评估样本调超参。输入[8,64]使用独立随机种子；更改分组会改变数学语义与存储，必须另行比较。导出原生`state_dict`至忽略的`build/<timestamp>/*.pt`，加载自己刚生成的文件并要求输出精确一致；文本指标和50个计时样本写入`results/run-<timestamp>/comparison.json`，不覆盖历史结果。

## 量化前后比较

| 项目 | 本机状态 | 示例具备的检查 |
| --- | --- | --- |
| FP32、FP16、absmax、原生RTN、HQQ误差 | 未运行 | 同权重/输入的NRMSE、max_abs、cosine；零参考时cosine=null |
| INT4真实存储与scale/zero | 未运行 | W_q dtype必须uint8、实际元素数必须512；逐项计数state tensor和磁盘checkpoint |
| 导出重载/模型替换 | 未运行 | 重载与原量化层精确相等；与解量化F.linear容差核对 |
| CPU框架性能 | 未运行 | 单线程10预热+50样本；分别量化阶段、matmul/解码调用 |
| Thor设备性能 | 未验证 | 未启用GPU后端，不填性能数值 |

1024个权重的理论纯u4载荷为512B，FP16载荷2048B；这是布局推算，完整压缩率必须包含真实scale/zero与序列化开销，尚未实测。absmax是QDQ数值基线，不伪装成另一原生压缩导出。上游RTN和HQQ均是真实打包。

FP32、原生RTN/HQQ的计时包括各自同步CPU调用；HQQ含反量化分配和matmul。FP16列同时记录含cast与预转换两种边界；严禁将含cast时间与纯matmul混比。endpoint比例是码值位于0或15的比例，不等于被裁剪率。非法[15,63]权重不整除group16，示例要求上游拒绝；全零、离群权重与shift输入保留退化结果，不保证HQQ每次胜过RTN。

## Thor SM110 与优化

本期深入的是权重量化算法与原生CPU用法，没有自写CUDA kernel或GPU性能候选，不将CPU解码路径称为Thor优化。上游PYTORCH_FORWARD反量化后做浮点matmul；是否被框架选成Tensor Core无法从HQQ配置推断。ATEN路径另有axis=0/GPU限制，本课axis=1配置不能直接切换。

今日核实[NVIDIA JetPack下载/版本表](https://developer.nvidia.com/embedded/jetpack/downloads)：JetPack7.2.1、Jetson Linux39.2.1、CUDA13.2.1列出AGX Thor/T5000支持。它只证明官方软件组合，不证明该HQQ commit、PyTorch wheel、GemLite或ncu在本机/目标板兼容。此处缺nvcc/ncu/Thor，驱动实机版本、PyTorch的SM110支持和ncu版本仍待验。

```sh
# Thor板上先记录环境；只检查目标能力，不触发构建或安装。
cat /etc/nv_tegra_release
nvcc --version
nvcc --list-gpu-code
ncu --version
# 若未来经过核验后另行构建PyTorch扩展，目标必须为11.0（sm_110）。
export TORCH_CUDA_ARCH_LIST=11.0
```

不擅用`sm_110a`，不引用其他GPU的成绩；无真实PTX/SASS产物。CUDA kernel性能专题按主轮换另交付完整baseline/优化/ncu流程，本期没有把fake-quant或CPU时间冒充低位GPU收益。

## 验证与待补

[verification.json](verification.json)分别记录：本地源码获取否、实现阅读是、示例交付是、CPU原生运行否、Thor验证否。[实际运行尝试](results/native-attempt.txt)在前置检查退出2；缺依赖和固定检出，未生成数值结果。语法检查不等于API运行通过。本期进入backlog，次日方法OmniQuant；最多一个历史重试为AWQ，原始失败见[AWQ重试](../awq-retry-source.json)。未安装依赖、未下载模型。
