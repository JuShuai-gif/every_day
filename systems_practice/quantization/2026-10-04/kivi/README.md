# 2026-10-04 KIVI：K/V分组轴与高精度残留

## 方法与应用场景

边缘LLM逐token解码时，KV容量随上下文增长；本课深入KIVI的非对称分组。算法是在线min/max仿射量化及残留缓存管理，格式是unsigned INT2真打包，位宽2并非NF4/FP4，训练范式属于无需训练的推理期量化。本期没有QAT，也没有权重量化；不是W2A16 GEMM教程。

输入`K,V=[1,2,96,32]` FP16，`Q=[1,2,1,32]` FP16；固定group32与32个FP16残留token。旧64个token：K沿时间轴每32个token、每channel一组；V沿channel每32个值、每token一组。`scale=(max-min)/3`、`q=round(clamp((x-min)/scale,0,3))`、恢复`q*scale+min`；这里min是浮点偏移，不要把它当整型zero-point。原生pack16个INT2进int32。注意力误差评估统一使用FP32累加/softmax；这不是压缩布局直接参与注意力的低位kernel。

不离线训练、校准或调参。固定随机seed和离群通道后仅作评估，不能用输出误差调整residual再把同一输入当独立测试。模型级选择group/residual需另留调参集和真正heldout任务集。缓存短于residual时不压缩，压缩收益可为零。

## 原仓库与实际读过的实现

