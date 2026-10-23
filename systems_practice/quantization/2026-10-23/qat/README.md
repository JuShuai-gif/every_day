# 2026-10-23 QAT第二轮：固定量化网格、STE更新与真实导出

## 方法与应用场景

今天深入**固定scale的权重QAT**：把小Linear的浮点影子参数放在训练中，用离散前向和STE梯度优化，而不是只调用一次fake quant。QAT是训练范式，均匀仿射量化是算法，INT4是4位有符号整数格式，W4A16是部署位宽合同，四者不能混称。原生例子为了CPU训练采用FP32激活/累加，另给FP16参考；导出W4真实字节不自动使计算变成W4A16 Tensor Core。

原生输入train[64,16]、cal[32,16]、tune[32,16]、eval[31,16]，权重[8,16]，bias=False。每行按8元素分组，逻辑码[-8,7]、整数零点0、FP32 scale。`torch.int32`只是已核验API的逻辑码载体，导出时两个4位补码打包一个uint8。前向ties-to-even舍入，按范围钳位，浮点F.linear累加。权重静态scale只在第一次前向初始化，不跟每步重新absmax；cal输入不会优化权重，因为本例没有激活observer。和昨天EMA不同，今天学习信号来自实际梯度更新。

## 原仓库与实际读过的实现

