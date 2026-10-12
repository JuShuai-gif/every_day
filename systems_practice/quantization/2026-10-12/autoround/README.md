# 2026-10-12 AutoRound第二轮：舍入扰动与范围缩放的同条件消融

## 方法与应用场景

已有边缘模型某个Linear量化后误差升高，究竟该改变舍入还是允许裁剪范围缩放？今天固定 `W=[7,35]`、`X=[64,35]`、K方向group=8，对比原生 `quant_tensor_asym` 的仅舍入与舍入+范围两种设置，保留尾group和整行零值。算法是校准数据驱动的PTQ重建；格式是非对称均匀INT4，代码0–15、每组FP32 scale和u8 zero-point；它不是FP4，也不是训练整个模型的QAT。

前向 `q=clamp(round(W/s+v)+z,0,15)`，反量化`Wq=s(q-z)`。这里的`v`改变舍入阈值，`min_scale/max_scale`改变组内范围；二者可能替代彼此，也可能造成校准过拟合。STE让舍入的前向保持离散、反向传近似梯度；SignSGD实际更新参数，冻结原权重。本课参考包括FP32、FP16存储后FP32计算、absmax对称s4、相同group8非对称RTN，两种学习设置之间才是隔离单变量的消融。

知识连接：原始weight → group补零 → 分组范围/zero-point → STE QDQ → 固定Linear重建损失 → SignSGD → 调参集选快照 → 硬码打包/重载 → 浮点推理。压缩存储与原生INT4执行是两个验收点。

## 原仓库与实际读过的实现