仓库[原KIVI](https://github.com/jy-yuan/KIVI)，commit `876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6`，2026-10-04实际网页阅读；MIT，Copyright 2024 jiayi yuan，[许可证](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/LICENSE)。当前地址未见迁移。真实浅克隆DNS失败，无可验证本地缓存：[原始获取记录](source.json)。网页阅读补充记在[source-web.json](source-web.json)，没有改写获取失败事实。

- [quant/new_pack.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/new_pack.py)：`quant_and_pack_kcache/vcache`→min/max→`pack_tensor`；`unpack_and_dequant_*`→`unpack_tensor`→scale/min恢复。读取低层实现及Triton pack/minmax区域。
- [models/llama_kivi.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/models/llama_kivi.py)：`LlamaAttention_KIVI.forward`中K残留达到块长时转置打包，V超过残留长度时移出最旧token，合并压缩与FP16区间的注意力结果。模型实际走Triton打包及CUDA GEMV，不等于本课CPU低层API路径。
- [quant/matmul.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/matmul.py)：`cuda_bmm_fA_qB_outer`重排打包张量/scale、调用`kivi_gemv.gemv_forward_cuda_outer_dim`；[gemv_cuda.cu](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/csrc/gemv_cuda.cu)读取warp_reduce_sum与g64路径，不宣称审完全部dispatch。
- [quant/setup.py](https://github.com/jy-yuan/KIVI/blob/876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6/quant/setup.py)核对C++17 CUDAExtension与两个源文件；读取requirements与README用户入口。没有自动安装。

native_example.py原样调用已读低层API；本课包装校验、导出重载和评估是独立新增。src/qk.*是独立SIMT候选，非原生KIVI布局适配器或其kernel复制。两者的验证不能互换。

## 如何接入我的代码

上游README指定Python3.10，requirements含torch2.1.2、Triton需随依赖核实、numpy1.26.3、flash-attn2.5.6，而README又提示transformers4.43支持；这些是历史依赖事实，不是Thor兼容组合。小例子只需要torch、numpy与导入new_pack所需Triton，不需要transformers/模型权重。Mac当前无torch，Linux CPU上还需要能import Triton。Thor需CUDA13兼容PyTorch/Triton版本，必须重新验证，不能直接装旧cu12依赖。源码PIN由脚本强制检查。

准备命令只供具备网络的环境执行，本次已用fetch_source.py尝试且失败：

```sh
# EveryDay根目录，源码与导出只落在忽略目录。
git clone --filter=blob:none --no-checkout https://github.com/jy-yuan/KIVI.git systems_practice/.tmp/quant_sources/kivi-pinned
git -C systems_practice/.tmp/quant_sources/kivi-pinned checkout 876b4d2d08e3b1d5f70d0969c299d8c7c42ddfb6
KIVI_REPO="$PWD/systems_practice/.tmp/quant_sources/kivi-pinned" DEVICE=cpu sh systems_practice/quantization/2026-10-04/kivi/run.sh
```

[native_example.py](native_example.py)包含真打包→build/native-cache.pt导出→weights_only重载→反量化→注意力比较、实际张量字节/文件字节及计时。没有下载模型。接入已有attention时，以已有K/V替换随机张量，保持B/head/时间/channel含义并把压缩prefix与recent residual分开；不能把Linear权重直接传给KV函数。示例是单次快照，没有声称实现完整流式缓存。流式模型接入应使用已读的`LlamaForCausalLM_KIVI`并先核对模型版本与缓存结构，不能拿此.pt当HuggingFace权重文件。

验收检查：export/reload张量逐项相等；注意力有限；固定输入误差；同一dtype/shape下比较；常量组由调用包装明确拒绝。上游低层实现scale=0未防护，不能把NaN静默当0。待做支持常量组的后端适配应保存min、code0且scale0，并全链路验证；独立候选已处理这一路，不表示原库已修复。

## 量化前后比较

| 对象 | 已实测 | 尚未实测 |
| --- | --- | --- |
| 原生KIVI FP16 KV vs INT2+metadata+残留 | 无，clone/torch缺失 | NRMSE、max_abs、实际Tensor字节、archive字节、在线pack/恢复+attention时间 |
| 独立QK存储/映射候选 | CPU Release/ASan/UBSan 964行、36shape、2非法输入通过 | Thor设备正确性、延迟、真实SASS |

原生例子若成功，会报告FP16缓存字节与所有8个导出张量的真实存储；不能忽略scale/min与FP16残留，也不能把.pt容器开销当kernel读流量。量测10次预热、31个独立调用，CUDA路径前后同步，属于主机framework调用时间，非单kernel/模型E2E。源码无可执行本地缓存，独立CPU PASS不填`cpu_example_run=true`。[逐项证据](verification.json)。

## Thor SM110 与优化

[OPTIMIZATION.md](OPTIMIZATION.md)提供完整`qk_base`/最终候选`qk_warp`、公平对照、ncu与ISA教程。候选真实2bit存储，FP32 Query和scale，FP32累加；只处理压缩K的QK阶段，省略V/softmax/流式残留，不能叫完整KIVI加速。原生full model运行依赖未验证。

```sh
sh systems_practice/quantization/2026-10-04/kivi/build.sh cpu
sh systems_practice/quantization/2026-10-04/kivi/build.sh sanitize
# 以下仅Thor设备：
sh systems_practice/quantization/2026-10-04/kivi/build.sh gpu
systems_practice/quantization/2026-10-04/kivi/build/qk all
sh systems_practice/quantization/2026-10-04/kivi/profile.sh warp
sh systems_practice/quantization/2026-10-04/kivi/export-isa.sh
```

原扩展只提供待验构建命令，不执行安装：在已准备的KIVI/quant工作目录，确认CUDA13工具链与PyTorch支持11.0后执行`TORCH_CUDA_ARCH_LIST="11.0" python3 setup.py build_ext --inplace`。其产物也应留在systems_practice/.tmp源码缓存。旧torch2.1.2不能被当成已支持Thor目标的证据。全部执行目标固定sm_110，无a/f后缀；其他架构仅理论比较。

## 工业故障、验收与追问

1. 存储减少但注意力误差激增：核对K是跨token、V是跨channel分组；注入固定channel离群再分别比较K/V误差。修复轴/布局，不用测试集选更大residual掩盖问题。
2. 零值padding产生NaN：检查max=min组；当前native包装拒绝，后端需专门零范围分支；回归全零、常量和非整组尾部。原函数要求整除，不能用裸尾块冒充支持。
3. 单kernel更快但解码慢：量测在线pack、transpose/contiguous、缓存拼接、attention与E2E；小上下文可能没有容量收益，允许保留FP16路径。

上线须核实device capability=11.0、实际扩展SASS目标、原库/torch/Triton版本、残留刷新边界、GQA head比、误差与任务指标、持续解码内存上界。追问：①为何K/V轴不同？②2bit为何不等于8倍总存储收益？③FP16残留何时刷新？④min与zero-point如何区分？⑤导出.pt是否可直接用于原CUDA GEMV？⑥SIMT解包和原生低位Tensor Core计算有何区别？

## 验证与待补

源码拉取否、固定commit实现网页读取是、原生使用示例交付是、CPU原生运行否、Thor验证否。真实失败日志分别为[依赖](results/final-dependencies.txt)、[native](results/final-native.txt)、[CUDA](results/final-gpu.txt)、[ncu](results/final-ncu.txt)、[ISA](results/final-isa.txt)。只重试一个旧AWQ：[失败记录](results/awq-retry.json)。获取和运行失败保留backlog，次日轮到8-bit optimizer states；同日不再推进。
