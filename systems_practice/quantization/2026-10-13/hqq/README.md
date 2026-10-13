# 2026-10-13 HQQ：分组轴、零点优化与原生打包重载

## 方法与应用场景

本轮新设计点是“同样4位，为何分组轴/元数据会改变交付格式”，承接9月23日近端算法课。小投影层W[32,64]、X[32,64]，均FP32 row-major；CPU原生示例额外比较明确FP16算术参考。HQQ是无需激活校准的权重PTQ算法，INT4是整数存储格式，W4A16是权重/激活位宽组合，QAT是训练范式：四者不能互换。本课实际框架路径为W4存储→FP32解码→FP32 GEMM，**不是W4A16原生kernel**。FP16参考也不代表HQQ后端在用Tensor Core。

设组内逆尺度s、零点z，q=clip(round(Ws+z),0,15)，重建为(q−z)/s。近端步骤先对残差做L_p收缩，再更新z；默认legacy solver采用p=0.7、beta=10、kappa=1.01、最多20步。它是权重重建优化，没有激活校准、梯度反传或模型训练更新。保存时scale转为1/s。round_zero只初始化舍入零点，之后近端更新可产生非整数z；不能自行改成整型metadata而声称语义不变。

axis=1将权重reshape为[-1,group_size]，沿每行组内归约；group32/64只改变粒度，四组对照同时保留optimize=False/True。全部配置报告结果，不用评估集挑胜者。absmax是独立QDQ数值基线，单独标注未压缩导出。正常评估与首输入通道放大12倍的分布变化评估使用同一冻结量化权重；没有训练/校准/调参数据混用。

## 原仓库与实际读过的实现

