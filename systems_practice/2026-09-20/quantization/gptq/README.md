# 2026-09-20 GPTQ：用校准二阶信息补偿逐列舍入误差

## 方法与应用场景

本期只深入GPTQ。它是权重PTQ算法，不是INT4格式，也不是QAT训练范式。应用于已有视觉/语言Linear：希望同样4-bit存储下，更好保持校准分布的输出。与只对权重做absmax相比，它利用输入通道相关性处理舍入误差；代价是校准、K×K矩阵与分解成本。没有梯度训练、没有LoRA更新，不保证评估误差一定改善。

最小例子：权重 `[N=32,K=128]`，激活 `[M=128,K=128]`，输出 `[128,32]`，`Y=X W^T`。原生GPTQ在FP32权重上处理，Hessian近似为FP32；推理将激活和重建权重转FP16，实际累加由匹配Thor的PyTorch GEMM后端决定。逻辑位宽W4A16，格式为0..15 affine整数码，per-output-channel scale/zero，group=-1代表整行K=128共用参数。`torch.round`后饱和，反量化为`(q-zero)*scale`；没有量化激活，不能称W4A4。

## 原仓库与实际读过的实现

[IST-DASLab/gptq](https://github.com/IST-DASLab/gptq)，固定commit `2d65066eeb06a5c9ff5184d8cebdf33662c67faf`，读取日期2026-09-20，许可证[Apache-2.0](https://github.com/IST-DASLab/gptq/blob/2d65066eeb06a5c9ff5184d8cebdf33662c67faf/LICENSE)。[source.json](source.json)保留真实浅克隆失败；[source-web.json](source-web.json)单独记录网页读源码事实，不篡改失败记录。原仓库没有迁移证据，目录清单中 `LICENSE.txt` 候选已核正为实际 `LICENSE`。无可验证本地缓存，未声称本地获取成功。

实际阅读与调用链：

- [opt.py / opt_sequential](https://github.com/IST-DASLab/gptq/blob/2d65066eeb06a5c9ff5184d8cebdf33662c67faf/opt.py#L69)：原项目逐Transformer块，用forward hook把Linear的输入送给 `GPTQ.add_batch`，移除hook后执行量化，再用量化层生成下一块输入。
- [gptq.py / GPTQ.add_batch、fasterquant、free](https://github.com/IST-DASLab/gptq/blob/2d65066eeb06a5c9ff5184d8cebdf33662c67faf/gptq.py#L16)：统计输入二阶信息，阻尼和分解后逐列舍入，将误差补偿到尚未处理的列；最终覆盖 `layer.weight`。死通道在校准中没有贡献，源码把相应权重置零，分布变化时可能失效。
- [quant.py / Quantizer.configure、find_params、quantize](https://github.com/IST-DASLab/gptq/blob/2d65066eeb06a5c9ff5184d8cebdf33662c67faf/quant.py#L11)：形成量化网格、返回浮点重建值。`Quant3Linear.pack/forward`是另一条3-bit单token扩展路径，不能当成本例4-bit矩阵API。

本例的GPTQ算法是**原样调用上游API**；小输入、数据分区、评估、序列化和INT4容器是**自写教学封装**。没有把独立数学算法伪装成上游实现，也没有复制完整第三方源码。原项目支持大模型逐层量化；这里只验证一个无bias Linear，省略真实任务精度和跨层误差传播。

H的统计对应输入二阶矩，目标近似最小化 `||(W-Q)X^T||²`。本期二维输入在上游被扩成一个batch，`nsamples`计批次而非逐token计数，因此H与 `X^T X` 成比例；配套相对阻尼使用平均对角线，不能单独把H的数值尺度当成样本数解释。

把阻尼后的H求逆再做上三角Cholesky，记结果U。逐列选量化值q后，误差经 `e=(w-q)/Uii` 归一化，并按U当前行更新后续列；算法处理块结束再批量补偿未处理大块。这样利用输入相关性分配误差，而非简单地让每个权重独立最近舍入。阻尼避免奇异/病态分解；它越大并不保证精度越好。本课只改变阻尼一个参数并用validation选择，保留独立evaluation上的无收益结果。

## 如何接入我的代码

工作目录为EveryDay根目录。当前本机Python3.9.6；torch、transformers、numpy均未安装。原README曾测试torch1.10.1+cu111、transformers4.21.2、datasets1.17.0；那是上游历史环境，不能在Thor上照搬CUDA11。[固定README](https://github.com/IST-DASLab/gptq/blob/2d65066eeb06a5c9ff5184d8cebdf33662c67faf/README.md#L32)。

本例候选运行环境：Thor配套JetPack/驱动、CUDA13.0，支持 `sm_110` 的PyTorch2.9.0 CUDA13构建、Python3.11、transformers4.56.2、numpy1.26.4。PyTorch官方列有2.9.0 CUDA13版本，但**这个Python/包/板端组合没有实际安装验证**，尤其aarch64 wheel与JetPack依赖需板端核验。[官方历史版本页](https://pytorch.org/get-started/previous-versions/)。脚本检查CUDA可用、CC11.0与PyTorch `sm_110`架构列表，输出实际包版本；缺一项即明确失败，不自动回退其他GPU/CPU。无需datasets、模型或外部数据，也无需3-bit扩展。

先在有网络的环境准备固定源码（不安装依赖；命令尚未在本机成功）：

```bash
# 默认缓存路径用于本次课程；已存在则检查并复用，勿覆盖。
mkdir -p systems_practice/.tmp/quant_sources
# 一次浅克隆小仓库，不递归submodule、不拉模型。
GIT_LFS_SKIP_SMUDGE=1 git clone --depth=1 --filter=blob:none --no-checkout \
  https://github.com/IST-DASLab/gptq.git \
  systems_practice/.tmp/quant_sources/gptq-20260920
# 固定已阅读commit；如果HEAD已更新，按commit浅fetch。
git -C systems_practice/.tmp/quant_sources/gptq-20260920 fetch --depth=1 origin \
  2d65066eeb06a5c9ff5184d8cebdf33662c67faf
git -C systems_practice/.tmp/quant_sources/gptq-20260920 checkout --detach \
  2d65066eeb06a5c9ff5184d8cebdf33662c67faf
GPTQ_SOURCE="$PWD/systems_practice/.tmp/quant_sources/gptq-20260920" \
  sh systems_practice/2026-09-20/quantization/gptq/run.sh
```

也可用公共 `fetch_source.py gptq --record ...` 重新记录获取证据；它使用no-checkout，只生成Git对象和选定快照，运行前必须在其manifest给出的repo内检出固定commit。脚本会拒绝错误commit、已跟踪文件修改或缓存外路径。

[example.py](example.py)的完整流程已写好：

1. seed30生成FP32 W，首输出行置零；seed31生成256条校准输入，通道1与0相关，通道7恒零。seed32的128条validation只用于在0.01/0.1两个阻尼值间选型；seed33的128条evaluation只做最终报告。无训练集/训练更新，评估不参与选择。
2. `engine=GPTQ(layer)`、`Quantizer.configure(4,perchannel=True,sym=False,mse=False)`、`add_batch`、`fasterquant(blocksize=32,percdamp=...,groupsize=-1,actorder=False,static_groups=False)`。32是算法处理块大小，不是量化group size。关闭act-order避免本期引入额外排列/分组主题。
3. 固定网格下选择最佳validation结果；输出真实权重重建。自定义pack每字节放两个u4码，低nibble为前一元素，保存FP32 scale/zero。立即反解校验；导出到被忽略的 `build/gptq_int4.pt`，再加载、解码、转FP16。
4. 创建FP16 `nn.Linear(128,32,bias=False)`，copy解码后的权重，调用并检查与直接 `F.linear`相同。接入已有Linear时，替换示例的random W为 `existing.weight.detach().float().clone()`，用真实校准激活喂add_batch；有bias需原样保留，本例无bias。大模型逐层hook入口见opt_sequential；不能用一层合成通过代表整模型部署成功。
5. JSON在 `results/measured.json`，包含误差、真实payload/metadata与文件大小、阶段时间和分布偏移结果。二进制不提交。静态示例仅针对 `[32,128]`偶数元素，解码shape固定；改变层大小时必须同步改pack/decode合同，不能直接接任意模型。

## 量化前后比较

同一evaluation分别比较FP32参考、FP16参考、absmax signed4、同一affine网格RTN和GPTQ重建FP16。记录NRMSE、max-abs、cosine。RTN有助于隔离GPTQ补偿机制；absmax和affine网格不同，不能把所有差异归因于二阶补偿。额外将校准死通道7设为8，观察分布偏移失效；不重新选择参数以掩盖退化。

| 指标 | 本次实际状态 |
| --- | --- |
| 四组误差、分布偏移、endpoint fraction | 未运行；不是零误差 |
| GPTQ校准、搜索、pack时间 | 未运行 |
| packed/scale/zero字节与序列化文件大小 | 未实测；脚本运行时按实际tensor计数 |
| FP16 dense GEMM GPU区间P50/P95 | 未验证 |
| CPU解包→H2D→FP16重建→GEMM→同步P50/P95 | 未验证；不含文件读取/离线校准 |
| 原生packed INT4 Tensor Core性能 | 本例不提供该路径，不能声称提速 |

仅存储**公式**：4096权重×4/8=2048B码，32个FP32 scale和32个FP32 zero合计256B，tensor payload总计2304B；FP16稠密权重8192B。此为格式预算，不是实际文件大小、进程内存或加速比。解码运行会重新分配FP16权重，保存压缩不代表推理显存同比压缩。`endpoint_fraction`表示码落在0/15端点的比例，不等同于实际被裁剪比例；另报重建权重是否超网格，不能倒推GPTQ每一步的内部裁剪计数。

计时先20预热再100采样；event只记录torch GPU算子区间，Python调度可能影响间隙，不能称单个INT4 kernel耗时。E2E另用同步主机时钟。GPU、CPU、离线校准和NPU边界分开；本例无NPU路径。

## Thor SM110 与优化

`GPTQ.fasterquant`无条件 `torch.cuda.synchronize()`，不能在无CUDA机器上原样执行；本例没有monkey patch或伪造CPU成功。`quant.py`捕获缺失quant_cuda导入，本期不调用它的Quant3Linear；该类限制单token且为3-bit，不适配本期4-bit矩阵。原仓库历史A100/CUDA11验证不能证明Thor支持。

本例不构建上游扩展；运行仅限CC11.0且PyTorch含sm_110。`TORCH_CUDA_ARCH_LIST=11.0`只约束未来显式扩展编译，不会把已安装torch二进制变成兼容。CUDA13编译器/JetPack参考与诊断见[主课优化说明](../../OPTIMIZATION.md)。实际后端是解码后的FP16 dense GEMM，架构指令、累加实现与计时须依据该torch/cuBLAS构建检查。

已有[Thor packed SIMT GEMM基线/共享内存候选](../../../2026-09-18/session-02/src/quant_gemm.cu)及[ncu/ISA流程](../../../2026-09-18/session-02/README.md)可作为后续集成材料。它的signed/group16和本例unsigned/per-channel affine格式不同，**不能直接读取本例文件**。接入时必须实现u4解码减zero、scale广播并复测，当前并未完成该后端适配。今天主课提供完整Thor归约基线/优化及ISA教程，但不是GPTQ GEMM性能证明。

## 验证与待补

[verification.json](verification.json)分别记录：本地源码获取否，固定commit网页实现阅读是，原生示例交付是，CPU运行否，Thor验证否。[实际运行失败](results/native.txt)为缺固定checkout；环境还缺三项Python依赖与目标设备。本期进入backlog，不将“写好示例”记作整体完成。次日量化游标AdaRound；今天只推进一次，AWQ只重试一次。

后续验收：固定checkout和依赖版本→Thor构建sm_110兼容检查→示例实际执行→保存真实误差/存储/性能→对真实本地模型验证任务精度。源码阅读可通过网页确认，克隆与运行必须保留独立状态。
