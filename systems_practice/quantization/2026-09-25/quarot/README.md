# 2026-09-25 QuaRot：原生小层示例与部署边界

实际补课/源码阅读：2026-09-28，课程日期不是历史执行声明。

## 方法与应用场景

固定正交Hadamard旋转分散离群值，补偿权重变换使浮点输出不变，再做低位量化。PTQ算法不是INT4格式本身，不需要训练更新。本例W4A4，权重每行scale、激活每token scale，signed -8..7；实际算术为FP32 QDQ累加。 适合边缘视觉/语言编码器的Linear量化误差排查。相同合成输入种子20260928，权重[16,32]、激活[64,32]，先理解机制再接本地模型。

## 原仓库与实际读过的实现

[原仓库](https://github.com/spcl/QuaRot)，版本 **5008669b08c1f11f9b64d52d16fddd47ca754c5a**；许可证[Apache-2.0](https://github.com/spcl/QuaRot/blob/main/LICENSE)。[拉取原始失败](source.json) · [实际网页阅读](source-read.json)。未发现迁移；失败后没有可验证本地cache。

- [fake_quant/rotation_utils.py / register_online_rotation / online_rotate](https://github.com/spcl/QuaRot/blob/5008669b08c1f11f9b64d52d16fddd47ca754c5a/fake_quant/rotation_utils.py)
- [fake_quant/quant_utils.py / ActQuantizer / pack_i4 / unpack_i4](https://github.com/spcl/QuaRot/blob/5008669b08c1f11f9b64d52d16fddd47ca754c5a/fake_quant/quant_utils.py)

先调用原生rotation hook核对未量化等价，再移除hook，显式xQ与WQ路径接原生ActQuantizer。原生pack_i4把两个有符号码真正装入一个uint8；unpack_i4回环后用于浮点Linear。保留旋转/打包/动态激活量化；省略全LLM LayerNorm融合、GPTQ和KV量化。

## 如何接入我的代码

[完整原生API示例](upstream_api.py)使用[公共评估驱动](../../backfill_evaluation.py)。已有Linear接入点是w：用本地层的detach权重和独立校准数据替换随机值，不下载模型。工作目录由run.sh固定为本课目录，QUANT_SOURCE使用绝对checkout路径。

上游requirements读取torch2.2.1、transformers4.38.0，rotation_utils模块导入还依赖fast_hadamard_transform及utils间接依赖。原要求版本不是Thor兼容矩阵。本例候选Python3.10/PyTorch2.6+，若迁移依赖需重测原生API；当前无任何已验证依赖组合。

联网后从EveryDay根目录准备（本次尝试已失败，不声称已克隆）：

```sh
git clone --depth=1 https://github.com/spcl/QuaRot.git systems_practice/.tmp/quant_sources/quarot-pinned
git -C systems_practice/.tmp/quant_sources/quarot-pinned fetch --depth=1 origin 5008669b08c1f11f9b64d52d16fddd47ca754c5a
git -C systems_practice/.tmp/quant_sources/quarot-pinned checkout --detach 5008669b08c1f11f9b64d52d16fddd47ca754c5a
bash systems_practice/quantization/2026-09-25/quarot/run.sh
```

128行calibration只用于统计/学习，64行tuning选参数，64行heldout与64行shifted只作最终评估。QuaRot固定变换没有训练，calibration不被误称学习；SpinQuant两档lr0.01/0.05各80次真实opt.step写好；SpQR阈值1/4/inf、阻尼0.01、bits4、组16。不将没有运行的梯度代码记成成功更新。

导出packed权重、FP32scale、32×32 FP32旋转矩阵。小层的旋转矩阵开销可能比权重更大，必须统计总量。重载需要重新构造激活量化器，实际推理先unpack再FP32 matmul，不能称原生INT4 GEMM。 输出为忽略的build/native/state.pt和comparison.json；不提交checkpoint。重载只读脚本自身生成的weights_only张量字典，并检查同输入等价；先检查全零输入有限值。

## 量化前后比较

公共驱动比较FP32、FP16权重存储往返、absmax权重4位和原生方法。absmax是对照，不作为当天深入的方法。不同激活位宽的诊断对照明确不用于宣称同精度优势。原生方法在相同heldout/shifted输入报告MSE、最大绝对误差和真实张量字节（含稀疏索引）；文件字节单列。20预热100采样单线程CPU框架P50/P95包含解包/旋转/QDQ，不是GPU kernel或端到端服务耗时。

| 验收 | 本次结果 |
|---|---|
| 源码获取 / 网页实现阅读 / 示例交付 | 失败 / 是 / 是 |
| CPU原生执行 / 导出重载 / 数值比较 | 未运行：缺torch及checkout |
| 真实字节 / 原生推理耗时 | 未产生，禁止以理论位宽补成实测 |
| Thor编译 / 执行 / 性能 | 均未验证 |

原始环境检查见[results](results/native-attempt.txt)。边界：分组维度不整除、样本全零导致退化统计、分布偏移可能放大误差；必须先验尺寸并单列shifted数据。小张量结果不可外推LLM任务准确率。

## Thor SM110 与优化

本课调用CPU算法API，没有自写CUDA量化kernel，不把QDQ浮点matmul当低位Tensor Core。上游扩展能否在Thor运行尚未证明；旧torch/CUTLASS/fast-hadamard版本的支持不能从GPU名称推断。任何后续扩展仅允许 `TORCH_CUDA_ARCH_LIST=11.0` 对应普通sm_110并核对实际nvcc命令，不启用其他架构或专属后缀。官方JetPack7.2.1/CUDA13.2.2组合与上游旧依赖还需移植验收，不能直接宣称可用。

若后续接kernel，先保留数学基线与最终候选，按[Thor ncu/PTX/SASS完整流程](../../../daily/2026-09-26/PROFILE.md)采集相同形状/精度；该softmax教程不是本方法的量化性能证据。当前没有SASS或速度数字。

## 验证与待补

[verification.json](verification.json)分别记录五个阶段。源码版本固定已完成网页核对；本地获取、依赖、原生运行与Thor均进入backlog。今天已有AWQ一次重试，不因四天补课额外重复重试旧项。量化栏目为已写好的额外示例，不添加编码作业或自测。

公共评估额外给出同形状的 W4A32 与 W4A4 absmax 对照、输入/权重FP16存储往返且FP32累加参考、NRMSE/余弦/最大误差、基线截断率与端点比例、真实状态/文件字节和输入张量字节。20预热/100次计时包含各分支实际旋转、QDQ、解包开销，不能解释为低位kernel公平测速；这些输出目前均未生成。零输入与31列非法shape分别检查。
