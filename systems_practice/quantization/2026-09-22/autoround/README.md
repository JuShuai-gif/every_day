# 2026-09-22 AutoRound：原生舍入偏置与范围优化

## 方法与应用场景

对已有 `nn.Linear(33,8,bias=False)` 做小规模输出重建：校准输入 `[128,33]`，独立调参 `[64,33]`、评估 `[64,33]`、分布变化评估 `[64,33]`。不下载模型。本期深入 AutoRound 的 **sign-gradient 舍入与 min/max 范围优化**，采用原项目低层 `quant_tensor_asym` 和 `SignSGD`；驱动、数据、选择策略和磁盘容器为独立教学代码，不是完整 AutoRound LLM 压缩器的复现。

算法与位宽分开：AutoRound 是优化算法；本例格式是 affine UINT4 codes、每16个输入通道一组，FP32 scale 与 uint8 zero-point；推理比较把激活先舍入为 FP16，再转 FP32 累加。它演示 W4A16 的数值边界，但实际计算是 CPU FP32 解码 GEMM，绝非原生 INT4 Tensor Core。校准中冻结原始 W，以 `v`、范围系数 `lo/hi` 为可训练参数。100步实际更新代码已提供，但本机未执行成功；这是优化式 PTQ，不是全模型任务 QAT。

原函数先得到包含0的组内 min/max，再乘 `[0,1]` 的范围系数，生成 `scale=(max-min)/15`、`zp=round(-min/scale)`；输出为 `scale*(clamp(round(W/scale+v)+zp,0,15)-zp)`。round 的前向是离散舍入，反向由上游 STE 传递梯度。SignSGD 用梯度符号更新，舍弃幅度并非舍弃真实梯度；范围也需要投影。零行由最小 scale 避免除零。与昨日 AdaRound 的软硬舍入参数化不同，不能混用它的编码文件。

## 原仓库与实际读过的实现

