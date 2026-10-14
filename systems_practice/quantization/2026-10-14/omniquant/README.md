# 2026-10-14 OmniQuant第二轮：LWC校准优化与硬导出合同

## 方法与应用场景

本期深入一个方法：OmniQuant的Learnable Weight Clipping（LWC）。输入`[31,32]`、权重`[16,32]`、group8、W4权重/浮点激活。原生最小API示例为FP32激活QDQ；额外计算FP16参考，不把FP32激活称为真实W4A16 kernel。主课四位宽和Smooth/outlier/QAT对照直接链接[今日GEMM](../../../daily/2026-10-14/README.md)，不重复作业。

算法是用校准重建损失学习正负裁剪因子；格式是均匀非对称INT4，码0..15，组scale与整数zero；位宽与算法不同。预训练权重冻结，校准优化只更新裁剪参数，所以此例属于优化式PTQ；[主课STE实验](../../../daily/2026-10-14/experiment.py)另有真正主权重QAT更新。LWC降低少数极值占用的范围，可能增加饱和损失，不保证总误差下降。

## 原仓库与实际读过的实现

仓库[OpenGVLab/OmniQuant](https://github.com/OpenGVLab/OmniQuant)，实际浅拉取commit`feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14`，2026-10-14。未发现仓库迁移。初次DNS失败保留[source.json](source.json)，网络重试真实成功见[source-network-retry.json](source-network-retry.json)。该下载记录中的source_read=false是获取时事实，后续阅读状态单列[verification.json](verification.json)。

实际读取：

- [quantizer.py](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/quantizer.py)：`round_ste`、`UniformAffineQuantizer.__init__/forward/per_token_dynamic_calibration/fake_quant/register_scales_and_zeros`。
- [int_linear.py](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/int_linear.py)：`QuantLinear.__init__/set_quant_state/forward`。
- [omniquant.py](https://github.com/OpenGVLab/OmniQuant/blob/feffe8ea87d80f7bb57b6e25e7cff9dc950fcc14/quantize/omniquant.py)：捕获输入、LET初始化、LWC/LET参数分组AdamW、重建训练、inplace转换及`real_quant`位宽限制；没有执行完整模型入口。
- README安装/使用、pyproject0.1.0、LICENCE正文。LICENCE是MIT，pyproject的Apache分类冲突仍存在；本课按实际MIT正文记录，不复制上游实现。

调用链：已有`nn.Linear`→`QuantLinear(...group_size=8,lwc=True)`→`set_quant_state(True,False)`→动态组范围→sigmoid上下限→round_ste+clamp→FP32反量化→`F.linear`。原项目用于逐Transformer block校准；我们原样调用其低层量化Linear，训练编排和导出器为独立教学代码。LET只解释与sW等价变换的联系，今天不实现/声称完整LET流程。

## 如何接入我的代码

主机Python3.9.6与已有运行时Python3.12.14均未发现torch。上游声明Python≥3.8、torch≥2.0、transformers≥4.31；此低层路径实际import还需要numpy、tqdm，不需要模型下载或完整Transformers。下列命令使用已准备依赖，不自动安装：

```sh
# 从仓库根执行；SOURCE指向含quantize/的固定commit源码目录
OMNIQUANT_SOURCE="$PWD/systems_practice/.tmp/quant_sources/omniquant-j3g8gona/source" \
  PYTHON=python3 sh systems_practice/quantization/2026-10-14/omniquant/run.sh
```

缓存不可用时重新执行源码获取工具并将SOURCE换成新记录的source目录，核对commit；不把历史绝对路径当可移植依赖。示例有完整[example.py](example.py)，CPU为默认设备，种子14、单torch线程，不接入CUDA扩展。

四组数据64/64/32/31行各自独立：train做40步LWC校准更新，cal做初始范围探测，tune在lr0.001/0.01之间选择，test仅最后评分。这里量化器仍动态从权重得到组范围，cal输入不会“冻结激活观察器”。激活不量化，必须明确这个调用边界。将`linear`换成已有模型的某个Linear，先保存原模块用于参考，再在`model.parent.child`处替换为选中的`best`；不能直接在任意非线性两端融合同一个scale。

导出读取最后一次weight_quantizer的scale/round_zero_point，以同一舍入和clamp产生码字。`build/linear-u4.bin`含256B码、64×4B scale、64×4B zero，共768B（这个数是格式计算，实际文件尚未产生）；shape/group属于本例固定合同。示例从文件重载并与原生QDQ比较，再用解码FP32权重推理，明确不调用低位TC。导出后上线还需单独版本/shape/checksum清单。

## 量化前后比较

[原始失败](native-attempt.txt)为`ModuleNotFoundError: No module named 'torch'`；原生误差、实际文件字节和CPU时间均未验证。代码将输出FP32/FP16、minmax基线、LWC、分布偏移误差、参数更新L2、实际文件大小及CPU框架P50。5次预热30采样，分开FP32、原生QDQ（含重复量化）和解码FP32 Linear；不将QDQ速度解释为packed推理速度。脚本日志必须出现非零参数更新和重载相等，否则不通过。

边界：group8整除K32；原代码非对称LWC对不整除shape不支持相同padding分支，不擅自改K33后声明通过。全零组靠CLIPMIN处理；尚未运行原生边界，主课零矩阵结果不是本API结果。

## Thor SM110 与优化

本例CPU低层QDQ不证明AutoGPTQ-bugfix、MLC或原生packed后端支持Thor。上游完整`real_quant`仅准许wbits2/3/4且abits≥16，不能用它宣称W4A4原生部署。后端准确版本和SM110扩展构建还待核查，不自动编译未审计扩展。任何后续CUDA扩展只能用`TORCH_CUDA_ARCH_LIST=11.0`/`-arch=sm_110`并核查支持矩阵。

具体Thor packed基线/候选、ncu、手写PTX与ISA对照复用[主课CUDA](../../../daily/2026-10-14/src/gemm.cu)和[分析说明](../../../daily/2026-10-14/PROFILING.md)。它采用对称零点0，与本例非对称导出格式不同，**不能把本例bin直接交给主课kernel**；部署需添加zero点减法、schema解析并重新验证。

## 验证与待补

源码获取/阅读/示例交付=是；原生CPU运行/Thor验证=否。保持backlog，不将独立NumPy结果混入原生状态。今日只重试一个旧待补：QuaRot源获取成功，记录[quarot-backlog-retry.json](quarot-backlog-retry.json)，未额外阅读或运行，不推进QuaRot课。

两条故障链：①训练有梯度但输出没变化→只更新裁剪因子还是码字已变？→检查参数L2和硬码差异→保留硬化评估，不能仅报loss；②导出重载误差增→zero未舍入或scale顺序错→逐group比码/scale/zero→按原API顺序恢复，付出元数据成本。

迁移验收：固定commit与包版本、native参数更新、独立eval、导出重载、低位后端兼容、Thor编译/正确性/E2E分别过关。追问：①LWC与QAT更新谁？②sigmoid为何限制范围？③shape不足group时为什么要查实现？④zero-point占用多少？⑤QDQ为何可能更慢？⑥LET可在任意算子边界融合吗？