实际浅拉取[PyTorch AO](https://github.com/pytorch/ao)，commit `9e9dca96d42cf05985aeaf0afe5546d9d002b337`，version.txt=0.19.0，2026-10-23，BSD-3-Clause（Meta与Arm署名）。[source.json](source.json)记录真实commit、blob和永久链接；初次DNS失败及成功重试记录均保留。README声明量化开发逐步转入torch及使用方仓库，这是开发方向调整，本次原仓库仍可获取，没有凭此虚构迁移地址。

实际阅读链：

1. [FakeQuantizedLinear.from_linear/forward](https://github.com/pytorch/ao/blob/9e9dca96d42cf05985aeaf0afe5546d9d002b337/torchao/quantization/qat/linear.py)接收真实nn.Linear；from_linear共享传入Parameter，因此本例先deepcopy。
2. [IntxFakeQuantizeConfig](https://github.com/pytorch/ao/blob/9e9dca96d42cf05985aeaf0afe5546d9d002b337/torchao/quantization/qat/fake_quantize_config.py)允许int32指定quant_min/max，检查group、dynamic/range_learning冲突。
3. [IntxFakeQuantizer](https://github.com/pytorch/ao/blob/9e9dca96d42cf05985aeaf0afe5546d9d002b337/torchao/quantization/qat/fake_quantizer.py)首次空scale初始化，`_should_compute_qparams`控制静态复用，`_per_channel_or_group_forward`执行分组量化。
4. qat/utils.py `_fake_quantize_per_channel_group`→[quant_primitives.py](https://github.com/pytorch/ao/blob/9e9dca96d42cf05985aeaf0afe5546d9d002b337/torchao/quantization/quant_primitives.py) `_fake_quantize_affine`→量化/反量化；`_Round.backward`传递梯度，`_ClampSTE.backward`在**已舍入码**处检查含边界区间，范围外梯度置零。最后仍是F.linear。

native.py原样调用已读API，数据、训练循环和自定义打包是独立教学代码，不是上游完整训练/convert复现。`to_linear()`返回浮点Linear，不能当作压缩导出；本课没有这样使用。independent.py完全独立，不能作为原生示例已运行证据。

## 如何接入我的代码

工作目录：`systems_practice/quantization/2026-10-23/qat/`。原生环境要求Python≥3.10；本次源码`torchao/__init__.py`对预构建扩展检查torch≥2.11.0，这不是本机兼容实测。建议为该固定commit准备已有torch 2.11+环境；确切patch/平台组合需运行确认。当前系统Python3.9.6，内置Python3.12.14缺torch，未安装任何包。

可复现的**人工环境准备**（本次未执行安装）：从仓库根目录浅拉取工具记录commit；已有完整AO checkout须处于上述commit。只需CPU Python QAT时，可以在该checkout用`USE_CPP=0 python -m pip install --no-build-isolation --no-deps -e .`明确跳过扩展。这不会安装torch；必须先有兼容torch。缓存helper只有少数文件快照，不能把稀疏缓存直接当完整可import源码。

```sh
cd systems_practice/quantization/2026-10-23/qat
# 指向你已有的完整固定commit源码目录；native.py同时核对git HEAD及import位置。
export TORCHAO_SOURCE=/absolute/path/to/ao
PYTHON=/absolute/path/to/python3 sh run.sh native
# 当前机器可以直接运行的独立数值例：
sh run.sh independent
```

接入已有模型时，把`teacher`替换为本地nn.Linear，保持in_features可整除group_size。例子先deepcopy保留FP32参考，再用from_linear包裹，构造optimizer，80步真实SGD更新；两个lr仅由tune选择，eval最后评估。保留独立训练、初始化、调参、测试及首列放大12倍的偏移数据。零输入检查输出，17输入维度检查不整除错误；不要默默填充改变模型语义。

原生导出`build/native/weights.bin`：16B头、64B scale、64B u4载荷，共144B；代码实际写文件、重载并对比fake-quant输出。这是代码定义的预期结构，本机未生成该文件，不能作为实测存储结果。可解码为FP32或由以后验证的W4A16后端消费；本例推理使用解码后的FP32 F.linear，未调用原生低位GEMM。真实CPU timing区分FP32、已解码FP32和含fake-quant，31次样本、10次预热；不把它标成GPU/NPU/E2E。

## 对照、结果与失败边界

[verification.json](verification.json)五项状态：源码获取/阅读/示例交付=true，原生CPU运行/Thor验证=false。[原生失败](results/native-bundled.txt)为ModuleNotFoundError: torch；系统Python还低于要求。

[独立结果](results/verified-independent.txt)实际执行：2×4权重、两种lr各160次STE更新，scale为原始absmax/7并序列化为FP32。独立例采用FP64计算，**与原生choose_qparams规则不宣称逐位等价**。它记录更新量、截断率、NRMSE/最大误差/余弦，零输出余弦按约定记0；FP16对照只把权重舍入到FP16再FP64累加，完整FP16算术在原生例中待验。

| CPU独立实验 | absmax | QAT最后参数 |
| --- | ---: | ---: |
| eval MSE | 0.00389435 | 0.01511387 |
| 首列×12偏移MSE | 0.08681424 | 0.77868027 |

这是明确的退化：有限步STE和最终checkpoint不保证改善，部署应保留PTQ并以独立验证门槛决定是否采纳。没有用测试集反向挑最好的步数。真u4载荷4B、scale8B、头12B，文件24B，比原始FP16权重载荷16B更大；小张量metadata成本不可忽略。计时是Python解码后小GEMM，仅用于运行边界，不推断低位加速。

## Thor兼容性与性能边界

已核实NVIDIA[JetPack下载表](https://developer.nvidia.com/embedded/jetpack/downloads)列出JetPack7.2.1/Jetson Linux39.2.1/CUDA13.2.2及Thor支持；这是官方组合，不是用户板卡实测。安装板端仍需记录L4T、driver、torch构建、nvcc、ncu版本及compute capability=(11,0)。执行目标始终`sm_110`，扩展环境只能设`TORCH_CUDA_ARCH_LIST=11.0`，不得添加专属后缀。

已读AO setup.py包含架构专用扩展分支，不能因为设了环境变量就声称全部扩展都满足SM110。今天只交付CPU QAT/自定义导出，不构建CUDA扩展、不新增kernel、不提供假的PTX/SASS或Tensor Core性能。若要移植导出格式，可从[已有Thor量化GEMM基线/候选](../../../daily/2026-10-14/README.md)开始，但必须重新核对scale/zero-point合同；该历史实现不是今天原生AO后端的验收。GPU对照游标保持Ada，下次Turing。

## 工业故障与追问

- QAT没更新→权重差为0：检查grad、enabled、optimizer是否包含参数、是否错误detach；例子对真实更新断言，失败就停止。
- 训练看似收敛但导出错→码范围/scale广播不一致：以固定input比较fake-quant与重载结果，检查group和低/高nibble顺序；不要把to_linear当打包。
- 合成误差变差或存储变大：保留baseline与偏移结果，检查checkpoint选择和metadata；回滚PTQ是一种有效结论。

追问：QAT为何不是位宽格式？STE优化的是什么参数？静态scale何时初始化？舍入边界梯度掩码用输入还是码？from_linear共享Parameter会污染哪个参考？为何u4文件更小仍不保证GEMM更快？

## 待补项与下一方法

原生环境、完整torch/AO兼容组合、真实导出重载及CPU结果待补；Thor部署待补。只重试一个旧待补项NF4/QLoRA获取，DNS失败，未发现可核验成功缓存，不推进它的游标。下一日方法NF4/QLoRA；本日QAT只推进一次。
