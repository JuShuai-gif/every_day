# 2026-10-17 SpinQuant第二轮：旋转训练、正交约束与交付成本

## 方法与应用场景

上一课QuaRot是固定旋转，本课学习旋转参数：为边缘Linear的W4A4减少输出重建误差，同时把旋转矩阵的存储/在线成本计入部署。算法是可学习正交变换；本例数值格式是对称INT4整数、scale为FP32；位宽W4A4不等于FP4；训练范式是冻结预训练权重、在QDQ前向下更新旋转的PTQ优化，不声称完整权重QAT。

输入X[batch,32] FP32，W[16,32] FP32，R[32,32]。采用 `(XR)(WR)^T = XW^T`（R正交）保持未量化等价。权重per-output-channel scale、激活per-token动态scale；signed q∈[-8,7]，上游torch.round，零点0，实际计算为FP32 QDQ Linear。校准、训练、调参、评估分别为32/64/32/31个不共享存储的随机样本；cal只核对未量化等价，不声称动态scale需要离线校准。样本是单层合成数据，不是模型任务精度。

## 原仓库与实际读过的实现

真实浅获取 [facebookresearch/SpinQuant](https://github.com/facebookresearch/SpinQuant)，commit `8f47aa3f00e8662caf1a484153920a07e5281c3a`，读取2026-10-17。`LICENSE`实际为CC-BY-NC-4.0；工具文件头还注明来自QuaRot的Apache2代码，商业部署须独立核对许可范围。本课不复制源文件进Git，使用外部原始模块。

- [optimize_rotation.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/optimize_rotation.py)：train冻结权重、构造R1/R2、SGDG优化及R.bin保存；原RotateModule强制CUDA，不能称CPU单层API。
- [train_utils/optimizer.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/train_utils/optimizer.py)：SGDG.step→unit/随机QR→反对称W→Cayley_loop五次迭代，实际近似流形更新，不是假“训练”标签。
- [train_utils/quant_linear.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/train_utils/quant_linear.py)：QuantizeLinear.forward，先用FP64中间乘R再转回权重dtype，调用量化器后F.linear。
- [utils/quant_utils.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/utils/quant_utils.py)：ActQuantizer/WeightQuantizer.configure/find_params/quantize/fake_quantize及STEQuantize；weight的quantize返回QDQ，fake_quantize额外返回整数和scale。
- [train_utils/main.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/train_utils/main.py)、[rtn_utils.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/train_utils/rtn_utils.py)：prepare_model→rtn_fwrd插入真实quantizer；[eval_utils/rotation_utils.py](https://github.com/facebookresearch/SpinQuant/blob/8f47aa3f00e8662caf1a484153920a07e5281c3a/eval_utils/rotation_utils.py)已读embedding/attention/MLP旋转函数，未阅读全部评估算法。
- README、requirement.txt、utils/utils.py与hadamard_utils.py导入链已读。旧 `utils/rotation_utils.py`不存在，实际在eval_utils下；catalog本次纠正。

`source.json`保留初次DNS失败，`source-retry.json`保留旧路径404，`source-imports.json`保存成功获取的固定版本文件哈希/永久链接。下载记录中的source_read=false是获取时状态，后续阅读状态单独在[verification.json](verification.json)。示例是原生低层API组合，优化目标/小张量/导出容器为本课自写；不是作者完整Llama训练入口或ExecuTorch导出。

## 如何接入我的代码

```sh
# 仓库根目录；此缓存由本次实际获取产生，其他机器先取相同commit。
SPINQUANT_ROOT="$PWD/systems_practice/.tmp/quant_sources/spinquant-hbvn44_5/source" sh systems_practice/quantization/2026-10-17/spinquant/run.sh
```

复现准备可在 `systems_practice/.tmp/quant_sources` 浅获取上述commit，并取原始train_utils、utils目录；不运行上游默认下载模型的数据流程。本地Python3.9.6；上游README声明Python3.9/PyTorch≥2.0，requirements固定transformers4.44.2、accelerate0.34.2、datasets2.20.0。原生量化器间接import fast_hadamard_transform，即使本例仅运行CPU且不调用Hadamard也需要可导入的该包；不能伪造模块绕过后声称原生完整运行。torch/transformers/FHT本机缺失，未安装；实际失败见[native-attempt.txt](results/native-attempt.txt)。

[example.py](example.py)已写好：QuantizeLinear和两量化器→80次SGDG真实step→只用tune挑checkpoint→冻结R→fake_quantize取得int4与scale→自写二补码nibble打包→保存并从字节重载→在线XR、激活QDQ、FP32 Linear。若本地R更新量为0或正交误差≥5e-3会拒绝，不把未发生训练标为成功。校准/调参数据不进入最终eval误差；分布偏移和全零独立报告。

接已有 `nn.Linear` 时替换示例层创建处、复制其weight/bias并冻结；保留输入特征数和输出行scale，bias不参与旋转。单层在线XR开销是显式代价，整模型融合需遵守残差/RMSNorm边界，不能直接把本例扩展到所有层。输出 `build/packed.bin`为SPQ1自定义文件：header、每两权重一字节、每输出行FP32 scale、完整FP32 R；不是原生低位Tensor Core格式。文件只在运行后生成并被忽略。

## 量化前后比较

示例输出FP32参考、FP16存储/FP32计算参考、absmax W4A4、随机旋转W4A4、学习旋转导出版本的NRMSE/最大误差/余弦，以及训练日志/正交误差/真实文件字节。前向为框架QDQ，不是原生INT4 GEMM。计时预热10次、31批×20，CPU单线程，比较FP32 Linear与包含在线旋转/动态QDQ的FP32 Linear；不混入离线训练和预解包。

本次所有上述数值及性能为**未验证**，缺torch，未生成packed.bin。按格式可计算的理论payload为256B权重+64B scale+4096B R+12B header，甚至大于1024B FP16权重；这是预算公式，不是假实测文件。要融合R或摊销跨层成本后才可能得到存储优势。

## Thor SM110 与优化

本期没有编写或调用量化CUDA kernel，CPU原生示例的执行结果也未获得。Thor PyTorch wheel、CUDA13+、ABI、驱动及aarch64依赖组合待验。[fast-hadamard-transform master setup.py](https://github.com/Dao-AILab/fast-hadamard-transform/blob/master/setup.py)本次实际读94–160行：CUDA≥13时包含sm_110，但同时硬编码多个其他目标。单设TORCH_CUDA_ARCH_LIST不会删除显式cc_flag，不应直接按上游脚本构建。

提供[restrict_fht_target.py](restrict_fht_target.py)只对用户指定的 `systems_practice/.tmp` 中副本把cc_flag生成改为唯一compute_110/sm_110。此工具和构建均**未执行**，完整扩展/后端兼容性仍未验；本任务不安装依赖。若在准备好的Thor工具链手动构建，只能在本课允许的缓存目录执行：

```sh
# FHT_ROOT必须为systems_practice/.tmp中的已审核源码副本；先执行补丁生成器。
python3 systems_practice/quantization/2026-10-17/spinquant/restrict_fht_target.py "$FHT_ROOT"
cd "$FHT_ROOT"
FAST_HADAMARD_TRANSFORM_FORCE_BUILD=TRUE TORCH_CUDA_ARCH_LIST=11.0 python3 setup.py build_ext --inplace
```

这仅构建扩展，不证明SpinQuant完整后端支持；精度/低位算子需另验。主课Thor [kernel与ncu/ISA教程](../../../daily/2026-10-17/GPU_ANALYSIS.md)是通用分析练习，不能冒充本方法性能。

## 故障、迁移与追问

1. 未量化旋转后也有误差：先看RᵀR及X/W是否同向旋转，再看近似Cayley收敛；降低步长或检查矩阵方向，代价是训练时间。不能把正交漂移全部记作INT4误差。
2. 合成误差改善但存储增加/服务变慢：检查R矩阵及在线XR、scale元数据与解包边界；部署需融合或复用，无法抵消时保留absmax/固定旋转路径。模型精度仍需真实校准/评估集。
3. import即失败：沿quant_utils→hadamard_utils→utils→FHT排查，CPU数学算子并不意味着整个包无CUDA依赖。原始错误保留，不捏造原生运行结果。

迁移检查：固定commit和包版本、验证更新与正交性、重载等价、独立数据分区、记录真实存储、区分QDQ/低位kernel、目标Thor ABI和性能回归。

追问：①为何旋转不能保证量化收益？②SGDG更新哪类参数？③五次Cayley迭代有何误差？④fake_quantize返回的整数如何导出？⑤R何时可融合？⑥小Linear压缩为什么可能更大？

## 验证与待补

源码获取是／实现阅读是／完整原生API示例交付是／CPU原生运行否／Thor验证否。AST语法检查不等于API运行。原生CPU、扩展及板端进入backlog。今日只重试一个旧SpQR获取项，commit543d10e56f921e5eeb10d5f0aaaccd30b6662d0e、4文件成功；未读/未跑，不算SpQR今日课，不推进其交付状态。下一方法SpQR。
