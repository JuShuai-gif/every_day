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

[upstream_api.py](upstream_api.py) 提供原生量化优化 API 用法。替换 `layer` 为你已有的 Linear，保持 W 行为输出通道、列为输入通道；数据替换为该层**真实输入激活**，不要将评估集用来挑 lr。两候选学习率 .005/.02 各100步，只在 calibration 更新；validation 选一个，evaluation 和 shifted 仅报告。每次记录更新前 loss，最后确认参数确实改变。冻结后把原函数返回的 qdq/scale/zp、原始权重、上游RTN和评估输入交给 C++ 后端。位打包、文件写入/重载、解码与 CPU 数值/基准验证均由 C++ 完成，文件为 `build/linear.q4`。自定义Q4C1不兼容原生AutoRound加载器；实际部署必须另行适配。

## 量化前后比较

2026-09-22 将部署侧的位操作、打包/解码、误差验证、FP16存储舍入、absmax基线和 CPU 计时迁入 [C++17 后端](../../cpp/README.md)。上游 API 的校准/优化和候选选择保留在 `upstream_api.py`，使用固定 commit；它只通过文本传递张量，不能充当 CPU 内核示例。

`sh run.sh check`（本课目录）只验证独立 C++ 后端；`sh run.sh native` 才运行原生方法与完整张量交接。后端写并重载 `build/linear.q4`（AdaRound 为 `build/native/linear.q4`）。Q4C1 包含16字节头、每组8字节FP32 scale/zero和低 nibble 优先 u4；与旧 Python 容器及上游模型文件不兼容，不能直接喂给原生加载器。格式、误差阈值、分组尾部与板端边界见后端说明。

以 FP32 输入/权重为参考，对照 FP16存储、独立 absmax、上游 RTN、原生量化解码；对照输入先舍入为 FP16，再以 C++ FP32 标量累加。对 evaluation、shifted、全零输入记录 NRMSE/max_abs/cosine（零向量为 null）。CPU基准10次预热、50次采样，覆盖已解码 GEMM 与输出分配，排除磁盘、解码和训练，不代表 BLAS、低位kernel或GPU性能。仅记录上游校准/优化的流程用时，不把 Python 算子计时作为体系结构实验。

**本机已通过**共用后端的 Release、ASan/UBSan、位模式/边界检查，以及本课形状的合成数据磁盘往返。**四种原生量化算法仍未运行**：缺对应源码/依赖（GPTQ还需Thor），没有真实量化模型精度或板端性能。合成检查不推进原生完成状态。当前证据见 [verification.json](verification.json)、[新原生入口尝试](results/native-cpp-attempt.txt)；原有 results 原样保留为历史记录。

## Thor SM110 与优化

本例只调用 CPU 张量 API，不新建 CUDA kernel 或运行任何第三方 GPU 扩展。Thor 上原生低位后端兼容性**未验证**。不可将本例真实打包+解码浮点计算报告为 Tensor Core 性能。

2026-09-22 实读 [NVIDIA 下载说明](https://developer.nvidia.com/embedded/jetpack/downloads)：列出 Thor/T5000/T4000，JetPack7.2.1、L4T39.2.1、CUDA13.2.1、Ubuntu24.04；[归档](https://developer.nvidia.com/embedded/jetpack-archive)亦保留 JetPack7.0/L4T38.2/38.2.1 的 Thor 支持。这是官方栈信息，不是 AutoRound 全后端支持承诺；ncu版本、驱动现场状态及 PyTorch wheel/extension ABI 仍需板端核对。今日无设备、nvcc/ncu，也无实际 PTX/SASS。

以后任何扩展构建固定 `TORCH_CUDA_ARCH_LIST=11.0`、`CMAKE_CUDA_ARCHITECTURES=110`、nvcc `-arch=sm_110`，不得使用 `sm_110a`。已有 [SM110量化GEMM候选与ncu/ISA流程](../../../daily/2026-09-18/session-02/README.md) 是独立后续适配参考；其格式不等于本例 u4，必须转换尺度/零点/布局后重新验证，不能宣称可以直接部署。

## 验证与待补

[获取记录](source.json)保留真实浅克隆失败；无可验证缓存。实现阅读和原生示例交付已完成，CPU运行与Thor均未完成，五项状态见 [verification.json](verification.json)。已将本日失败加入 backlog；AWQ 今日只重试一次，仍为 DNS 失败。独立游标下一方法 HQQ，同日不再推进。