[仓库 intel/auto-round](https://github.com/intel/auto-round)，读取日期 **2026-09-22**；tag **v0.9.0** 通过 GitHub 源码页永久链接核实为 **8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1**，没有观察到仓库迁移。之所以固定此版本，是 main 已重构成不同编排入口，不混用两版 API。

| 文件永久链接 | 实际阅读内容 |
| --- | --- |
| [autoround.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/auto_round/autoround.py) | `AutoRound.__new__` 入口参数与 compressor 路由；本例不调用自动 LLM 编排 |
| [wrapper.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/auto_round/wrapper.py) | `WrapperLinear` 初始化、`_qdq_weight`、`forward`、`unwrapper`；原库怎样连接量化和 Linear |
| [data_type/int.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/auto_round/data_type/int.py) | `quant_tensor_asym`、`quant_tensor_sym`；注意后者允许负 scale，本例避免混用 |
| [data_type/utils.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/auto_round/data_type/utils.py) | `round_ste`、分组补零/去尾、`get_quant_func` |
| [sign_sgd.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/auto_round/sign_sgd.py) | `SignSGD.step → sgd → _single_tensor_sgd`，末端确实原位更新参数 |
| [setup.py](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/setup.py)、[requirements-lib.txt](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/requirements-lib.txt)、[LICENSE](https://github.com/intel/auto-round/blob/8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1/LICENSE) | Python>=3.10，accelerate>=1.10.0，其余多为未锁版本；Apache-2.0，SignSGD 内另含 PyTorch 来源声明 |

原项目面向 LLM/VLM 分块量化。原链路是 AutoRound 入口→compressor→WrapperLinear→dtype量化→浮点 Linear→优化→unwrap/后端导出。本例从**已核实的原生量化函数**切入，将用户 Linear 权重传入，原生 SignSGD 更新参数，再冻结并编码。没有声称调用了未读完整实现的 compressor/export backend。详细范围见 [source-web.json](source-web.json)。

## 如何接入我的代码

工作目录：项目根目录。已有 Python>=3.10、兼容 torch、AutoRound v0.9.0 及其导入依赖时：

```bash
# 网络恢复后由用户准备源码，不自动安装；只下载源码，不下载模型。
GIT_LFS_SKIP_SMUDGE=1 git clone --depth=1 --branch v0.9.0 \
  https://github.com/intel/auto-round.git systems_practice/.tmp/quant_sources/autoround-v090
# 应输出 8d8a1cd5daaf6e8c71d079eccaec3092fa9af4f1；不符就停止。
git -C systems_practice/.tmp/quant_sources/autoround-v090 rev-parse HEAD
AUTOROUND_SOURCE="$PWD/systems_practice/.tmp/quant_sources/autoround-v090" \
  sh systems_practice/quantization/2026-09-22/autoround/run.sh
```

`PYTHON=/已有环境/bin/python` 可选择现有解释器。安装不是 run.sh 的一部分；准备依赖时按固定源码 `setup.py` 与 requirements 选择现有 CPU 兼容栈。本机实查 Python3.9.6、torch/auto_round/transformers/numpy 均缺；没有可验证的完整依赖锁、没有已验证的 arm64 安装组合。示例在 preflight 同时报告这些缺项，并逐字比对安装核心文件与固定 git commit，避免包版本字符串相同而源代码不同。

[upstream_api.py](upstream_api.py) 提供原生量化优化 API 用法。替换 `layer` 为你已有的 Linear，保持 W 行为输出通道、列为输入通道；数据替换为该层**真实输入激活**，不要将评估集用来挑 lr。两候选学习率 .005/.02 各100步，只在 calibration 更新；validation 选一个，evaluation 和 shifted 仅报告。每次记录更新前 loss，最后确认参数确实改变。冻结后用原函数返回的qdq与原生RTN做PyTorch误差对比、模型重载和框架计时。scale/zp随重建检查点保存；仅native-cpp额外研究Q4C1位布局与CPU参考。实际部署的原生压缩后端需另行验收。

## 量化前后比较

**主流程使用 Python/PyTorch。** `upstream_api.py` 调用原生算法并使用 [torch_evaluation.py](../../torch_evaluation.py) 完成张量误差对比、重建模型接入、torch检查点保存/重载和框架级计时。校准/训练、validation选型、evaluation分区不变；不因为在CPU上运行就迁移成C++。

从本课目录运行（已有对应上游依赖和固定源码时）：

```sh
sh run.sh native      # 默认路径；不构建教学C++后端
sh run.sh native-cpp  # 上述流程 + 可选C++物理布局/CPU内核实验
sh run.sh check       # 只检查独立C++后端，不运行原生算法
```

torch使用FP32原始输入/权重作参考；对比FP16存储、独立absmax、上游RTN和原生量化重建，覆盖evaluation、shifted和全零输入。对照输入先舍入FP16再转FP32算子，累加细节由torch后端决定；报告NRMSE/max_abs/cosine，零向量余弦记null。保存的 `build/torch-reconstructed.pt` 是FP32重建权重与元数据，不能当作INT4压缩文件；报告为 `build/torch-result.json`（AdaRound均在`build/native/`）。这是小Linear实验，不是完整模型任务精度。

框架计时10次预热、50次采样，记录同步主机wall time，包含F.linear调度/分配；CUDA设备在计时边界同步。排除校准、文件IO和重载，不能称单个kernel时间，也不能证明packed低位内核提速。Python可调用原生后端测框架性能；专门研究指令、缓存或内核时另用C++/CUDA实现。

显式选择 `native-cpp` 才将张量交给 [C++补充实验](../../cpp/README.md)，写出/重载Q4C1，检查字节、码值和标量CPU参考。Q4C1不是上游模型格式。此前C++ Release/ASan/UBSan与合成数据检查已通过；**新torch评估与四种原生算法仍未运行**，缺对应源码/依赖（GPTQ还需Thor）。入口尝试见 [最新日志](results/native-torch-attempt.txt)，状态见 [verification.json](verification.json)。不安装依赖、不下载模型。

## Thor SM110 与优化

本例只调用 CPU 张量 API，不新建 CUDA kernel 或运行任何第三方 GPU 扩展。Thor 上原生低位后端兼容性**未验证**。不可将本例真实打包+解码浮点计算报告为 Tensor Core 性能。

2026-09-22 实读 [NVIDIA 下载说明](https://developer.nvidia.com/embedded/jetpack/downloads)：列出 Thor/T5000/T4000，JetPack7.2.1、L4T39.2.1、CUDA13.2.1、Ubuntu24.04；[归档](https://developer.nvidia.com/embedded/jetpack-archive)亦保留 JetPack7.0/L4T38.2/38.2.1 的 Thor 支持。这是官方栈信息，不是 AutoRound 全后端支持承诺；ncu版本、驱动现场状态及 PyTorch wheel/extension ABI 仍需板端核对。今日无设备、nvcc/ncu，也无实际 PTX/SASS。

以后任何扩展构建固定 `TORCH_CUDA_ARCH_LIST=11.0`、`CMAKE_CUDA_ARCHITECTURES=110`、nvcc `-arch=sm_110`，不得使用 `sm_110a`。已有 [SM110量化GEMM候选与ncu/ISA流程](../../../daily/2026-09-18/session-02/README.md) 是独立后续适配参考；其格式不等于本例 u4，必须转换尺度/零点/布局后重新验证，不能宣称可以直接部署。

## 验证与待补

[获取记录](source.json)保留真实浅克隆失败；无可验证缓存。实现阅读和原生示例交付已完成，CPU运行与Thor均未完成，五项状态见 [verification.json](verification.json)。已将本日失败加入 backlog；AWQ 今日只重试一次，仍为 DNS 失败。独立游标下一方法 HQQ，同日不再推进。