实际仓库[dropbox/hqq](https://github.com/dropbox/hqq)，旧mobiusml地址仍出现在setup元数据，当前Readme安装入口和GitHub重定向迁移到Dropbox。commit **d88a488ec8aa2d58362ef2038a52bca862db2e74**，setup版本0.2.8.post1，Apache-2.0，读取日2026-10-13。

- [quantize.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/quantize.py)：Quantizer.quantize/dequantize、HQQLinear.__init__/quantize/cuda/forward_pytorch/state_dict/load_state_dict、BaseQuantizeConfig别名。
- [optimize.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/optimize.py)：shrink_lp_op、optimize_weights_proximal_legacy_step/legacy与默认alias；v2不是默认实现。
- [bitpack.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/bitpack.py)：pack/unpack_4bit_u8；[utils.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/core/utils.py)读取序列化类型编码/解码。
- [setup.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/setup.py)、Readme与LICENSE；额外读[kernels/setup_cuda.py](https://github.com/dropbox/hqq/blob/d88a488ec8aa2d58362ef2038a52bca862db2e74/hqq/kernels/setup_cuda.py)的CUDAExtension声明。

调用链：用户Linear/config→HQQLinear.quantize→Quantizer分组/minmax→legacy近端→BitPack→W_q/meta→forward_pytorch解码→torch.matmul。state_dict对元数据编码，load_state_dict会pop输入字典，所以示例用deepcopy再传入。

**原生API直接调用，实验编排独立编写**；没有复制上游函数。保留真实打包和恢复，省略Transformer遍历、多GPU、元数据offload、融合kernel和任务精度。不是完整LLM复现。[首次失败记录](source.json)保留DNS错误，[浅拉取成功](source-retry.json)不被改写为已读，实际阅读证据另存[source-read.json](source-read.json)。

## 如何接入我的代码

[example.py](example.py)和[run.sh](run.sh)已完整写好，固定CPU，不下载模型。宿主Python3.9.6缺torch，内置Python3.12也缺torch；代码仅AST检查通过，尚无可用环境版本组合实证。上游Readme要求PyTorch2与CUDA版本匹配，setup要求numpy>=1.24.4、tqdm>=4.64.1、transformers>=4.36.1，另含einops/accelerate/huggingface_hub/termcolor。不得将这些下限当Thor已验配置。建议在已有Python3.10+、PyTorch2环境准备固定源码，记录实际torch/numpy/HQQ版本后运行。

```sh
# 项目根目录：仅准备命令，未自动安装依赖
GIT_LFS_SKIP_SMUDGE=1 git clone --filter=blob:none --no-checkout https://github.com/dropbox/hqq.git systems_practice/.tmp/quant_sources/hqq-pinned
 git -C systems_practice/.tmp/quant_sources/hqq-pinned checkout d88a488ec8aa2d58362ef2038a52bca862db2e74
# 使用已有兼容依赖；源码目录从项目根解析后传给子脚本
PYTHONPATH="$PWD/systems_practice/.tmp/quant_sources/hqq-pinned" sh systems_practice/quantization/2026-10-13/hqq/run.sh
```

入口先Quantizer.quantize(bitpack=True,axis=1,group_size=32/64,device='cpu')，显式设置meta.compute_dtype=FP32；保存packed+meta到忽略的build/*.pt后立即重载并逐位检查重建一致。高层接入使用BaseQuantizeConfig与HQQLinear(del_orig=False)，在用户自己的模型初始化阶段将`model.proj`替换为示例replacement；本例保留原始Linear用于基线，不能先删除它再计参考结果。重复使用时注意set_backend是类级配置，别在并发推理中切换。

4bit打包的关键：分组张量前半行进高4bit、后半行进低4bit；不是简单把相邻权重配对。对于组32，分组视图[64,32]，packed视图[32,32] uint8。必须连同shape、axis、group_size、scale/zero和packing恢复，不能只写裸W_q。高层序列化保存类型信息，但容器头也是文件字节的一部分。

验收：packed.numel×2==W.numel；重载解码与保存前逐位一致；全零权重解码仍全零；group31必须拒绝；高层Linear恢复输出一致。损失指标只要求有限并报告，不强制HQQ胜出。load仅针对本示例刚保存的文件，不自动读取外部模型pickle。

## 量化前后比较

| 项目 | 本次实测状态 | 运行后产出 |
| --- | --- | --- |
| FP32/FP16与absmax/HQQ重建 | 缺torch，未验证 | NRMSE/最大绝对误差/余弦及分布变化 |
| uint8 packed+scale/zero | API已交付，未实际产出文件 | packed_bytes、metadata张量字节与.pt真实文件大小分别报告 |
| 量化/解码/解码+GEMM | 未运行，不填收益 | CPU同步主机时间；10次预热50采样P50 |
| GPU/NPU/端到端 | 未验证 | 不能从CPU/GEMM推断 |

示例endpoint_fraction只是量化码落在0/15的比例，不等于浮点值被裁剪的饱和率。组32的理论权重payload为1024B，FP32 scale/zero共512B（不含容器/类型）；这是形状计算，**不是本次实测文件**。较小组提高元数据占比，解码+浮点矩阵乘可能比直接FP32更慢，不能把压缩倍数写成加速比。

## Thor SM110 与优化

今日HQQ例子定位原生CPU算法/格式验收，没有调用CUDA扩展，也没有伪装成GPU基准。源码set_backend明确ATEN仅axis=0/GPU，本课axis=1不能直接切换ATEN。PYTORCH路径支持设置device但Torch本身及高层后端的Thor运行仍待验；函数名cuda内部通过.to(device)迁移，不据此断定只支持CUDA或证明CPU运行。

setup_cuda.py依赖torch.utils.cpp_extension选择编译架构，没有固定sm_110保证；将来在Thor已有环境构建必须设置`TORCH_CUDA_ARCH_LIST=11.0`并确认torch能接受、nvcc支持sm_110，检查日志只有目标110。不能沿用其他GPU产物；未知兼容时先停在算法路径。完整kernel优化/ncu/PTX/SASS训练见[今日主课](../../../daily/2026-10-13/PROFILE.md)，该课是FP32 GEMM，**不是HQQ融合backend验证**。本次未读ATEN kernel主体，也没有可证明的HQQ原生Thor低位吞吐。

## 验证与待补

五项状态：源码获取是；实现阅读是；原生示例交付是；CPU原生运行否（torch缺失）；Thor验证否。[verification.json](verification.json)与[原始失败](results/native-attempt.txt)。独立数学小例不用于替代本栏目。今日最多重试一个旧项OmniQuant源码获取，不把预备源码算明日课程。

故障链一：重载形状对但输出乱→误把上下半行配对解释为相邻配对→先检查pack/unpack roundtrip和meta.axis→保留原格式或显式转换后重验，增加转换成本。故障链二：权重MSE更低而业务误差更高→输入协方差/离群方向改变→冻结权重后在独立Xshift评估→考虑激活感知方法或提高位宽，不能偷偷用评估集调group。故障链三：axis1转ATEN报错/结果异常→后端合同不符→核对set_backend警告和shape→保持PyTorch后端，目标融合实现另验。

迁移验收：版本与commit固定；区分初始零点与优化后零点；打包与元数据重载一致；保留零/常值/不可整除组；评估数据独立；CPU性能、模型任务精度、Thor性能分别补证。

追问：①HQQ为何不需要激活校准？②scale保存前为何取倒数？③group32与64的元数据代价？④哪两个原权重共享一个字节？⑤round_zero为何不能推出最终零点整数？⑥权重误差下降为何不保证Linear输出改善？
