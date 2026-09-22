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

[example.py](example.py) 提供完整低层原生 API 用法。替换 `layer` 为你已有的 Linear，保持 W 行为输出通道、列为输入通道；数据替换为该层**真实输入激活**，不要将评估集用来挑 lr。两候选学习率 .005/.02 各100步，只在 calibration 更新；validation 选一个，evaluation 和 shifted 仅报告。每次记录更新前 loss，最后确认参数确实改变。冻结后从原函数 qdq/scale/zp 得到 codes，写 `build/linear.u4`，从磁盘重新解码并验证。把恢复的权重送入现有 `F.linear` 是 CPU 重建接入点；实际压缩运行时必须另写匹配格式的 Linear，而不是把自定义 u4 文件传给 auto_round/GPTQ 加载器。

自定义容器：16 B magic/shape/group header；每组4 B FP32 scale、1 B zp；逻辑权重每两个 code 一字节，低 nibble 在前。尾组仍存 scale，但不保存无效权重。当前 `[8,33]` 的长度应为 268 B（132权重+96 scale+24 zp+16 header），这是**格式计算**，不是本机已导出测量。run 成功会记录实际 file_bytes 并校验。`build/` 被忽略。

## 量化前后比较

| 项目 | 本次实际状态 |
| --- | --- |
| FP32 / FP16参考 / absmax / 原生RTN / 原生AutoRound 输出误差、余弦 | 未运行；代码已提供同输入对照 |
| calibration损失、真实参数改变数量、lr选择 | 未运行；不会用数学伪输出代替 |
| UINT4 payload/scale/zp/header 与文件长度 | 编码/解码代码已交付；实际输出待运行 |
| 端点占用率 | 代码计算；与真正 pre-clamp 饱和率不同，后者未插桩 |
| CPU已解码F.linear P50/P95 | 未测；计划10预热+30采样，排除调参/磁盘 |
| GPU/NPU/端到端推理与功耗 | 未验证 |

已包括零权重行、K=33跨尾组、输入离群通道、独立分布变化评估；不保证优化总是优于 RTN。实际失败输出见 [native-attempt.txt](results/native-attempt.txt)，退出2。没有额外强制编码题。

## Thor SM110 与优化

本例只调用 CPU 张量 API，不新建 CUDA kernel 或运行任何第三方 GPU 扩展。Thor 上原生低位后端兼容性**未验证**。不可将本例真实打包+解码浮点计算报告为 Tensor Core 性能。

2026-09-22 实读 [NVIDIA 下载说明](https://developer.nvidia.com/embedded/jetpack/downloads)：列出 Thor/T5000/T4000，JetPack7.2.1、L4T39.2.1、CUDA13.2.1、Ubuntu24.04；[归档](https://developer.nvidia.com/embedded/jetpack-archive)亦保留 JetPack7.0/L4T38.2/38.2.1 的 Thor 支持。这是官方栈信息，不是 AutoRound 全后端支持承诺；ncu版本、驱动现场状态及 PyTorch wheel/extension ABI 仍需板端核对。今日无设备、nvcc/ncu，也无实际 PTX/SASS。

以后任何扩展构建固定 `TORCH_CUDA_ARCH_LIST=11.0`、`CMAKE_CUDA_ARCHITECTURES=110`、nvcc `-arch=sm_110`，不得使用 `sm_110a`。已有 [SM110量化GEMM候选与ncu/ISA流程](../../../daily/2026-09-18/session-02/README.md) 是独立后续适配参考；其格式不等于本例 u4，必须转换尺度/零点/布局后重新验证，不能宣称可以直接部署。

## 验证与待补

[获取记录](source.json)保留真实浅克隆失败；无可验证缓存。实现阅读和原生示例交付已完成，CPU运行与Thor均未完成，五项状态见 [verification.json](verification.json)。已将本日失败加入 backlog；AWQ 今日只重试一次，仍为 DNS 失败。独立游标下一方法 HQQ，同日不再推进。