[原仓库](https://github.com/intel/auto-round)，commit `7a660e16d39114958a035eab920a44fee0b0b8c4`，读取2026-10-12；GitHub API确认仍是intel/auto-round，无仓库迁移。版本文件0.17.0，Apache-2.0；SignSGD保留PyTorch衍生许可说明。初次sandbox DNS失败保留[source.json](source.json)，获准公网浅拉取后见[source-network-retry.json](source-network-retry.json)。旧`requirements-lib.txt`和`auto_round/sign_sgd.py`不存在，实际依赖是`requirements.txt`，优化器迁至下面的目录。

- [data_type/int.py](https://github.com/intel/auto-round/blob/7a660e16d39114958a035eab920a44fee0b0b8c4/auto_round/data_type/int.py)：`quant_tensor_asym`，实际读取范围/FP32 scale/整数零点/round_ste/clamp及pad还原。
- [data_type/utils.py](https://github.com/intel/auto-round/blob/7a660e16d39114958a035eab920a44fee0b0b8c4/auto_round/data_type/utils.py)：`reshape_pad_tensor_by_group_size`、`revert_tensor_by_pad`、`round_ste`、分派函数选段。
- [SignSGD](https://github.com/intel/auto-round/blob/7a660e16d39114958a035eab920a44fee0b0b8c4/auto_round/algorithms/quantization/sign_round/sign_sgd.py)：构造/step及`_single_tensor_sgd`，真实更新用梯度符号。
- [wrapper.py](https://github.com/intel/auto-round/blob/7a660e16d39114958a035eab920a44fee0b0b8c4/auto_round/wrapper.py)：`WrapperLinear.__init__/_init_tuning_params_and_quant_func/_qdq_weight/forward/unwrapper`，确认框架怎样调用同一低层算法并把QDQ权重写回Linear。
- [setup.py](https://github.com/intel/auto-round/blob/7a660e16d39114958a035eab920a44fee0b0b8c4/setup.py)、requirements、version、LICENSE已读。setup要求Python≥3.11；依赖仅列torch、numpy、datasets、accelerate、transformers≥4.38等，并未固定兼容版本矩阵。

[完整使用例](native_example.py)是真实调用原生低层API的**独立单层编排**，不是作者完整LLM块级AutoRound压缩器，也不照抄旧轮次的v0.9.0 API。pack/reload是独立教学容器，不冒充AutoRound官方导出格式。阅读证据和文件哈希见[source-read.json](source-read.json)。

## 如何接入我的代码

已有Python≥3.11及此commit完整环境时，从项目根运行：

```sh
# 不执行安装，不下载模型；checkout必须由用户已有环境准备。
export AUTOROUND_SRC=/absolute/path/to/auto-round
# 确认必须等于README固定SHA；不把版本字符串相同当作代码相同。
git -C "$AUTOROUND_SRC" rev-parse HEAD
PYTHONPATH="$AUTOROUND_SRC" PYTHON=python3.11 sh systems_practice/quantization/2026-10-12/autoround/run.sh
```

读取完整checkout时其顶层import也需要requirements中的依赖，仅复制一个int.py不能等同于原仓库运行。所有产物在当期`build/`，不提交模型或二进制。脚本本地生成小随机张量，没有联网代码。校准seed21、调参seed22、最终评估seed23、偏移评估seed24严格分离；seed11只生成固定权重。两个变体各80次更新，调参集选快照与变体，最终评估不参与选择。日志验证`v`确实变化，不能把前向fake quant叫完成训练。

接入已有Linear：把例子中的随机`w`换成`layer.weight.detach().float()`，把校准张量换成该层真实输入；组尺寸与实际K一起验证。脚本最后 `copy_` 最优QDQ权重到 `nn.Linear`，示范浮点接入。实际低位部署还需将码、scale、zp转换到已验证后端布局，当前ARL1文件不能直接交给RKNN/TensorRT/Marlin。

导出细节：24字节小端头记录magic/N/K/group/码数/组数，每字节低nibble在前，随后逐组FP32 scale和u8 zp；K尾部补至40，解码后裁回35，检查文件长度与逐元素一致。字节数由实际写文件再读取统计，既包括padding也包括元数据。`endpoint_code_fraction`表示端点码比例，不等同于裁剪饱和率。FP16参考仅舍入存储，计算仍为CPU FP32，未声称原生FP16算子性能。

## 量化前后比较

| 指标 | 本次状态 | 可运行例将输出 |
| --- | --- | --- |
| 原生API运行/真实80步更新 | 未运行 | 各步loss、参数变化、独立调参分数 |
| eval/shifted误差 | 未验证 | MSE、NRMSE、max_abs、cosine |
| 真实压缩文件和重载 | 未生成 | header/payload/scale/zp及实际文件字节 |
| CPU框架Linear时间 | 未测 | 预热10、采样50、P50/P95，解码排除 |
| 校准搜索耗时 | 未测 | 每变体wall seconds，含选快照 |
| Thor低位kernel/E2E | 未验证 | 必须另验后端，不外推CPU数据 |

这里不填理论文件大小当成已测文件。小张量下元数据、解码和调度可能抵消节省；候选在评估或漂移集退化时保留结果，回退RTN/更高位宽。无需第二个编码任务。

## Thor SM110 与优化

本课聚焦CPU算法使用，不交付或声称CUDA低位kernel优化。低层API在浮点Tensor上做QDQ，Linear为普通浮点计算；不能把它的CPU/GPU计时叫INT4 Tensor Core性能。源仓库完整推理导出、CUDA扩展/Marlin等后端的Thor支持**尚未核实**，进入backlog。

已核查[NVIDIA JetPack7.0官方归档](https://developer.nvidia.com/embedded/jetpack/downloads/archive-7.0)：Thor/T5000、Jetson Linux38.2/38.2.1、CUDA13.0、TRT10.13.2.6是一个官方组合；本机没有设备、nvcc或ncu，未验证用户安装。该页未列Nsight Compute配套版本，不能据此捏造ncu兼容。未来扩展构建固定`TORCH_CUDA_ARCH_LIST=11.0`、`CMAKE_CUDA_ARCHITECTURES=110`，nvcc只用`-arch=sm_110`，仍须确认构建脚本是否尊重这些设置；本课不提供会偷偷编其他SM的安装命令。

## 验证与待补

源码获取是、实现阅读是、原生示例交付是、CPU原生运行否、Thor验证否；见[verification.json](verification.json)。系统Python3.9.6不满足最低版本，内置Python3.12.14虽满足但缺torch/auto_round；两次真实失败都保留。仅AST/脚本静态检查通过。未自动安装依赖。今天仅重试一个旧项HQQ，源码拉取成功，未重读、未运行、未推进HQQ游标。

故障链一：缩放梯度变化却输出没变→可能仍在同一整数格点→检查v和硬码变化，而非只看连续参数→在调参集选择硬QDQ快照；代价是搜索额外前向。故障链二：校准误差降、漂移误差升→可能缩小范围损伤稀有通道→检查seed24及端点比例→保留宽范围或高位；不可用评估集重选。故障链三：反量化数值对、导出推理错→nibble顺序/尾group/零点语义不一致→先逐组重载核对再接后端；错误时不宣称低位部署成功。

追问：算法与位格式怎么区分？为何范围参数需要Tensor？STE为何不是离散真梯度？相同group的RTN为何是更公平基线？K=35如何保存最后一组？校准与QAT训练边界在哪里？存储下降为什么不能推出推理变快？
